import 'package:flutter/material.dart';
import 'package:release_to_trigger/release_to_trigger.dart';

void main() {
  runApp(const DartPadExampleApp());
}

class DartPadExampleApp extends StatelessWidget {
  const DartPadExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal,
          brightness: Brightness.dark,
        ),
      ),
      home: const GestureRevealScreen(),
    );
  }
}

class GestureRevealScreen extends StatefulWidget {
  const GestureRevealScreen({super.key});

  @override
  State<GestureRevealScreen> createState() => _GestureRevealScreenState();
}

class _GestureRevealScreenState extends State<GestureRevealScreen> {
  bool _revealed = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pull-To-Reveal Demo'),
        centerTitle: true,
        actions: [
          if (_revealed)
            IconButton(
              icon: const Icon(Icons.lock),
              onPressed: () => setState(() => _revealed = false),
            ),
        ],
      ),
      body: ReleaseToTrigger(
        backgroundColor: Colors.teal.withAlpha(25),
        progressColor: Colors.teal,
        initialText: 'Hold and swipe down to reveal',
        triggeredText: 'Release to reveal hidden view',
        triggerHeight: 180.0,
        pullSensitivityHeight: 200.0,
        requireLongPressBeforePull: true,
        longPressDuration: const Duration(milliseconds: 600),
        onTrigger: () {
          setState(() {
            _revealed = true;
          });
        },
        child: Center(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            child: _revealed
                ? Card(
                    key: const ValueKey('unlocked'),
                    color: Colors.teal.shade800,
                    margin: const EdgeInsets.all(24),
                    child: const Padding(
                      padding: EdgeInsets.all(32.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.emoji_objects, size: 64, color: Colors.yellow),
                          SizedBox(height: 16),
                          Text(
                            'Easter Egg Unlocked!',
                            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'You successfully completed the hold-then-swipe gesture primitive.',
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  )
                : const Column(
                    key: ValueKey('locked'),
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.security, size: 80, color: Colors.teal),
                      SizedBox(height: 16),
                      Text(
                        'Content Locked',
                        style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Press & hold for 0.6s, then pull down',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
