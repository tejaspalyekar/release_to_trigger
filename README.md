# **`release_to_trigger`** - Swipe Gesture & Trigger Actions for Flutter 📱💥

`release_to_trigger` is a powerful Flutter widget designed to capture vertical and horizontal swipe gestures and trigger custom actions when users pull and release the swipe at a defined height. With support for both **top** and **bottom swipe gestures**, it's perfect for building **interactive UIs**, **pull-to-refresh** controls, or custom **trigger actions** like loading new content or activating specific app features.

## 🏆 Key Features

- **Spring Animations**: Natural, physics-based animations for smooth interactions
- **Pull-to-Trigger Action**: Easily define actions that get triggered when the swipe reaches a set height
- **Customizable Appearance**: Modify text styles, colors, and progress indicators to match your app's theme
- **Progress Indicator**: Real-time feedback with a circular progress indicator that adjusts dynamically
- **User Feedback Integration**: Customize **swipe feedback** with visual indicators and smooth animations
- **Haptic Feedback**: Optional haptic feedback for better interaction with user
- **Material 3 Support**: Built-in support for Material 3 design system
- **Adaptive Layouts**: Works seamlessly across different screen sizes and orientations
- **Multi-directional Swipe Support**: Recognize and respond to both vertical and horizontal swipes

### ✨ Use Cases

- **Pull-to-Refresh** functionality
- **Pull-to-Reveal** functionality
- **Swipe-to-Activate** features
- Unlock **hidden content** or **actions** based on user interactions
- Enhance **user experience** with **gesture-based controls**
- Create **secret access** mechanisms
- Implement **custom navigation** patterns

## 🔥 Why Choose `release_to_trigger`?

- 🎯 **High Customizability**: Tailor the widget's look and behavior to your app's design
- 🚀 **Optimized Performance**: Built for smooth animations and responsiveness on any screen size
- 💼 **Versatile Implementation**: Use in apps that require **gesture detection**, **refresh controls**, or **interactive triggers**
- 🌈 **Modern Design**: Support for Material 3 and adaptive layouts
- 🔄 **Multi-directional Support**: Works with both vertical and horizontal swipes

## 🚀 Getting Started

Simply add the following to your `pubspec.yaml` file:

```yaml
dependencies:
  release_to_trigger: ^1.0.3
```

Then, import and start using it in your project:

```dart
import 'package:release_to_trigger/release_to_trigger.dart';
```

## 📸 Demo Showcase

### Interactive Demos

#### Top Drag Demo
[![Top Drag Demo](screenshots/2.png)](screenshots/top_drag.mp4)
*Click the image to view the top drag demo video*

#### Bottom Drag Demo
[![Bottom Drag Demo](screenshots/2.png)](screenshots/bottom_drag.mp4)
*Click the image to view the bottom drag demo video*

### Secret Vault Implementation
![Secret Vault Demo](screenshots/2.png)

## 🔧 Complete Example

Here's a complete example of a Secret Vault implementation that showcases the widget's capabilities:

```dart
class SecretVaultScreen extends StatefulWidget {
  const SecretVaultScreen({super.key});

  @override
  State<SecretVaultScreen> createState() => _SecretVaultScreenState();
}

class _SecretVaultScreenState extends State<SecretVaultScreen>
    with SingleTickerProviderStateMixin {
  bool _isVaultOpen = false;
  late AnimationController _vaultAnimationController;
  late Animation<double> _vaultScaleAnimation;
  late Animation<double> _vaultRotationAnimation;

  @override
  void initState() {
    super.initState();
    _vaultAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _vaultScaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(
        parent: _vaultAnimationController,
        curve: Curves.elasticOut,
      ),
    );

    _vaultRotationAnimation = Tween<double>(begin: 0.0, end: 0.1).animate(
      CurvedAnimation(
        parent: _vaultAnimationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Secret Vault'),
        backgroundColor: _isVaultOpen ? Colors.deepPurple.shade900 : null,
        actions: [
          if (_isVaultOpen)
            IconButton(
              icon: const Icon(Icons.lock),
              onPressed: () {
                setState(() {
                  _isVaultOpen = false;
                });
              },
            ),
        ],
      ),
      body: ReleaseToTrigger(
        // Visual Customization
        backgroundColor: Colors.deepPurple.withAlpha(20),
        progressColor: Colors.deepPurple,
        initialText: 'Pull down to unlock vault',
        triggeredText: 'Release to access secret content',
        initialTextStyle: const TextStyle(
          fontSize: 16,
          color: Colors.white70,
          fontWeight: FontWeight.w500,
        ),
        triggerTextStyle: const TextStyle(
          fontSize: 16,
          color: Colors.deepPurple,
          fontWeight: FontWeight.bold,
        ),

        // Progress Indicator Customization
        progressIndicatorType: ProgressIndicatorType.rotatingIcon,
        progressIcon: Icons.lock_open,
        progressIconSize: 40.0,
        rotateProgress: true,
        maxRotationAngle: 2 * 3.14159, // Full rotation

        // Behavior Configuration
        triggerHeight: 150.0,
        pullSensitivityHeight: 200.0,
        top: true,
        showProgressIndicator: true,
        animationDuration: const Duration(milliseconds: 400),
        animationCurve: Curves.easeInOut,
        dragThreshold: 15.0,
        hapticFeedback: true,
        preventScrollingWhileDragging: true,
        enableHorizontalSwipe: true,
        swipeDirection: Axis.vertical,

        // Trigger Action
        onTrigger: () {
          setState(() {
            _isVaultOpen = !_isVaultOpen;
            if (_isVaultOpen) {
              _vaultAnimationController.forward();
            } else {
              _vaultAnimationController.reverse();
            }
          });
        },

        // Child Content
        child: _isVaultOpen ? _buildVaultContent() : _buildLockedState(),
      ),
    );
  }
}
```

