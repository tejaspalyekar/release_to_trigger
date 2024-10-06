## ReleaseToTrigger Package

## 0.0.2 - Initial Release

### Features:
- **Release to Trigger Action**: A Flutter widget designed to capture vertical swipe gestures and trigger a custom action when the user releases the swipe at a defined height. Ideal for refreshing content, loading actions, or any custom user interaction.
- **Configurable Sensitivity**: Customize the height sensitivity for detecting a swipe (both at the top or bottom of the screen), allowing you to control how much the user must pull before the action is triggered.
- **Top and Bottom Swipes**: Control whether the gesture triggers from the top or bottom of the screen using the `top` parameter.
- **Swipe Progress Indicator**: A circular progress indicator shows swipe progress in real-time, dynamically adjusting based on the distance the user has pulled.
- **Customizable Design**: Parameters for customizing colors, background, and text (e.g., `initialText` and `triggeredText`) for a personalized look and feel.
- **Callback on Trigger**: Execute any custom functionality by providing a callback via the `onTrigger` parameter, allowing developers to integrate custom actions seamlessly.
  
### Example Usage:
- Set up an interactive swipe action to load content, perform tasks, or refresh data when the user pulls and releases at a certain point.

```dart
ReleaseToTrigger(
  top: false,  // Trigger from the bottom
  backgroundColor: Colors.teal,
  progressColor: Colors.amber,
  initialText: 'Pull to load something cool',
  triggeredText: 'Release to see magic',
  triggerHeight: 150.0,  // Trigger action when 150px is pulled
  onTrigger: () {
    print("Trigger action executed!");
  },
  child: Container(
    color: Colors.white,
    child: Center(
      child: Text("Swipe down to interact"),
    ),
  ),
);
```

---

### Parameters:

- `backgroundColor` *(Color)*: Sets the background color of the pull container. Defaults to `Colors.blueAccent`.
  
- `progressColor` *(Color)*: Color of the `CircularProgressIndicator` shown during the pull gesture. Defaults to `Colors.white`.
  
- `initialText` *(String)*: The text displayed while the user is pulling but has not yet reached the threshold. Defaults to `'Swipe to trigger'`.
  
- `triggeredText` *(String)*: The text displayed when the user has pulled beyond the threshold and should release to trigger the action. Defaults to `'Release to trigger action'`.
  
- `triggerHeight` *(double)*: Defines the height the user must pull before the action is triggered. Defaults to `100.0`.
  
- `pullSensitivityHeight` *(double)*: Height limit from the top/bottom of the screen where the pull gesture can be detected. Defaults to `100.0`.
  
- `top` *(bool)*: Determines if the pull-to-trigger effect should appear at the top (`true`) or the bottom (`false`). Defaults to `true`.

- `onTrigger` *(Function)*: A required callback function that gets executed when the user pulls beyond the threshold and releases.
  
- `child` *(Widget)*: The main content of the app that will be displayed, wrapped by the `ReleaseToTrigger` widget.

---

### How It Works:

1. **Drag Start:** When the user starts pulling within the `pullSensitivityHeight` (either from the top or bottom), the widget tracks the drag offset and progress.
   
2. **Progress Display:** As the user continues to pull, the `CircularProgressIndicator` reflects the current progress, and the status text changes if the threshold is crossed.

3. **Action Trigger:** If the user pulls past the `triggerHeight` and releases, the `onTrigger` callback is executed, allowing custom actions (e.g., refreshing content, loading more data) to be performed.

---

### Planned Improvements:

- Horizontal pull support.
- Adding more animation customization for the pull and release actions.
- Improved handling of edge cases like fast pulls and swipes.

---

This is the initial release (version 0.0.1) of the `release_to_trigger` package, with essential features for handling pull-to-trigger gestures and customizable feedback.