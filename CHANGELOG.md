## 1.0.2

- **Code Formatted**: Code formatted using dart format ..

## 1.0.1

- **Added dart documentation comments**: For improving code readability added dart documentation comments.
- **Remove withOpacity usage**: WithOpacity is now deprecated so migrated from withOpacity to with withAlpha in backgroundColor.

## 1.0.0

- **Improved swipe sensitivity**: Improved swipe sensitivity.
- **Added optional haptic feedback**: Added haptic feedback for better interaction.
- **Solved known bugs & issues**: Solved issues in ios gesture detection.
- **More customizable styling options**: Better user experience with customizable styling options added.


## 0.0.9

- **Format According to pub.dev rules**: solve ib/release_to_trigger.dart doesn't match the Dart formatter.
  
## 0.0.8

- **Format According to pub.dev rules**: solve ib/release_to_trigger.dart doesn't match the Dart formatter.
  
## 0.0.7

- **Update package description**: package description updated.
  
## 0.0.6

- **Update package description**: package description updated.

## 0.0.5

- **Update readme**: reame.md file updated.

## 0.0.4

- **Update readme**: reame.md file updated.
  
## 0.0.3

- **Example added**: For better understanding example code added.
- **Customize text**: Now customize initial and release text style.
- **circular progress indicator**: show or hide circular progress indicator.

## 0.0.2

- **Add License**: MIT license added.
- **Improve sensitivity of pull**: for better user experience pull sensitivity is improved.

## 0.0.1 - Initial Release

- **Release to Trigger Action**: A Flutter widget designed to capture vertical swipe gestures and trigger a custom action when the user releases the swipe at a defined height. Ideal for refreshing content, loading actions, or any custom user interaction.
- **Configurable Sensitivity**: Customize the height sensitivity for detecting a swipe (both at the top or bottom of the screen), allowing you to control how much the user must pull before the action is triggered.
- **Top and Bottom Swipes**: Control whether the gesture triggers from the top or bottom of the screen using the `top` parameter.
- **Swipe Progress Indicator**: A circular progress indicator shows swipe progress in real-time, dynamically adjusting based on the distance the user has pulled.
- **Customizable Design**: Parameters for customizing colors, background, and text (e.g., `initialText` and `triggeredText`) for a personalized look and feel.
- **Callback on Trigger**: Execute any custom functionality by providing a callback via the `onTrigger` parameter, allowing developers to integrate custom actions seamlessly.
