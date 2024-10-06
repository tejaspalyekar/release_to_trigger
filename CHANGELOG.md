## 0.0.1

Features:
This package provides an easy-to-use widget that allows developers to trigger custom actions when users pull from either the top or bottom of the screen, similar to 'pull-to-refresh' functionality. It's highly customizable and designed to handle both top and bottom swipe gestures. Here are the main features:

Customizable Pull-to-Trigger Action:

Define the action that occurs when the user pulls beyond a certain threshold and releases.
Easily hook into the onTrigger callback to execute any custom logic after the pull gesture.
Pull Sensitivity:

The widget supports a pullSensitivityHeight parameter, which defines the region (from the top or bottom) where the pull-to-trigger effect will be active.
The pull gesture will only be detected within this defined region, making it more user-friendly.
Trigger from Top or Bottom:

The widget provides the flexibility to allow pulling from either the top or bottom of the screen.
The top boolean parameter defines whether the action will be triggered from the top (default) or the bottom.
Pull Progress Feedback:

Visual feedback of the pull progress is shown to users with a CircularProgressIndicator, reflecting how close the user is to triggering the action.
Customize the progress indicator with progressColor, and change the background color of the pull effect using backgroundColor.
Customizable Status Text:

Define the text to display while pulling with the initialText property, and change the text after the pull threshold is crossed with the triggeredText property.
Custom Threshold for Triggering:

Set a custom threshold height using the triggerHeight property to control how much the user needs to pull before the action is triggered.
Example Usage
dart
Copy code
ReleaseToTrigger(
  top: true, // Set to false to trigger from the bottom
  backgroundColor: Colors.teal, // Background color for the pull effect
  progressColor: Colors.amber, // Color of the progress indicator
  initialText: 'Pull down to refresh', // Text while pulling
  triggeredText: 'Release to refresh', // Text once the pull threshold is reached
  triggerHeight: 150.0, // Height the user must pull to trigger the action
  pullSensitivityHeight: 150.0, // Active pull area sensitivity
  onTrigger: () {
    print("Action triggered");
  },
  child: Container(
    color: Colors.white,
    child: const Center(
      child: Text("Main content of the app"),
    ),
  ),
);

Parameters:
backgroundColor (Color): Sets the background color of the pull container. Defaults to Colors.blueAccent.

progressColor (Color): Color of the CircularProgressIndicator shown during the pull gesture. Defaults to Colors.white.

initialText (String): The text displayed while the user is pulling but has not yet reached the threshold. Defaults to 'Swipe to trigger'.

triggeredText (String): The text displayed when the user has pulled beyond the threshold and should release to trigger the action. Defaults to 'Release to trigger action'.

triggerHeight (double): Defines the height the user must pull before the action is triggered. Defaults to 100.0.

pullSensitivityHeight (double): Height limit from the top/bottom of the screen where the pull gesture can be detected. Defaults to 100.0.

top (bool): Determines if the pull-to-trigger effect should appear at the top (true) or the bottom (false). Defaults to true.

onTrigger (Function): A required callback function that gets executed when the user pulls beyond the threshold and releases.

child (Widget): The main content of the app that will be displayed, wrapped by the ReleaseToTrigger widget.

How It Works:
Drag Start: When the user starts pulling within the pullSensitivityHeight (either from the top or bottom), the widget tracks the drag offset and progress.

Progress Display: As the user continues to pull, the CircularProgressIndicator reflects the current progress, and the status text changes if the threshold is crossed.

Action Trigger: If the user pulls past the triggerHeight and releases, the onTrigger callback is executed, allowing custom actions (e.g., refreshing content, loading more data) to be performed.
