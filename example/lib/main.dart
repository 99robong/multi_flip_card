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
  final MultiFlipCardController _mapController = MultiFlipCardController();
  final MultiFlipCardController _listController = MultiFlipCardController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Multi Flip Card Demo')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Preferred usage - Map backs (key-based)
            MultiFlipCard(
              width: 300,
              height: 200,
              controller: _mapController,
              front: Container(
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: FlipTrigger(
                    child: Text(
                      'Front (Map backs)\n(Tap to flip)',
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
              backs: {
                // Key order defines the "first entry" fallback.
                'details': Container(
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Center(
                    child: FlipTrigger(
                      action: FlipAction.flipToFront,
                      child: Text(
                        'Back: details\n(Tap to front)',
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
                'settings': Container(
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Back: settings',
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
                                'To Front',
                                style: TextStyle(color: Colors.green),
                              ),
                            ),
                          ),
                          FlipTrigger(
                            action: FlipAction.flipToBack,
                            backKey: 'details',
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Text(
                                'To details',
                                style: TextStyle(color: Colors.green),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                'about': Container(
                  decoration: BoxDecoration(
                    color: Colors.purple,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Center(
                    child: FlipTrigger(
                      child: Text(
                        'Back: about\n(Toggle)',
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
              },
            ),
            const SizedBox(height: 40),
            // Programmatic control via controller (Map backs)
            Wrap(
              spacing: 10,
              children: [
                ElevatedButton(
                  onPressed: () => _mapController.flip(),
                  child: const Text('Toggle'),
                ),
                ElevatedButton(
                  onPressed: () => _mapController.flipToFront(),
                  child: const Text('To Front'),
                ),
                ElevatedButton(
                  onPressed: () => _mapController.flipToBackKey('details'),
                  child: const Text('details'),
                ),
                ElevatedButton(
                  onPressed: () => _mapController.flipToBackKey('settings'),
                  child: const Text('settings'),
                ),
                ElevatedButton(
                  onPressed: () => _mapController.flipToBackKey('about'),
                  child: const Text('about'),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Backward compatible usage - List backs (index-based)
            MultiFlipCard(
              width: 300,
              height: 140,
              controller: _listController,
              front: Container(
                decoration: BoxDecoration(
                  color: Colors.black87,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: FlipTrigger(
                    child: Text(
                      'Front (List backs)\n(Tap to flip)',
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
                    color: Colors.blueGrey,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Center(
                    child: FlipTrigger(
                      action: FlipAction.flipToFront,
                      child: Text(
                        'Back 0\n(Tap to front)',
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
                Container(
                  decoration: BoxDecoration(
                    color: Colors.brown,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Center(
                    child: Text(
                      'Back 1',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Vertical flip card
            MultiFlipCard(
              width: 200,
              height: 150,
              direction: FlipDirection.vertical,
              animationCurve: Curves.bounceInOut, // Bounce animation
              front: Container(
                decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: FlipTrigger(
                    child: Text(
                      'Vertical Flip\nFront\n(Bounce Animation)',
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
                        'Vertical Flip\nBack\n(Bounce Animation)',
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
            // Different animation curve examples
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Elastic animation
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
                // Fast animation
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
