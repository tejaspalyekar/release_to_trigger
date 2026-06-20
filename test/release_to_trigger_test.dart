import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:release_to_trigger/release_to_trigger.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final hapticLog = <MethodCall>[];

  setUp(() {
    hapticLog.clear();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(SystemChannels.platform, (methodCall) async {
      if (methodCall.method.startsWith('HapticFeedback.')) {
        hapticLog.add(methodCall);
      }
      return null;
    });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(SystemChannels.platform, null);
  });

  testWidgets('renders child widget correctly when not dragging',
      (WidgetTester tester) async {
    const key = Key('child-widget');
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ReleaseToTrigger(
            onTrigger: () {},
            child: const SizedBox(
              key: key,
              width: 100,
              height: 100,
            ),
          ),
        ),
      ),
    );

    expect(find.byKey(key), findsOneWidget);
    // Drag container should not be visible when not dragging
    expect(find.text('Swipe to trigger'), findsNothing);
  });

  testWidgets('vertical drag lifecycle and callback on trigger past threshold',
      (WidgetTester tester) async {
    bool triggered = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ReleaseToTrigger(
            triggerHeight: 200,
            initialText: 'Pull down to start',
            triggeredText: 'Let go to trigger',
            onTrigger: () {
              triggered = true;
            },
            child: Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );

    // 1. Start drag (pointer down)
    final gesture = await tester.startGesture(const Offset(200, 10));
    await tester.pump();

    // UI should not appear yet because gesture is not recognized as drag start without motion
    expect(find.text('Pull down to start'), findsNothing);

    // 2. Drag a bit (30px) to trigger drag start and exceed dragThreshold (10px)
    await gesture.moveBy(const Offset(0, 30));
    await tester.pump();
    expect(find.text('Pull down to start'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(triggered, isFalse);

    // 3. Drag past threshold (200px)
    await gesture.moveBy(const Offset(0, 175)); // 205px total drag
    await tester.pump();

    // Text should change to triggeredText
    expect(find.text('Let go to trigger'), findsOneWidget);
    // Medium haptic impact should be triggered
    expect(hapticLog.length, 1);
    expect(hapticLog.first.method, 'HapticFeedback.vibrate');
    expect(hapticLog.first.arguments, 'HapticFeedbackType.mediumImpact');

    // 4. Release drag
    await gesture.up();
    await tester.pump();

    // Trigger should be called
    expect(triggered, isTrue);
    // Heavy haptic impact should be triggered
    expect(hapticLog.length, 2);
    expect(hapticLog.last.method, 'HapticFeedback.vibrate');
    expect(hapticLog.last.arguments, 'HapticFeedbackType.heavyImpact');

    // Wait for reverse animation
    await tester.pumpAndSettle();
    expect(find.text('Let go to trigger'), findsNothing);
  });

  testWidgets('vertical drag does not trigger if released below threshold',
      (WidgetTester tester) async {
    bool triggered = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ReleaseToTrigger(
            triggerHeight: 200,
            onTrigger: () {
              triggered = true;
            },
            child: const SizedBox(
              width: double.infinity,
              height: double.infinity,
            ),
          ),
        ),
      ),
    );

    final gesture = await tester.startGesture(const Offset(200, 10));
    await gesture.moveBy(const Offset(0, 100)); // only 100px out of 200px
    await tester.pump();
    await gesture.up();
    await tester.pumpAndSettle();

    expect(triggered, isFalse);
  });

  testWidgets('horizontal drag lifecycle (Left-to-Right swipe)',
      (WidgetTester tester) async {
    bool triggered = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ReleaseToTrigger(
            enableHorizontalSwipe: true,
            swipeDirection: Axis.horizontal,
            left: true,
            triggerHeight: 200,
            initialText: 'Swipe right',
            triggeredText: 'Release now',
            onTrigger: () {
              triggered = true;
            },
            child: Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );

    // Start drag on left side
    final gesture = await tester.startGesture(const Offset(10, 200));
    await tester.pump();

    // Move to trigger drag start
    await gesture.moveBy(const Offset(30, 0));
    await tester.pump();
    expect(find.text('Swipe right'), findsOneWidget);

    // Drag right past threshold
    await gesture.moveBy(const Offset(180, 0)); // 210px total
    await tester.pump();

    expect(find.text('Release now'), findsOneWidget);

    await gesture.up();
    await tester.pumpAndSettle();

    expect(triggered, isTrue);
  });

  testWidgets('horizontal drag lifecycle (Right-to-Left swipe)',
      (WidgetTester tester) async {
    bool triggered = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ReleaseToTrigger(
            enableHorizontalSwipe: true,
            swipeDirection: Axis.horizontal,
            left: false, // Anchor right side, drag left
            triggerHeight: 200,
            initialText: 'Swipe left',
            triggeredText: 'Release now',
            onTrigger: () {
              triggered = true;
            },
            child: SizedBox(
              width: 800,
              height: 600,
              child: Container(color: Colors.white),
            ),
          ),
        ),
      ),
    );

    // Start drag on right side
    final gesture = await tester.startGesture(const Offset(790, 200));
    await tester.pump();

    // Move to trigger drag start
    await gesture.moveBy(const Offset(-30, 0));
    await tester.pump();
    expect(find.text('Swipe left'), findsOneWidget);

    // Drag left past threshold (-210px dx total)
    await gesture.moveBy(const Offset(-180, 0));
    await tester.pump();

    expect(find.text('Release now'), findsOneWidget);

    await gesture.up();
    await tester.pumpAndSettle();

    expect(triggered, isTrue);
  });

  testWidgets('vertical drag lifecycle (Pull-Up / top: false)',
      (WidgetTester tester) async {
    bool triggered = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 800,
            height: 600,
            child: ReleaseToTrigger(
              top: false, // Anchor bottom side, drag up
              triggerHeight: 200,
              initialText: 'Pull up',
              triggeredText: 'Release now',
              onTrigger: () {
                triggered = true;
              },
              child: Container(color: Colors.white),
            ),
          ),
        ),
      ),
    );

    // Start drag at bottom
    final gesture = await tester.startGesture(const Offset(200, 590));
    await tester.pump();

    // Move to trigger drag start
    await gesture.moveBy(const Offset(0, -30));
    await tester.pump();
    expect(find.text('Pull up'), findsOneWidget);

    // Drag up past threshold
    await gesture.moveBy(const Offset(0, -180)); // -210px total
    await tester.pump();

    expect(find.text('Release now'), findsOneWidget);

    await gesture.up();
    await tester.pumpAndSettle();

    expect(triggered, isTrue);
  });

  testWidgets('renders all ProgressIndicatorTypes correctly without errors',
      (WidgetTester tester) async {
    final types = [
      ProgressIndicatorType.circular,
      ProgressIndicatorType.rotatingIcon,
      ProgressIndicatorType.scalingIcon,
      ProgressIndicatorType.fadingIcon,
      ProgressIndicatorType.custom,
    ];

    for (final type in types) {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ReleaseToTrigger(
              progressIndicatorType: type,
              progressIcon: Icons.star,
              progressBuilder: type == ProgressIndicatorType.custom
                  ? (progress) => Text('Custom Progress: $progress')
                  : null,
              onTrigger: () {},
              child: Container(),
            ),
          ),
        ),
      );

      final gesture = await tester.startGesture(const Offset(200, 10));
      await gesture.moveBy(const Offset(0, 150));
      await tester.pump();

      if (type == ProgressIndicatorType.custom) {
        expect(find.textContaining('Custom Progress:'), findsOneWidget);
      } else if (type == ProgressIndicatorType.circular) {
        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      } else {
        expect(find.byType(Icon), findsOneWidget);
      }

      await gesture.up();
      await tester.pumpAndSettle();
    }
  });

  testWidgets('ignores drags smaller than dragThreshold',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ReleaseToTrigger(
            dragThreshold: 50,
            triggerHeight: 200,
            initialText: 'Swipe now',
            onTrigger: () {},
            child: Container(),
          ),
        ),
      ),
    );

    final gesture = await tester.startGesture(const Offset(200, 10));
    // 1. Drag less than threshold (30px < 50px threshold)
    await gesture.moveBy(const Offset(0, 30));
    await tester.pump();

    // Since it's less than dragThreshold, it should return SizedBox.shrink()
    // thus the text 'Swipe now' is not visible.
    expect(find.text('Swipe now'), findsNothing);

    // 2. Drag more than threshold (60px total > 50px threshold)
    await gesture.moveBy(const Offset(0, 30));
    await tester.pump();

    expect(find.text('Swipe now'), findsOneWidget);

    await gesture.up();
    await tester.pumpAndSettle();
  });

  testWidgets('pullSensitivityHeight boundary constraints',
      (WidgetTester tester) async {
    int triggeredCount = 0;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 800,
            height: 600,
            child: ReleaseToTrigger(
              pullSensitivityHeight: 100,
              triggerHeight: 200,
              initialText: 'Sensitivity Test',
              onTrigger: () {
                triggeredCount++;
              },
              child: Container(color: Colors.white),
            ),
          ),
        ),
      ),
    );

    // 1. Start gesture outside sensitivity height (y = 150 > 100)
    var gesture = await tester.startGesture(const Offset(200, 150));
    await gesture.moveBy(const Offset(0, 250)); // move to initiate drag
    await tester.pump();
    // Verify it doesn't show the UI
    expect(find.text('Sensitivity Test'), findsNothing);
    await gesture.up();
    await tester.pumpAndSettle();
    expect(triggeredCount, 0);

    // 2. Start gesture inside sensitivity height (y = 50 <= 100)
    gesture = await tester.startGesture(const Offset(200, 50));
    await gesture.moveBy(const Offset(0, 50)); // move to initiate drag but not trigger it (50px < 200px triggerHeight)
    await tester.pump();
    // Verify it does show the UI
    expect(find.text('Sensitivity Test'), findsOneWidget);

    // Now drag the remaining distance to trigger
    await gesture.moveBy(const Offset(0, 200)); // 250px total drag
    await tester.pump();
    await gesture.up();
    await tester.pumpAndSettle();
    expect(triggeredCount, 1);
  });

  testWidgets('preventScrollingWhileDragging absorbs pointer interaction during drag',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ReleaseToTrigger(
            preventScrollingWhileDragging: true,
            triggerHeight: 200,
            onTrigger: () {},
            child: Container(),
          ),
        ),
      ),
    );

    final absorbFinder = find.descendant(
      of: find.byType(ReleaseToTrigger),
      matching: find.byType(AbsorbPointer),
    ).first;

    // Prior to drag, Absorbing is false
    var absorbPointer = tester.widget<AbsorbPointer>(absorbFinder);
    expect(absorbPointer.absorbing, isFalse);

    // Start drag and move to trigger drag start
    final gesture = await tester.startGesture(const Offset(200, 10));
    await gesture.moveBy(const Offset(0, 30));
    await tester.pump();

    // While dragging, absorbing should be true
    absorbPointer = tester.widget<AbsorbPointer>(absorbFinder);
    expect(absorbPointer.absorbing, isTrue);

    // Release drag
    await gesture.up();
    await tester.pumpAndSettle();

    // After drag finishes, absorbing should be false again
    absorbPointer = tester.widget<AbsorbPointer>(absorbFinder);
    expect(absorbPointer.absorbing, isFalse);
  });

  testWidgets('ReleaseToTrigger.refresh async loading state holding',
      (WidgetTester tester) async {
    final completer = Completer<void>();
    bool refreshCompleted = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ReleaseToTrigger.refresh(
            triggerHeight: 100,
            onRefresh: () async {
              await completer.future;
              refreshCompleted = true;
            },
            child: const SizedBox(
              width: double.infinity,
              height: double.infinity,
            ),
          ),
        ),
      ),
    );

    // Start drag and pull past threshold
    final gesture = await tester.startGesture(const Offset(200, 10));
    await gesture.moveBy(const Offset(0, 120));
    await tester.pump();

    // Release drag
    await gesture.up();
    await tester.pump(); // Initiate refresh

    expect(find.text('Release to refresh'), findsOneWidget);
    expect(refreshCompleted, isFalse);

    // Complete the future
    completer.complete();
    await tester.pumpAndSettle(); // Wait for reverse animation

    expect(refreshCompleted, isTrue);
    expect(find.text('Release to refresh'), findsNothing);
  });

  testWidgets('multi-stage triggers with intermediate and final stages',
      (WidgetTester tester) async {
    final reachedStages = <double>[];
    bool triggered = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ReleaseToTrigger(
            triggerHeight: 100,
            onTrigger: () {
              triggered = true;
            },
            stages: [
              TriggerStage(
                threshold: 0.5,
                label: 'Halfway',
                onStageReached: () => reachedStages.add(0.5),
              ),
              TriggerStage(
                threshold: 1.0,
                label: 'Threshold',
                onStageReached: () => reachedStages.add(1.0),
              ),
              TriggerStage(
                threshold: 1.5,
                label: 'Overpull',
                onStageReached: () => reachedStages.add(1.5),
              ),
            ],
            child: const SizedBox(
              width: double.infinity,
              height: double.infinity,
            ),
          ),
        ),
      ),
    );

    final gesture = await tester.startGesture(const Offset(200, 10));
    
    // 1. Drag to 55px (progress = 0.55 >= 0.5)
    await gesture.moveBy(const Offset(0, 55));
    await tester.pump();
    expect(find.text('Halfway'), findsOneWidget);
    expect(reachedStages, [0.5]);

    // 2. Drag to 110px (progress = 1.1 >= 1.0)
    await gesture.moveBy(const Offset(0, 55));
    await tester.pump();
    expect(find.text('Threshold'), findsOneWidget);
    expect(reachedStages, [0.5, 1.0]);
    expect(triggered, isFalse);

    // 3. Drag to 160px (progress = 1.6 >= 1.5)
    await gesture.moveBy(const Offset(0, 50));
    await tester.pump();
    expect(find.text('Overpull'), findsOneWidget);
    expect(reachedStages, [0.5, 1.0, 1.5]);

    // Release at final stage
    await gesture.up();
    await tester.pumpAndSettle();
    expect(triggered, isTrue);
  });

  testWidgets('long-press-then-pull prevents drag before duration, enables after',
      (WidgetTester tester) async {
    bool triggered = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ReleaseToTrigger(
            triggerHeight: 100,
            requireLongPressBeforePull: true,
            longPressDuration: const Duration(milliseconds: 200),
            initialText: 'Hold and swipe',
            onTrigger: () {
              triggered = true;
            },
            child: const SizedBox(
              width: double.infinity,
              height: double.infinity,
            ),
          ),
        ),
      ),
    );

    // 1. Touch down and drag immediately without waiting 200ms
    var gesture = await tester.startGesture(const Offset(200, 10));
    await gesture.moveBy(const Offset(0, 120));
    await tester.pump();
    // Since long press was not completed, drag should be ignored
    expect(find.text('Hold and swipe'), findsNothing);
    await gesture.up();
    await tester.pumpAndSettle();
    expect(triggered, isFalse);

    // 2. Touch down, wait 250ms, then drag
    gesture = await tester.startGesture(const Offset(200, 10));
    await tester.pump(); // Process pointer down and trigger long-press animation start
    await tester.pump(const Duration(milliseconds: 250)); // long-press completes
    await gesture.moveBy(const Offset(0, 50)); // drag past threshold (10px) but below trigger (100px)
    await tester.pump();
    expect(find.text('Hold and swipe'), findsOneWidget);

    await gesture.moveBy(const Offset(0, 70)); // drag the rest of the way to trigger
    await tester.pump();
    await gesture.up();
    await tester.pumpAndSettle();
    expect(triggered, isTrue);
  });

  testWidgets('onProgressTick callback fires with correct progress',
      (WidgetTester tester) async {
    final progressValues = <double>[];

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ReleaseToTrigger(
            triggerHeight: 100,
            onProgressTick: (progress) {
              progressValues.add(progress);
            },
            onTrigger: () {},
            child: const SizedBox(
              width: double.infinity,
              height: double.infinity,
            ),
          ),
        ),
      ),
    );

    final gesture = await tester.startGesture(const Offset(200, 10));
    // Drag by 50px
    await gesture.moveBy(const Offset(0, 50));
    await tester.pump();

    expect(progressValues.isNotEmpty, isTrue);
    expect(progressValues.last, closeTo(0.5, 0.05));

    await gesture.up();
    await tester.pumpAndSettle();
  });

  testWidgets('applies visual customization parameters correctly',
      (WidgetTester tester) async {
    const customStyle = TextStyle(color: Colors.red, fontSize: 20);
    const customPadding = EdgeInsets.all(24.0);
    const customSpacing = 18.0;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ReleaseToTrigger(
            triggerHeight: 100,
            progressBackgroundColor: Colors.grey,
            progressStrokeWidth: 5.0,
            padding: customPadding,
            spacing: customSpacing,
            initialTextStyle: customStyle,
            onTrigger: () {},
            child: const SizedBox(
              width: double.infinity,
              height: double.infinity,
            ),
          ),
        ),
      ),
    );

    final gesture = await tester.startGesture(const Offset(200, 10));
    await gesture.moveBy(const Offset(0, 50));
    await tester.pump();

    // Verify Padding
    final containerFinder = find.descendant(
      of: find.byType(ReleaseToTrigger),
      matching: find.byType(Container),
    ).first;
    final container = tester.widget<Container>(containerFinder);
    expect(container.padding, customPadding);

    // Verify Text Style
    final textWidget = tester.widget<Text>(find.text('Swipe to trigger'));
    expect(textWidget.style, customStyle);

    // Verify ProgressIndicator Customizations
    final progressFinder = find.byType(CircularProgressIndicator);
    expect(progressFinder, findsOneWidget);
    final indicator = tester.widget<CircularProgressIndicator>(progressFinder);
    expect(indicator.backgroundColor, Colors.grey);
    expect(indicator.strokeWidth, 5.0);

    // Verify stage text style gets applied
    await gesture.up();
    await tester.pumpAndSettle();

    // Verify with stages
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ReleaseToTrigger(
            triggerHeight: 100,
            stages: const [
              TriggerStage(
                threshold: 0.5,
                label: 'Stage Custom text style',
                textStyle: TextStyle(color: Colors.orange, fontSize: 18),
              ),
            ],
            onTrigger: () {},
            child: const SizedBox(
              width: double.infinity,
              height: double.infinity,
            ),
          ),
        ),
      ),
    );

    final gesture2 = await tester.startGesture(const Offset(200, 10));
    await gesture2.moveBy(const Offset(0, 60)); // > 0.5 threshold
    await tester.pump();

    final textWidgetStage = tester.widget<Text>(find.text('Stage Custom text style'));
    expect(textWidgetStage.style?.color, Colors.orange);
    expect(textWidgetStage.style?.fontSize, 18);

    await gesture2.up();
    await tester.pumpAndSettle();
  });
}
