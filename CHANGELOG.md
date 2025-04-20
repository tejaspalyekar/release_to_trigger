## 1.0.3

- **Enhanced Documentation**: Added comprehensive documentation with use cases and examples
- **Improved Example**: Created a new Secret Vault demo showcasing advanced features
- **Better Parameter Organization**: Reorganized parameters into logical categories
- **Added Parameter Tables**: Created tables for better parameter documentation
- **Progress Indicator Showcase**: Added detailed examples for each progress indicator type
- **Visual Improvements**: Enhanced README with better formatting and structure
- **Package Optimization**: Improved package metadata, added issue tracker, and enhanced documentation links
- **Testing Support**: Added test dependencies for better code quality
- **Topic Optimization**: Refined package topics for better discoverability
- **Issue Reporting**: Added clear guidelines for reporting issues
- **Enhanced Progress Indicator Customization**: Added support for multiple progress indicator types:
  - Rotating icons with customizable rotation
  - Scaling icons and images
  - Fading icons and images
  - Custom progress widgets
- **Added Icon Support**: Can now use icons instead of circular progress
- **Added Image Support**: Support for custom images as progress indicators
- **Custom Progress Builder**: Added ability to create fully custom progress indicators
- **Improved Animation Control**: Better control over rotation, scaling, and fading animations

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
