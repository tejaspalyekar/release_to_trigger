import 'package:flutter/material.dart';
import 'package:release_to_trigger/release_to_trigger.dart';

void main() {
  runApp(const DemoApp());
}

class DemoApp extends StatelessWidget {
  const DemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const PrivateFolderDemo(),
    );
  }
}

// Private Folder Demo
class PrivateFolderDemo extends StatefulWidget {
  const PrivateFolderDemo({super.key});

  @override
  State<PrivateFolderDemo> createState() => _PrivateFolderDemoState();
}

class _PrivateFolderDemoState extends State<PrivateFolderDemo> {
  bool _isPrivateVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Private Folder Demo'),
        backgroundColor: _isPrivateVisible ? Colors.purple : null,
      ),
      body: ReleaseToTrigger(
        hapticFeedback: true,
        backgroundColor: Colors.purple.withAlpha(30),
        progressColor: Colors.purple,
        initialText: 'Pull down to reveal private content',
        triggeredText: 'Release to toggle private folder',
        triggerHeight: 200,
        onTrigger: () {
          setState(() {
            _isPrivateVisible = !_isPrivateVisible;
          });
        },
        child:
            _isPrivateVisible ? _buildPrivateContent() : _buildPublicContent(),
      ),
    );
  }

  Widget _buildPublicContent() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.lock, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          const Text(
            'Pull down from top to reveal\nprivate content',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildPrivateContent() {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: 8,
      itemBuilder: (context, index) {
        return Card(
          elevation: 4,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                index % 2 == 0 ? Icons.folder_special : Icons.note,
                size: 48,
                color: Colors.purple,
              ),
              const SizedBox(height: 8),
              Text(
                'Private ${index + 1}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        );
      },
    );
  }
}
