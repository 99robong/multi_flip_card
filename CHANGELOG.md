## 0.0.1

- Initial release of Multi Flip Card package
- Support for front and multiple back widgets
- Smooth flip animations with customizable curves
- Horizontal and vertical flip directions
- Programmatic control via MultiFlipCardController
- Touch-based control via FlipTrigger widget
- Customizable animation duration and curves
- InheritedWidget support for nested control

## 0.0.2

- Add demo video

## 0.0.3

- absolute image url

## 0.1.0

- Add `backs` Map support: `Map<String, Widget>` (recommended) while keeping `List<Widget>` backward compatible
- Add key-based flipping: `FlipTrigger(backKey: ...)` and `MultiFlipCardController.flipToBackKey(...)`
- Invalid key/index handling: `developer.log` + fallback to first entry/index 0
- Empty backs behavior: flip becomes no-op and keeps showing front

## 0.1.1

- Docs: fix README installation version
