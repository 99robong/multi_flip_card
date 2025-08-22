<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/tools/pub/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/to/develop-packages).
-->

# Multi Flip Card

앞면과 여러 개의 뒷면을 가진 Flutter 카드 위젯으로, 부드러운 애니메이션과 함께 뒤집을 수 있습니다.

## 특징

- 🎴 앞면과 여러 개의 뒷면 지원
- 🎯 프로그래밍 방식 또는 터치를 통한 제어
- 🎨 가로/세로 뒤집기 애니메이션
- 🎛️ 유연한 제어 옵션
- 📱 완전한 커스터마이징 가능

## 설치

```yaml
dependencies:
  multi_flip_card: ^0.0.1
```

## 기본 사용법

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
          '앞면\n(탭해서 뒤집기)',
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
            '뒷면\n(탭해서 앞면으로)',
            style: TextStyle(color: Colors.white, fontSize: 18),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    ),
  ],
)
```

## 고급 사용법

### 컨트롤러를 사용한 프로그래밍 제어

```dart
final MultiFlipCardController controller = MultiFlipCardController();

MultiFlipCard(
  controller: controller,
  front: MyFrontWidget(),
  backs: [MyBackWidget1(), MyBackWidget2()],
)

// 프로그래밍 방식으로 제어
controller.flip();           // 토글
controller.flipToFront();    // 앞면으로
controller.flipToBack(1);    // 특정 뒷면으로
```

### 여러 뒷면과 선택적 뒤집기

```dart
MultiFlipCard(
  front: MyFrontWidget(),
  backs: [
    MyBackWidget1(),
    MyBackWidget2(),
    MyBackWidget3(),
  ],
  // 각 뒷면에서 다른 동작 가능
)
```

### 애니메이션 곡선 커스터마이징

```dart
MultiFlipCard(
  animationCurve: Curves.bounceInOut,     // 바운스 효과
  animationDuration: Duration(milliseconds: 800),
  front: MyFrontWidget(),
  backs: [MyBackWidget()],
)

// 다양한 애니메이션 곡선 예제
MultiFlipCard(
  animationCurve: Curves.elasticInOut,    // 탄성 효과
  front: MyFrontWidget(),
  backs: [MyBackWidget()],
)

MultiFlipCard(
  animationCurve: Curves.fastOutSlowIn,   // 빠른 시작, 천천히 끝
  front: MyFrontWidget(),
  backs: [MyBackWidget()],
)
```

### 세로 뒤집기 애니메이션

```dart
MultiFlipCard(
  direction: FlipDirection.vertical,
  front: MyFrontWidget(),
  backs: [MyBackWidget()],
)
```

## FlipTrigger 사용법

`FlipTrigger`는 자식 위젯에 터치 이벤트를 추가하여 카드를 뒤집을 수 있게 해줍니다:

```dart
FlipTrigger(
  action: FlipAction.toggle,    // 토글 (기본값)
  child: YourWidget(),
)

FlipTrigger(
  action: FlipAction.flipToFront,  // 앞면으로
  child: YourWidget(),
)

FlipTrigger(
  action: FlipAction.flipToBack,   // 특정 뒷면으로
  backIndex: 2,
  child: YourWidget(),
)
```

## 제어 방법들

이 패키지는 여러 가지 방법으로 카드를 제어할 수 있습니다:

1. **FlipTrigger**: 위젯 내부에서 터치로 제어
2. **MultiFlipCardController**: 프로그래밍 방식으로 제어
3. **InheritedWidget**: 하위 위젯에서 상위 카드에 접근

## API 참조

### MultiFlipCard

| 속성              | 타입                     | 설명                                       |
| ----------------- | ------------------------ | ------------------------------------------ |
| front             | Widget                   | 앞면 위젯                                  |
| backs             | List<Widget>             | 뒷면 위젯들                                |
| controller        | MultiFlipCardController? | 컨트롤러                                   |
| direction         | FlipDirection            | 뒤집기 방향 (horizontal/vertical)          |
| animationDuration | Duration                 | 애니메이션 지속 시간                       |
| animationCurve    | Curve                    | 애니메이션 곡선 (기본값: Curves.easeInOut) |
| width             | double?                  | 카드 너비                                  |
| height            | double?                  | 카드 높이                                  |
| isFlipped         | bool                     | 초기 뒤집힘 상태                           |
| onFlip            | VoidCallback?            | 뒤집힐 때 콜백                             |

### MultiFlipCardController

| 메서드                | 설명                 |
| --------------------- | -------------------- |
| flip()                | 카드 토글            |
| flipToFront()         | 앞면으로 뒤집기      |
| flipToBack(int index) | 특정 뒷면으로 뒤집기 |
| isFlipped             | 현재 뒤집힘 상태     |
| currentBackIndex      | 현재 뒷면 인덱스     |

### FlipAction

- `FlipAction.toggle`: 앞면/뒷면 토글
- `FlipAction.flipToFront`: 앞면으로 뒤집기
- `FlipAction.flipToBack`: 뒷면으로 뒤집기

## 예제

더 자세한 예제는 `/example` 폴더를 확인하세요.

## 라이센스

이 프로젝트는 MIT 라이센스를 따릅니다.
