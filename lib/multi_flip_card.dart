import 'package:flutter/material.dart';
import 'dart:collection';
import 'dart:developer' as developer;

/// A multi flip card widget that can flip between front and multiple back widgets
/// with smooth animation effects.
class MultiFlipCard extends StatefulWidget {
  /// The front widget of the card
  final Widget front;

  /// The back widgets of the card.
  ///
  /// Supports both:
  /// - `List<Widget>` (backward compatible)
  /// - `Map<String, Widget>` (recommended; key-based access)
  ///
  /// Note: In Map mode, selecting a specific back by index is not supported.
  final Object _backs;

  /// Duration of the flip animation
  final Duration animationDuration;

  /// The direction of the flip animation
  final FlipDirection direction;

  /// The curve of the flip animation
  final Curve animationCurve;

  /// Controller to programmatically control the flip card
  final MultiFlipCardController? controller;

  /// Callback when the card is flipped
  final VoidCallback? onFlip;

  /// Whether the card should start flipped (showing back)
  final bool isFlipped;

  /// Width of the card
  final double? width;

  /// Height of the card
  final double? height;

  const MultiFlipCard({
    super.key,
    required this.front,
    required Object backs,
    this.animationDuration = const Duration(milliseconds: 600),
    this.direction = FlipDirection.horizontal,
    this.animationCurve = Curves.easeInOut,
    this.controller,
    this.onFlip,
    this.isFlipped = false,
    this.width,
    this.height,
  }) : _backs = backs;

  /// Backward compatible list view of backs.
  ///
  /// - List mode: returns the original backs list.
  /// - Map mode: returns backs values in iteration order.
  List<Widget> get backs => _ResolvedBacks.resolve(_backs).list;

  /// Map view of backs when provided as `Map<String, Widget>`.
  /// Returns null in List mode or if the input is invalid.
  Map<String, Widget>? get backsByKey => _ResolvedBacks.resolve(_backs).map;

  @override
  State<MultiFlipCard> createState() => _MultiFlipCardState();
}

enum _BacksMode { list, map, invalid }

class _ResolvedBacks {
  final _BacksMode mode;
  final List<Widget> list;
  final LinkedHashMap<String, Widget>? map;

  const _ResolvedBacks._({
    required this.mode,
    required this.list,
    required this.map,
  });

  bool get isMap => mode == _BacksMode.map;

  bool get hasAny => isMap ? (map?.isNotEmpty ?? false) : list.isNotEmpty;

  List<String> get keysInOrder {
    final currentMap = map;
    if (currentMap == null) return const <String>[];
    return currentMap.keys.toList(growable: false);
  }

  static _ResolvedBacks resolve(Object input) {
    if (input is Map) {
      final resolvedMap = LinkedHashMap<String, Widget>();

      for (final entry in input.entries) {
        final key = entry.key;
        final value = entry.value;

        if (key is! String || value is! Widget) {
          developer.log(
            'Invalid backs map entry. Expected Map<String, Widget>. Got key=${key.runtimeType}, value=${value.runtimeType}.',
            name: 'multi_flip_card',
          );
          return const _ResolvedBacks._(
            mode: _BacksMode.invalid,
            list: <Widget>[],
            map: null,
          );
        }

        resolvedMap[key] = value;
      }

      return _ResolvedBacks._(
        mode: _BacksMode.map,
        list: resolvedMap.values.toList(growable: false),
        map: resolvedMap,
      );
    }

    if (input is List) {
      for (final element in input) {
        if (element is! Widget) {
          developer.log(
            'Invalid backs list element. Expected List<Widget>. Got element=${element.runtimeType}.',
            name: 'multi_flip_card',
          );
          return const _ResolvedBacks._(
            mode: _BacksMode.invalid,
            list: <Widget>[],
            map: null,
          );
        }
      }

      final list = input.cast<Widget>().toList(growable: false);
      return _ResolvedBacks._(mode: _BacksMode.list, list: list, map: null);
    }

    developer.log(
      'Invalid backs type. Expected List<Widget> or Map<String, Widget>. Got ${input.runtimeType}.',
      name: 'multi_flip_card',
    );
    return const _ResolvedBacks._(
      mode: _BacksMode.invalid,
      list: <Widget>[],
      map: null,
    );
  }
}

