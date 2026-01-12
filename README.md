A Flutter card widget with front and multiple back sides that can be flipped with smooth animation effects.

<p>
  <img src="https://github.com/99robong/multi_flip_card/raw/main/screenshots/toggle.gif" width="200" />
  <img src="https://github.com/99robong/multi_flip_card/raw/main/screenshots/fliptoback.gif" width="200" />
  <img src="https://github.com/99robong/multi_flip_card/raw/main/screenshots/fliptoback1.gif" width="200" />
  <img src="https://github.com/99robong/multi_flip_card/raw/main/screenshots/vert_etc.gif" width="200" />
</p>

## Installation

```yaml
dependencies:
  multi_flip_card: ^0.0.3
```

## Basic Usage

### Preferred: Map backs (key-based)

Using `Map<String, Widget>` lets you flip by key, so inserting/reordering backs won't force you to update indices.

```dart
import 'package:multi_flip_card/multi_flip_card.dart';

final MultiFlipCardController controller = MultiFlipCardController();

MultiFlipCard(
  controller: controller,
  width: 300,
  height: 200,
  front: Container(
    decoration: BoxDecoration(
      color: Colors.blue,
      borderRadius: BorderRadius.circular(12),
    ),
    child: const Center(
      child: FlipTrigger(
        child: Text(
          'Front\n(Tap to flip)',
          style: TextStyle(color: Colors.white, fontSize: 18),
          textAlign: TextAlign.center,
        ),
      ),
    ),
  ),
  backs: const <String, Widget>{
    'details': Center(child: Text('Back: details')),
    'settings': Center(child: Text('Back: settings')),
  },
)

// Flip by key
controller.flipToBackKey('settings');
```

### Backward compatible: List backs (index-based)

```dart
import 'package:multi_flip_card/multi_flip_card.dart';

MultiFlipCard(
  width: 300,
  height: 200,
  front: Container(
    decoration: BoxDecoration(
      color: Colors.blue,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Center(
      child: FlipTrigger(
        child: Text(
          'Front\n(Tap to flip)',
          style: TextStyle(color: Colors.white, fontSize: 18),
          textAlign: TextAlign.center,
        ),
      ),
    ),
  ),
  backs: [
    Container(
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: FlipTrigger(
          action: FlipAction.flipToFront,
          child: Text(
            'Back\n(Tap to front)',
            style: TextStyle(color: Colors.white, fontSize: 18),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    ),
  ],
)
```

## Advanced Usage

### Programmatic Control with Controller

```dart
final MultiFlipCardController controller = MultiFlipCardController();

MultiFlipCard(
  controller: controller,
  front: MyFrontWidget(),
  backs: [MyBackWidget1(), MyBackWidget2()],
)

// Programmatic control
controller.flip();           // Toggle
controller.flipToFront();    // Flip to front
controller.flipToBack(1);    // Flip to specific back
controller.flipToBackKey('settings'); // Flip to specific back by key (Map backs mode)
```

### Multiple Backs with Selective Flipping

```dart
MultiFlipCard(
  front: MyFrontWidget(),
  backs: [
    MyBackWidget1(),
    MyBackWidget2(),
    MyBackWidget3(),
  ],
  // Different actions possible for each back
)
```

### Animation Curve Customization

```dart
MultiFlipCard(
  animationCurve: Curves.bounceInOut,     // Bounce effect
  animationDuration: Duration(milliseconds: 800),
  front: MyFrontWidget(),
  backs: [MyBackWidget()],
)

// Various animation curve examples
MultiFlipCard(
  animationCurve: Curves.elasticInOut,    // Elastic effect
  front: MyFrontWidget(),
  backs: [MyBackWidget()],
)

MultiFlipCard(
  animationCurve: Curves.fastOutSlowIn,   // Fast start, slow end
  front: MyFrontWidget(),
  backs: [MyBackWidget()],
)
```

### Vertical Flip Animation

```dart
MultiFlipCard(
  direction: FlipDirection.vertical,
  front: MyFrontWidget(),
  backs: [MyBackWidget()],
)
```

## FlipTrigger Usage

`FlipTrigger` adds touch events to child widgets to enable card flipping:

```dart
FlipTrigger(
  action: FlipAction.toggle,    // Toggle (default)
  child: YourWidget(),
)

FlipTrigger(
  action: FlipAction.flipToFront,  // Flip to front
  child: YourWidget(),
)

FlipTrigger(
  action: FlipAction.flipToBack,   // Flip to specific back
  backIndex: 2,
  child: YourWidget(),
)

FlipTrigger(
  action: FlipAction.flipToBack,   // Flip to specific back by key (Map backs mode)
  backKey: 'settings',
  child: YourWidget(),
)
```

## Control Methods

This package provides multiple ways to control the card:

1. **FlipTrigger**: Touch control from within widgets
2. **MultiFlipCardController**: Programmatic control
3. **InheritedWidget**: Access parent card from child widgets

## API Reference

### MultiFlipCard

| Property          | Type                                | Description                                 |
| ----------------- | ----------------------------------- | ------------------------------------------- |
| front             | Widget                              | Front widget                                |
| backs             | List<Widget> or Map<String, Widget> | Back widgets (Map is recommended)           |
| controller        | MultiFlipCardController?            | Controller                                  |
| direction         | FlipDirection                       | Flip direction (horizontal/vertical)        |
| animationDuration | Duration                            | Animation duration                          |
| animationCurve    | Curve                               | Animation curve (default: Curves.easeInOut) |
| width             | double?                             | Card width                                  |
| height            | double?                             | Card height                                 |
| isFlipped         | bool                                | Initial flipped state                       |
| onFlip            | VoidCallback?                       | Callback when flipped                       |

Notes:

- Map backs uses insertion order.
- Invalid key/index logs via `developer.log` and falls back to the first entry / index 0.
- If backs is empty, flipping is a no-op and keeps showing front.

### MultiFlipCardController

| Method                    | Description                                   |
| ------------------------- | --------------------------------------------- |
| flip()                    | Toggle card                                   |
| flipToFront()             | Flip to front                                 |
| flipToBack(int index)     | Flip to specific back                         |
| flipToBackKey(String key) | Flip to specific back by key (Map backs mode) |
| isFlipped                 | Current flipped state                         |
| currentBackIndex          | Current back index                            |
| currentBackKey            | Current back key (Map backs mode)             |

### FlipAction

- `FlipAction.toggle`: Toggle front/back
- `FlipAction.flipToFront`: Flip to front
- `FlipAction.flipToBack`: Flip to back

## Examples

Check the `/example` folder for more detailed examples.

## License

This project is licensed under the MIT License.
