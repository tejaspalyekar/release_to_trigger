# **`release_to_trigger`** - Swipe Gesture & Trigger Actions for Flutter 📱💥

`release_to_trigger` is a powerful Flutter widget designed to capture vertical swipe gestures and trigger custom actions like accessing secret folders..etc when users pull and release the swipe at a defined height. With support for both **top** and **bottom swipe gestures**, it’s perfect for building **interactive UIs**, **pull-to-refresh** controls, or custom **trigger actions** like loading new content or activating specific app features.

## 🏆 Key Features

- **Swipe Gesture Detection**: Recognize and respond to vertical swipes, both from the **top** and **bottom** of the screen.
- **Pull-to-Trigger Action**: Easily define actions that get triggered when the swipe reaches a set height.
- **Customizable Appearance**: Modify text styles, colors, and progress indicators to match your app’s theme.
- **Progress Indicator**: Real-time feedback with a circular progress indicator that adjusts dynamically as the user pulls.
- **User Feedback Integration**: Customize **swipe feedback** with visual indicators and smooth animations.
- **haptic feedback**: Optional haptic feedback for better interaction with user.

### ✨ Use Cases

- **Pull-to-Refresh** functionality.
- **Pull-to-Reveal** functionality.
- **Swipe-to-Activate** features.
- Unlock **hidden content** or **actions** based on user interactions.
- Enhance **user experience** with **gesture-based controls**.

## 🔥 Why Choose `release_to_trigger`?

- 🎯 **High Customizability**: Tailor the widget’s look and behavior to your app’s design.
- 🚀 **Optimized Performance**: Built for smooth animations and responsiveness on any screen size.
- 💼 **Versatile Implementation**: Use in apps that require **gesture detection**, **refresh controls**, or **interactive triggers**.

## 🚀 Getting Started

Simply add the following to your `pubspec.yaml` file:

```yaml
dependencies:
  release_to_trigger: ^1.0.0
```

Then, import and start using it in your project:

```dart
import 'package:release_to_trigger/release_to_trigger.dart';
```

## 📸 Screenshots

Showcase the widget in action and use-case:

| **Private Folder Demo**             | **Secret Calculator**                 | 
| ----------------------------------- | ------------------------------------- |
| ![Private Folder Demo](screenshots/1.png)| ![Triggered State](screenshots/2.png) |

## Parameters

### Essential Parameters

- `onTrigger` (required): Function that gets called when the pull action is completed.
  ```dart
  ReleaseToTrigger(
    onTrigger: () => print('Triggered!'),
    child: YourWidget(),
  )
  ```

- `child` (required): The widget to be wrapped with the pull-to-trigger functionality.
  ```dart
  ReleaseToTrigger(
    child: ListView(...),
    onTrigger: () {},
  )
  ```

### Visual Customization

- `backgroundColor` (default: `Colors.transparent`): Background color of the pull area.
  ```dart
  backgroundColor: Colors.grey[200]
  ```

- `progressColor` (default: `Colors.blue`): Color of the progress indicator.
  ```dart
  progressColor: Colors.green
  ```

- `initialText` (default: 'Swipe to trigger'): Text shown before reaching the trigger threshold.
  ```dart
  initialText: 'Pull to refresh'
  ```

- `triggeredText` (default: 'Release to trigger action'): Text shown when ready to trigger.
  ```dart
  triggeredText: 'Release to refresh'
  ```

- `initialTextStyle`: Style for the initial text.
  ```dart
  initialTextStyle: TextStyle(
    fontSize: 14,
    color: Colors.grey,
  )
  ```

- `triggerTextStyle`: Style for the triggered text.
  ```dart
  triggerTextStyle: TextStyle(
    fontSize: 14,
    color: Colors.blue,
    fontWeight: FontWeight.bold,
  )
  ```

- `customProgressIndicator`: Replace the default circular progress indicator with a custom widget.
  ```dart
  customProgressIndicator: YourCustomProgressIndicator()
  ```

### Behavior Configuration

- `triggerHeight` (default: 250.0): Height required to trigger the action.
  ```dart
  triggerHeight: 200.0
  ```

- `pullSensitivityHeight` (default: 250.0): Area from the edge where pull gesture is detected.
  ```dart
  pullSensitivityHeight: 300.0
  ```

- `top` (default: true): Whether to place the trigger area at the top or bottom.
  ```dart
  top: false // Places trigger at bottom
  ```

- `showProgressIndicator` (default: true): Whether to show the progress indicator.
  ```dart
  showProgressIndicator: false
  ```

- `animationDuration` (default: 300ms): Duration of the pull animation.
  ```dart
  animationDuration: Duration(milliseconds: 400)
  ```

- `animationCurve` (default: Curves.easeInOut): Curve for the pull animation.
  ```dart
  animationCurve: Curves.elasticOut
  ```

- `dragThreshold` (default: 10.0): Minimum drag distance to start the pull action.
  ```dart
  dragThreshold: 15.0
  ```

- `hapticFeedback` (default: true): Enable haptic feedback when triggered.
  ```dart
  hapticFeedback: false
  ```

- `preventScrollingWhileDragging` (default: true): Prevents content scrolling during pull action.
  ```dart
  preventScrollingWhileDragging: false
  ```

## 🔧 Example Code

Check out a sample implementation:

```dart
ReleaseToTrigger(
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
```

## 📋 Topics Covered

This package is ideal for:

- `pull-to-reveal`
- `pull-to-refresh`
- `pull-to-access`
- `swipe-gesture`
- `trigger-actions`
- `vertical-swipe`
- `secret-access`
- `swipe-to-access`
- `gesture-detection-flutter`

## ⭐ Show Your Support

If you like `release_to_trigger`, please **star** the repository on GitHub, leave a review on PubDev, and feel free to [contribute](https://github.com/tejaspalyekar/release_to_trigger)! Your feedback helps us improve and add more exciting features!