class _MultiFlipCardState extends State<MultiFlipCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  bool _isFlipped = false;
  int _currentBackIndex = 0;
  String? _currentBackKey;
  late _ResolvedBacks _resolvedBacks;

  @override
  void initState() {
    super.initState();
    _resolvedBacks = _ResolvedBacks.resolve(widget._backs);
    _initializeSelectionForBacks();
    _isFlipped = widget.isFlipped && _resolvedBacks.hasAny;
    _animationController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: widget.animationCurve,
      ),
    );

    // Initialize controller if provided
    widget.controller?._setState(this);

    if (_isFlipped) {
      _animationController.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(covariant MultiFlipCard oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (!identical(oldWidget._backs, widget._backs)) {
      _resolvedBacks = _ResolvedBacks.resolve(widget._backs);
      _reconcileSelectionAfterBacksUpdate();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _flip() {
    if (_animationController.isAnimating) return;
    if (!_resolvedBacks.hasAny) return;

    setState(() {
      _isFlipped = !_isFlipped;
    });

    if (_isFlipped) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }

    widget.onFlip?.call();
  }

  void _flipToBackIndex(int index) {
    if (_animationController.isAnimating) return;
    if (!_resolvedBacks.hasAny) return;

    if (_resolvedBacks.isMap) {
      developer.log(
        'flipToBack(index) is not supported in Map backs mode. Falling back to the first entry.',
        name: 'multi_flip_card',
      );
      _selectFirstBackAsFallback();
      _ensureFlippedToBack();
      widget.onFlip?.call();
      return;
    }

    final backsList = _resolvedBacks.list;
    int resolvedIndex = index;
    if (resolvedIndex < 0 || resolvedIndex >= backsList.length) {
      developer.log(
        'Back index out of range: $index. Falling back to index 0.',
        name: 'multi_flip_card',
      );
      resolvedIndex = 0;
    }

    setState(() {
      _currentBackIndex = resolvedIndex;
      _currentBackKey = null;
      _isFlipped = true;
    });

    _animationController.forward();
    widget.onFlip?.call();
  }

  void _flipToBackKey(String key) {
    if (_animationController.isAnimating) return;
    if (!_resolvedBacks.hasAny) return;

    if (!_resolvedBacks.isMap) {
      developer.log(
        'flipToBackKey(key) is not supported in List backs mode. Falling back to index 0.',
        name: 'multi_flip_card',
      );
      _selectFirstBackAsFallback();
      _ensureFlippedToBack();
      widget.onFlip?.call();
      return;
    }

    final backsMap = _resolvedBacks.map!;
    String resolvedKey = key;
    if (!backsMap.containsKey(resolvedKey)) {
      developer.log(
        "Back key does not exist: '$key'. Falling back to the first entry.",
        name: 'multi_flip_card',
      );
      resolvedKey = backsMap.entries.first.key;
    }

    final keys = _resolvedBacks.keysInOrder;
    final resolvedIndex = keys.indexOf(resolvedKey);

    setState(() {
      _currentBackKey = resolvedKey;
      _currentBackIndex = resolvedIndex < 0 ? 0 : resolvedIndex;
      _isFlipped = true;
    });

    _animationController.forward();
    widget.onFlip?.call();
  }

  void _flipToFront() {
    if (_animationController.isAnimating) return;
    if (!_isFlipped) return;

    setState(() {
      _isFlipped = false;
    });

    _animationController.reverse();
    widget.onFlip?.call();
  }

  void _ensureFlippedToBack() {
    setState(() {
      _isFlipped = true;
    });
    _animationController.forward();
  }

  void _selectFirstBackAsFallback() {
    if (!_resolvedBacks.hasAny) return;

    if (_resolvedBacks.isMap) {
      final backsMap = _resolvedBacks.map!;
      final firstKey = backsMap.entries.first.key;
      setState(() {
        _currentBackKey = firstKey;
        _currentBackIndex = 0;
      });
      return;
    }

    setState(() {
      _currentBackKey = null;
      _currentBackIndex = 0;
    });
  }

  void _initializeSelectionForBacks() {
    if (!_resolvedBacks.hasAny) {
      _currentBackIndex = 0;
      _currentBackKey = null;
      return;
    }

    if (_resolvedBacks.isMap) {
      final firstKey = _resolvedBacks.map!.entries.first.key;
      _currentBackIndex = 0;
      _currentBackKey = firstKey;
      return;
    }

    _currentBackIndex = 0;
    _currentBackKey = null;
  }

  void _reconcileSelectionAfterBacksUpdate() {
    if (!_resolvedBacks.hasAny) {
      if (_isFlipped) {
        setState(() {
          _isFlipped = false;
          _currentBackIndex = 0;
          _currentBackKey = null;
        });
        _animationController.value = 0.0;
      } else {
        _currentBackIndex = 0;
        _currentBackKey = null;
      }
      return;
    }

    if (_resolvedBacks.isMap) {
      final backsMap = _resolvedBacks.map!;
      final currentKey = _currentBackKey;
      if (currentKey != null && backsMap.containsKey(currentKey)) {
        final keys = _resolvedBacks.keysInOrder;
        final newIndex = keys.indexOf(currentKey);
        _currentBackIndex = newIndex < 0 ? 0 : newIndex;
        return;
      }

      if (_isFlipped &&
          currentKey != null &&
          !backsMap.containsKey(currentKey)) {
        developer.log(
          "Current back key no longer exists: '$currentKey'. Falling back to the first entry.",
          name: 'multi_flip_card',
        );
      }

      _initializeSelectionForBacks();
      return;
    }

    final backsList = _resolvedBacks.list;
    if (_currentBackIndex >= 0 && _currentBackIndex < backsList.length) {
      _currentBackKey = null;
      return;
    }

    if (_isFlipped) {
      developer.log(
        'Current back index is out of range after backs update. Falling back to index 0.',
        name: 'multi_flip_card',
      );
    }
    _currentBackIndex = 0;
    _currentBackKey = null;
  }

  Widget _currentBackWidget() {
    if (!_resolvedBacks.hasAny) return const SizedBox();

    if (_resolvedBacks.isMap) {
      final backsMap = _resolvedBacks.map!;
      final key = _currentBackKey;
      if (key != null && backsMap.containsKey(key)) {
        return backsMap[key]!;
      }
      return backsMap.entries.first.value;
    }

    final backsList = _resolvedBacks.list;
    if (_currentBackIndex >= 0 && _currentBackIndex < backsList.length) {
      return backsList[_currentBackIndex];
    }
    return backsList.first;
  }

  Widget _buildCard() {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        final isShowingFront = _animation.value < 0.5;

        if (isShowingFront) {
          // Show front side (0° ~ 90°)
          return Transform(
            alignment: Alignment.center,
            transform: _getFrontTransform(),
            child: SizedBox(
              width: widget.width,
              height: widget.height,
              child: widget.front,
            ),
          );
        } else {
          // Show back side (90° ~ 180°)
          return Transform(
            alignment: Alignment.center,
            transform: _getBackTransform(),
            child: SizedBox(
              width: widget.width,
              height: widget.height,
              child: _currentBackWidget(),
            ),
          );
        }
      },
    );
  }

  Matrix4 _getFrontTransform() {
    final rotationValue = _animation.value * 3.14159; // Map 0~1 to 0~π radians

    switch (widget.direction) {
      case FlipDirection.horizontal:
        return Matrix4.identity()
          ..setEntry(3, 2, 0.001) // perspective
          ..rotateY(rotationValue);
      case FlipDirection.vertical:
        return Matrix4.identity()
          ..setEntry(3, 2, 0.001) // perspective
          ..rotateX(rotationValue);
    }
  }

  Matrix4 _getBackTransform() {
    final rotationValue = _animation.value * 3.14159; // Map 0~1 to 0~π radians

    switch (widget.direction) {
      case FlipDirection.horizontal:
        return Matrix4.identity()
          ..setEntry(3, 2, 0.001) // perspective
          ..rotateY(rotationValue + 3.14159); // Add π to make it back side
      case FlipDirection.vertical:
        return Matrix4.identity()
          ..setEntry(3, 2, 0.001) // perspective
          ..rotateX(rotationValue + 3.14159); // Add π to make it back side
    }
  }

  @override
  Widget build(BuildContext context) {
    return FlipCardInheritedWidget(flipCard: this, child: _buildCard());
  }
}

