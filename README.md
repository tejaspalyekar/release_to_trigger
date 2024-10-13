# **`release_to_trigger`** - Swipe Gesture & Trigger Actions for Flutter 📱💥

`release_to_trigger` is a powerful Flutter widget designed to capture vertical swipe gestures and trigger custom actions when users pull and release the swipe at a defined height. With support for both **top** and **bottom swipe gestures**, it’s perfect for building **interactive UIs**, **pull-to-refresh** controls, or custom **trigger actions** like loading new content or activating specific app features.

## 🏆 Key Features

- **Swipe Gesture Detection**: Recognize and respond to vertical swipes, both from the **top** and **bottom** of the screen.
- **Pull-to-Trigger Action**: Easily define actions that get triggered when the swipe reaches a set height.
- **Customizable Appearance**: Modify text styles, colors, and progress indicators to match your app’s theme.
- **Progress Indicator**: Real-time feedback with a circular progress indicator that adjusts dynamically as the user pulls.
- **User Feedback Integration**: Customize **swipe feedback** with visual indicators and smooth animations.

### ✨ Use Cases
- **Pull-to-Refresh** functionality.
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
  release_to_trigger: ^0.0.2
```

Then, import and start using it in your project:

```dart
import 'package:release_to_trigger/release_to_trigger.dart';
```

## 📸 Screenshots

Showcase the widget in action:

| **Initial State** | **Triggered State** |
|------------------|---------------------|
| ![Initial State](screenshots/1.png) | ![Triggered State](screenshots/2.png) |

## 🔧 Example Code

Check out a sample implementation:

```dart
ReleaseToTrigger(
  backgroundColor: Colors.green.withOpacity(0.2),
  progressColor: Colors.green,
  initialText: 'Pull down to unlock the surprise',
  triggeredText: 'Release to reveal the surprise!',
  triggerHeight: 250.0,
  onTrigger: () {
    // Action to be performed on trigger
  },
  child: Text('This is a customizable widget!'),
);
```

## 📋 Topics Covered

This package is ideal for:

- `pull-to-refresh`
- `swipe-gesture`
- `trigger-actions`
- `vertical-swipe`
- `gesture-detection-flutter`

## ⭐ Show Your Support

If you like `release_to_trigger`, please **star** the repository on GitHub, leave a review on PubDev, and feel free to [contribute](https://github.com/tejaspalyekar/release_to_trigger)! Your feedback helps us improve and add more exciting features!
