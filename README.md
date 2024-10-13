# release_to_trigger

A Flutter widget designed to capture vertical swipe gestures and trigger custom actions when a user releases the swipe at a defined height. Perfect for refreshing content, loading actions, or adding interactive functionality with a smooth user experience.

---

## Features

- **Release to Trigger Action**: Trigger an action when a user pulls down or up to a specified height.
- **Configurable Sensitivity**: Customize the height threshold for swipes and control how far the user must pull before triggering the action.
- **Top and Bottom Swipe Support**: You can choose to detect swipes from the top or the bottom of the screen.
- **Swipe Progress Indicator**: Real-time progress feedback with a customizable circular progress indicator.
- **Customizable Look and Feel**: Parameters for setting background colors, text, and progress colors.
- **Callback on Trigger**: Integrate custom functionality seamlessly with a callback function that executes when the user releases at the trigger point.

---

## Installation

Add this package to your `pubspec.yaml` file:

```yaml
dependencies:
  release_to_trigger: ^0.0.2
```

Then, run `flutter pub get` to install it.

---

## Example Usage

Here is an example demonstrating how to use the `ReleaseToTrigger` widget in your app to unlock motivational quotes with a swipe gesture.
 ReleaseToTrigger(
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
```

---

## Parameters

- `backgroundColor` *(Color)*: The background color of the pull container.
- `progressColor` *(Color)*: Color of the circular progress indicator.
- `initialText` *(String)*: Text shown while pulling but before reaching the trigger height.
- `triggeredText` *(String)*: Text displayed when the user crosses the threshold and should release.
- `triggerHeight` *(double)*: Height in pixels the user must pull before triggering the action.
- `pullSensitivityHeight` *(double)*: Height limit where the pull gesture is detected.
- `top` *(bool)*: Whether to trigger from the top (`true`) or bottom (`false`).
- `onTrigger` *(Function)*: Callback function to execute when the user pulls and releases at the trigger height.
- `child` *(Widget)*: The main widget or content of your screen, wrapped by the `ReleaseToTrigger` widget.
- `initialTextColor` *(TextStyle)*: style initial text according to your need.
- `triggerTextStyle` *(TextStyle)*: style trigger text according to your need.
---

## How It Works

1. **Pull Start**: When the user begins pulling within the specified sensitivity area, the swipe is detected and tracked.
2. **Progress Indicator**: A circular progress indicator adjusts dynamically as the user pulls closer to the trigger height.
3. **Trigger**: Upon reaching the trigger height and releasing, the `onTrigger` callback is executed, allowing you to perform any custom action.

---


## Screenshots

Here are some screenshots demonstrating the `ReleaseToTrigger` in action:

| Initial State                                  | Triggered State                                 |
|------------------------------------------------|-------------------------------------------------|
| ![Initial State](https://github.com/tejaspalyekar/release_to_trigger/blob/main/screenshots/1.png)            | ![Triggered State](screenshots/2.png)           |

---

## Planned Improvements

- **Horizontal Swipe Support**: Add support for horizontal swipe gestures.
- **Animations**: Add more customization for the pull and release animations.
- **Advanced Handling**: Handle fast swipes and other edge cases more gracefully.

---

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

This is the initial release (version 0.0.2) of the `release_to_trigger` package, packed with essential features for handling swipe gestures with customizable progress feedback.

---

Let me know if you'd like any adjustments or if you need help creating a demo video!
