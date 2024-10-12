import 'package:flutter/material.dart';
import 'package:release_to_trigger/release_to_trigger.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Release to Trigger Example',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: SurpriseUnlockPage(),
    );
  }
}

class SurpriseUnlockPage extends StatefulWidget {
  @override
  _SurpriseUnlockPageState createState() => _SurpriseUnlockPageState();
}

class _SurpriseUnlockPageState extends State<SurpriseUnlockPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Unlock the Surprise!'),
      ),
      body: ReleaseToTrigger(
        backgroundColor: Colors.green.withOpacity(0.2),
        progressColor: Colors.green,
        initialText: 'Pull down to unlock the surprise',
        triggeredText: 'Release to reveal the surprise!',
        triggerHeight: 250.0,
        pullSensitivityHeight: 250,
        onTrigger: () {
          Navigator.of(context).push(ModalBottomSheetRoute(
              useSafeArea: true,
              showDragHandle: true,
              builder: (context) => const SizedBox(
                    child: Center(
                      child: Text("Action Triggered"),
                    ),
                  ),
              isScrollControlled: true));
        },
        child: const Text("release to trigger example"),
      ),
    );
  }
}