## 📚 Parameter Documentation

### Essential Parameters

| Parameter | Type | Description | Default |
|-----------|------|-------------|---------|
| `onTrigger` | `Function` | Required callback function that executes when the trigger threshold is reached | - |
| `child` | `Widget` | Required widget to be wrapped with the pull-to-trigger functionality | - |

### Visual Customization

| Parameter | Type | Description | Default |
|-----------|------|-------------|---------|
| `backgroundColor` | `Color?` | Background color of the pull area | `Colors.transparent` |
| `progressColor` | `Color?` | Color of the progress indicator | `Colors.blue` |
| `initialText` | `String?` | Text shown before reaching the trigger threshold | `'Swipe to trigger'` |
| `triggeredText` | `String?` | Text shown when ready to trigger | `'Release to trigger action'` |
| `initialTextStyle` | `TextStyle?` | Style for the initial text | `TextStyle(fontSize: 12, color: Colors.black, fontWeight: FontWeight.bold)` |
| `triggerTextStyle` | `TextStyle?` | Style for the triggered text | `TextStyle(fontSize: 12, color: Colors.blue, fontWeight: FontWeight.bold)` |

### Progress Indicator Types

The widget supports multiple types of progress indicators through the `progressIndicatorType` parameter:

1. **Circular Progress** (default):
   ```dart
   progressIndicatorType: ProgressIndicatorType.circular,
   progressColor: Colors.blue,
   ```

2. **Rotating Icon**:
   ```dart
   progressIndicatorType: ProgressIndicatorType.rotatingIcon,
   progressIcon: Icons.refresh,
   progressIconSize: 40.0,
   rotateProgress: true,
   maxRotationAngle: 2 * pi,
   ```

3. **Scaling Icon/Image**:
   ```dart
   progressIndicatorType: ProgressIndicatorType.scalingIcon,
   progressIcon: Icons.lock,
   // Or use an image:
   progressImage: AssetImage('assets/icon.png'),
   ```

4. **Fading Icon/Image**:
   ```dart
   progressIndicatorType: ProgressIndicatorType.fadingIcon,
   progressIcon: Icons.security,
   ```

5. **Custom Progress Widget**:
   ```dart
   progressIndicatorType: ProgressIndicatorType.custom,
   progressBuilder: (progress) => CustomProgressWidget(
     progress: progress,
   ),
   ```

### Behavior Configuration

| Parameter | Type | Description | Default |
|-----------|------|-------------|---------|
| `triggerHeight` | `double?` | Height required to trigger the action | `250.0` |
| `pullSensitivityHeight` | `double?` | Area from the edge where pull gesture is detected | `250.0` |
| `top` | `bool?` | Whether to place the trigger area at the top or bottom | `true` |
| `showProgressIndicator` | `bool?` | Whether to show the progress indicator | `true` |
| `animationDuration` | `Duration` | Duration of the pull animation | `300ms` |
| `animationCurve` | `Curve` | Curve for the pull animation | `Curves.easeInOut` |
| `dragThreshold` | `double` | Minimum drag distance to start the pull action | `10.0` |
| `hapticFeedback` | `bool` | Enable haptic feedback when triggered | `true` |
| `preventScrollingWhileDragging` | `bool` | Prevents content scrolling during pull action | `true` |
| `enableHorizontalSwipe` | `bool` | Enable horizontal swipe support | `false` |
| `swipeDirection` | `Axis` | The direction of the swipe gesture | `Axis.vertical` |

## 📋 Topics Covered

This package is ideal for:

- `pull-to-reveal`
- `pull-to-refresh`
- `pull-to-access`
- `swipe-gesture`
- `trigger-actions`
- `vertical-swipe`
- `horizontal-swipe`
- `secret-access`
- `swipe-to-access`
- `gesture-detection-flutter`
- `material-3`
- `adaptive-layout`

## 🐛 Issue Reporting

If you encounter any issues or have suggestions for improvements, please:

1. Check the [existing issues](https://github.com/tejaspalyekar/release_to_trigger/issues) to see if your problem has already been reported
2. If not, create a new issue with:
   - A clear description of the problem
   - Steps to reproduce the issue
   - Expected behavior
   - Actual behavior
   - Screenshots or videos if applicable
   - Your Flutter version and device information

We appreciate your feedback and will address issues as quickly as possible!

## ⭐ Show Your Support

If you like `release_to_trigger`, please **star** the repository on GitHub, leave a review on PubDev, and feel free to [contribute](https://github.com/tejaspalyekar/release_to_trigger)! Your feedback helps us improve and add more exciting features!