/// Direction for the flip animation
enum FlipDirection { horizontal, vertical }

/// Controller to programmatically control the MultiFlipCard
class MultiFlipCardController {
  _MultiFlipCardState? _state;

  void _setState(_MultiFlipCardState state) {
    _state = state;
  }

  /// Flip the card (toggle between front and back)
  void flip() {
    _state?._flip();
  }

  /// Flip to a specific back widget by index
  void flipToBack(int index) {
    _state?._flipToBackIndex(index);
  }

  /// Flip to a specific back widget by key (Map backs mode)
  void flipToBackKey(String key) {
    _state?._flipToBackKey(key);
  }

  /// Flip to the front widget
  void flipToFront() {
    _state?._flipToFront();
  }

  /// Check if the card is currently flipped
  bool get isFlipped => _state?._isFlipped ?? false;

  /// Get the current back widget index
  int get currentBackIndex => _state?._currentBackIndex ?? 0;

  /// Get the current back widget key (Map backs mode). Returns null in List mode.
  String? get currentBackKey => _state?._currentBackKey;
}

/// Inherited widget to provide flip functionality to child widgets
class FlipCardInheritedWidget extends InheritedWidget {
  final _MultiFlipCardState flipCard;

  const FlipCardInheritedWidget({
    super.key,
    required this.flipCard,
    required super.child,
  });

