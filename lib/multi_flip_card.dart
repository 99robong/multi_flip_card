import 'package:flutter/material.dart';

/// A multi flip card widget that can flip between front and multiple back widgets
/// with smooth animation effects.
class MultiFlipCard extends StatefulWidget {
  /// The front widget of the card
  final Widget front;

  /// The list of back widgets (can be multiple widgets)
  final List<Widget> backs;

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
    required this.backs,
    this.animationDuration = const Duration(milliseconds: 600),
    this.direction = FlipDirection.horizontal,
    this.animationCurve = Curves.easeInOut,
    this.controller,
    this.onFlip,
    this.isFlipped = false,
    this.width,
    this.height,
  });

  @override
  State<MultiFlipCard> createState() => _MultiFlipCardState();
}

class _MultiFlipCardState extends State<MultiFlipCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  bool _isFlipped = false;
  int _currentBackIndex = 0;

  @override
  void initState() {
    super.initState();
    _isFlipped = widget.isFlipped;
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
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _flip() {
    if (_animationController.isAnimating) return;

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

  void _flipToBack(int index) {
    if (_animationController.isAnimating) return;
    if (index < 0 || index >= widget.backs.length) return;

    setState(() {
      _currentBackIndex = index;
      _isFlipped = true;
    });

    _animationController.forward();
    widget.onFlip?.call();
  }

  void _flipToFront() {
    if (_animationController.isAnimating) return;

    setState(() {
      _isFlipped = false;
    });

    _animationController.reverse();
    widget.onFlip?.call();
  }

  Widget _buildCard() {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        final isShowingFront = _animation.value < 0.5;

        if (isShowingFront) {
          // 앞면을 보여줄 때 (0도 ~ 90도)
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
          // 뒷면을 보여줄 때 (90도 ~ 180도)
          return Transform(
            alignment: Alignment.center,
            transform: _getBackTransform(),
            child: SizedBox(
              width: widget.width,
              height: widget.height,
              child:
                  widget.backs.isNotEmpty
                      ? widget.backs[_currentBackIndex % widget.backs.length]
                      : const SizedBox(),
            ),
          );
        }
      },
    );
  }

  Matrix4 _getFrontTransform() {
    final rotationValue = _animation.value * 3.14159; // 0~1을 0~π 라디안으로 매핑

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
    final rotationValue = _animation.value * 3.14159; // 0~1을 0~π 라디안으로 매핑

    switch (widget.direction) {
      case FlipDirection.horizontal:
        return Matrix4.identity()
          ..setEntry(3, 2, 0.001) // perspective
          ..rotateY(rotationValue + 3.14159); // π를 더해서 뒷면이 되도록
      case FlipDirection.vertical:
        return Matrix4.identity()
          ..setEntry(3, 2, 0.001) // perspective
          ..rotateX(rotationValue + 3.14159); // π를 더해서 뒷면이 되도록
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
    _state?._flipToBack(index);
  }

  /// Flip to the front widget
  void flipToFront() {
    _state?._flipToFront();
  }

  /// Check if the card is currently flipped
  bool get isFlipped => _state?._isFlipped ?? false;

  /// Get the current back widget index
  int get currentBackIndex => _state?._currentBackIndex ?? 0;
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

  const FlipTrigger({
    super.key,
    required this.child,
    this.action = FlipAction.toggle,
    this.backIndex,
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
            if (backIndex != null) {
              flipCard?._flipToBack(backIndex!);
            } else {
              flipCard?._flip();
            }
            break;
        }
      },
      child: child,
    );
  }
}

/// Actions that can be performed when FlipTrigger is tapped
enum FlipAction { toggle, flipToFront, flipToBack }
