import 'package:flutter/material.dart';
import 'package:multi_flip_card/multi_flip_card.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Multi Flip Card Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final MultiFlipCardController _controller = MultiFlipCardController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Multi Flip Card Demo')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 기본 사용법 - 앞면과 뒷면이 있는 카드
            MultiFlipCard(
              width: 300,
              height: 200,
              controller: _controller,
              front: Container(
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: FlipTrigger(
                    child: Text(
                      '앞면\n(탭해서 뒤집기)',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
              backs: [
                // 첫 번째 뒷면
                Container(
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Center(
                    child: FlipTrigger(
                      action: FlipAction.flipToFront,
                      child: Text(
                        '뒷면 1\n(탭해서 앞면으로)',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
                // 두 번째 뒷면
                Container(
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        '뒷면 2',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          FlipTrigger(
                            action: FlipAction.flipToFront,
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Text(
                                '앞면으로',
                                style: TextStyle(color: Colors.green),
                              ),
                            ),
                          ),
                          FlipTrigger(
                            action: FlipAction.flipToBack,
                            backIndex: 0,
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Text(
                                '뒷면 1로',
                                style: TextStyle(color: Colors.green),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // 세 번째 뒷면
                Container(
                  decoration: BoxDecoration(
                    color: Colors.purple,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Center(
                    child: FlipTrigger(
                      child: Text(
                        '뒷면 3\n(토글)',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
            // 컨트롤러를 통한 프로그래밍 방식 제어
            Wrap(
              spacing: 10,
              children: [
                ElevatedButton(
                  onPressed: () => _controller.flip(),
                  child: const Text('토글'),
                ),
                ElevatedButton(
                  onPressed: () => _controller.flipToFront(),
                  child: const Text('앞면으로'),
                ),
                ElevatedButton(
                  onPressed: () => _controller.flipToBack(0),
                  child: const Text('뒷면 1'),
                ),
                ElevatedButton(
                  onPressed: () => _controller.flipToBack(1),
                  child: const Text('뒷면 2'),
                ),
                ElevatedButton(
                  onPressed: () => _controller.flipToBack(2),
                  child: const Text('뒷면 3'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // 세로 뒤집기 카드
            MultiFlipCard(
              width: 200,
              height: 150,
              direction: FlipDirection.vertical,
              animationCurve: Curves.bounceInOut, // 바운스 애니메이션
              front: Container(
                decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: FlipTrigger(
                    child: Text(
                      '세로 뒤집기\n앞면\n(바운스 애니메이션)',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
              backs: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.teal,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Center(
                    child: FlipTrigger(
                      child: Text(
                        '세로 뒤집기\n뒷면\n(바운스 애니메이션)',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // 다른 애니메이션 곡선 예제들
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // 탄성 애니메이션
                MultiFlipCard(
                  width: 120,
                  height: 80,
                  animationCurve: Curves.elasticInOut,
                  animationDuration: const Duration(milliseconds: 1000),
                  front: Container(
                    decoration: BoxDecoration(
                      color: Colors.purple,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Center(
                      child: FlipTrigger(
                        child: Text(
                          '탄성',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  backs: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.pink,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Center(
                        child: FlipTrigger(
                          child: Text(
                            'Elastic',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                // 빠른 애니메이션
                MultiFlipCard(
                  width: 120,
                  height: 80,
                  animationCurve: Curves.fastOutSlowIn,
                  animationDuration: const Duration(milliseconds: 300),
                  front: Container(
                    decoration: BoxDecoration(
                      color: Colors.indigo,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Center(
                      child: FlipTrigger(
                        child: Text(
                          '빠름',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  backs: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.cyan,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Center(
                        child: FlipTrigger(
                          child: Text(
                            'Fast',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