  static _MultiFlipCardState? of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<FlipCardInheritedWidget>()
        ?.flipCard;
  }

  @override
  bool updateShouldNotify(FlipCardInheritedWidget oldWidget) {
    return flipCard != oldWidget.flipCard;
  }
}

/// Widget that can trigger flip when tapped
class FlipTrigger extends StatelessWidget {
  final Widget child;
  final FlipAction action;
  final int? backIndex;
  final String? backKey;

  const FlipTrigger({
    super.key,
    required this.child,
    this.action = FlipAction.toggle,
    this.backIndex,
    this.backKey,
  });

  @override
  Widget build(BuildContext context) {
    final flipCard = FlipCardInheritedWidget.of(context);

    return GestureDetector(
      onTap: () {
        switch (action) {
          case FlipAction.toggle:
            flipCard?._flip();
            break;
          case FlipAction.flipToFront:
            flipCard?._flipToFront();
            break;
          case FlipAction.flipToBack:
            if (backKey != null) {
              flipCard?._flipToBackKey(backKey!);
              break;
            }
            if (backIndex != null) {
              flipCard?._flipToBackIndex(backIndex!);
              break;
            }
            flipCard?._flip();
            break;
        }
      },
      child: child,
    );
  }
}

/// Actions that can be performed when FlipTrigger is tapped
enum FlipAction { toggle, flipToFront, flipToBack }
