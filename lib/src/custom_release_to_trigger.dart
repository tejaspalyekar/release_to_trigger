import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/physics.dart';

/// Defines the type of progress indicator to use
enum ProgressIndicatorType {
  /// Default circular progress indicator
  circular,

  /// Rotating icon
  rotatingIcon,

  /// Scaling icon or image
  scalingIcon,

  /// Custom widget with progress
  custom,

  /// Fading icon or image
  fadingIcon,
}

/// A widget that allows users to swipe down or up to trigger an action.
///
/// This widget provides a customizable way to detect pull gestures and
/// execute a function when the user swipes and releases at a certain threshold.
///
/// Example usage:
/// ```dart
/// ReleaseToTrigger(
///   onTrigger: () {
///     // Handle trigger action
///     setState(() {
///       isPrivateVisible = !isPrivateVisible;
///     });
///   },
///   child: YourWidget(),
/// )
/// ```
class ReleaseToTrigger extends StatefulWidget {
  /// Background color of the pull-to-trigger container.
  ///
  /// Use this to match your app's theme or create visual feedback during drag.
  ///
  /// Example:
  /// ```dart
  /// backgroundColor: Colors.purple.withAlpha(30)
  /// // Or for transparent background:
  /// backgroundColor: Colors.transparent
  /// ```
  final Color? backgroundColor;

  /// Color of the progress indicator.
  ///
  /// This affects the color of the circular progress indicator or custom icons.
  ///
  /// Example:
  /// ```dart
  /// progressColor: Colors.blue
  /// // Or use your theme color:
  /// progressColor: Theme.of(context).primaryColor
  /// ```
  final Color? progressColor;

  /// Initial text displayed before the trigger threshold is reached.
  ///
  /// This text guides users on how to interact with the widget.
  ///
  /// Example:
  /// ```dart
  /// initialText: 'Pull down to refresh'
  /// // Or for a secret folder:
  /// initialText: 'Pull down to reveal private content'
  /// ```
  final String? initialText;

  /// Text displayed when the trigger threshold is reached.
  ///
  /// This text indicates that releasing will trigger the action.
  ///
  /// Example:
  /// ```dart
  /// triggeredText: 'Release to refresh'
  /// // Or for confirming an action:
  /// triggeredText: 'Release to confirm deletion'
  /// ```
  final String? triggeredText;

  /// The height required to trigger the action.
  ///
  /// Lower values make it easier to trigger, higher values require more effort.
  ///
  /// Example:
  /// ```dart
  /// triggerHeight: 100.0  // Easy to trigger
  /// triggerHeight: 250.0  // Requires more effort
  /// ```
  final double? triggerHeight;

  /// Defines the sensitivity range for detecting the pull gesture.
  ///
  /// This determines how far from the edge the gesture can start.
  ///
  /// Example:
  /// ```dart
  /// pullSensitivityHeight: 100.0  // Small area near edge
  /// pullSensitivityHeight: 250.0  // Larger detection area
  /// ```
  final double? pullSensitivityHeight;

  /// Determines if the pull gesture starts from the top (`true`) or bottom (`false`).
  ///
  /// Use this to create different interaction patterns.
  ///
  /// Example:
  /// ```dart
  /// top: true   // Pull down from top
  /// top: false  // Pull up from bottom
  /// ```
  final bool? top;

  /// Whether to show a progress indicator during the pull gesture.
  ///
  /// Useful for providing visual feedback during interaction.
  ///
  /// Example:
  /// ```dart
  /// showProgressIndicator: true   // Show progress
  /// showProgressIndicator: false  // Hide progress
  /// ```
  final bool? showProgressIndicator;

  /// Text style for the initial state text.
  ///
  /// Customize the appearance of the instruction text.
  ///
  /// Example:
  /// ```dart
  /// initialTextStyle: TextStyle(
  ///   fontSize: 14,
  ///   color: Colors.grey,
  ///   fontWeight: FontWeight.normal,
  /// )
  /// ```
  final TextStyle? initialTextStyle;

  /// Text style for the triggered state text.
  ///
  /// Customize the appearance of the trigger confirmation text.
  ///
  /// Example:
  /// ```dart
  /// triggerTextStyle: TextStyle(
  ///   fontSize: 14,
  ///   color: Colors.blue,
  ///   fontWeight: FontWeight.bold,
  /// )
  /// ```
  final TextStyle? triggerTextStyle;

  /// The function to execute when the user releases after reaching the trigger threshold.
  ///
  /// This is where you implement the action to perform.
  ///
  /// Example:
  /// ```dart
  /// onTrigger: () {
  ///   // Refresh data
  ///   refreshData();
  ///   // Or toggle visibility
  ///   setState(() {
  ///     isVisible = !isVisible;
  ///   });
  /// }
  /// ```
  final Function onTrigger;

  /// The child widget over which the pull-to-trigger feature is implemented.
  ///
  /// This can be any widget that you want to wrap with pull gesture.
  ///
  /// Example:
  /// ```dart
  /// child: ListView(
  ///   children: [
  ///     // Your list items
  ///   ],
  /// )
  /// // Or a simple container
  /// child: Container(
  ///   child: YourContent(),
  /// )
  /// ```
  final Widget child;

  /// Duration of the pull animation.
  ///
  /// Controls how fast or slow the animations play.
  ///
  /// Example:
  /// ```dart
  /// animationDuration: Duration(milliseconds: 300)  // Default
  /// animationDuration: Duration(milliseconds: 500)  // Slower
  /// animationDuration: Duration(milliseconds: 200)  // Faster
  /// ```
  final Duration animationDuration;

  /// The curve of the pull animation.
  ///
  /// Controls the rate of change of the animation.
  ///
  /// Example:
  /// ```dart
  /// animationCurve: Curves.easeInOut    // Smooth
  /// animationCurve: Curves.elasticOut   // Bouncy
  /// animationCurve: Curves.linear       // Constant
  /// ```
  final Curve animationCurve;

  /// The minimum drag distance required to start triggering the pull gesture.
  ///
  /// Helps prevent accidental triggers.
  ///
  /// Example:
  /// ```dart
  /// dragThreshold: 10.0  // More sensitive
  /// dragThreshold: 20.0  // Less sensitive
  /// ```
  final double dragThreshold;

  /// Whether to provide haptic feedback when the trigger threshold is reached.
  ///
  /// Adds tactile feedback for better user experience.
  ///
  /// Example:
  /// ```dart
  /// hapticFeedback: true   // Enable vibration
  /// hapticFeedback: false  // Disable vibration
  /// ```
  final bool hapticFeedback;

  /// A custom widget to use as the progress indicator.
  ///
  /// Replace the default indicator with your own widget.
  ///
  /// Example:
  /// ```dart
  /// customProgressIndicator: SpinKitCircle(
  ///   color: Colors.blue,
  ///   size: 50.0,
  /// )
  /// ```
  final Widget? customProgressIndicator;

  /// If `true`, prevents scrolling while dragging the pull container.
  ///
  /// Useful when implementing in scrollable widgets.
  ///
  /// Example:
  /// ```dart
  /// preventScrollingWhileDragging: true   // Lock scroll
  /// preventScrollingWhileDragging: false  // Allow scroll
  /// ```
  final bool preventScrollingWhileDragging;

  /// Whether to enable horizontal swipe support.
  ///
  /// Enable for left/right swipe gestures.
  ///
  /// Example:
  /// ```dart
  /// enableHorizontalSwipe: true   // Allow horizontal swipes
  /// enableHorizontalSwipe: false  // Only vertical swipes
  /// ```
  final bool enableHorizontalSwipe;

  /// The direction of the swipe gesture (vertical, horizontal, or both).
  ///
  /// Control which direction swipes are detected.
  ///
  /// Example:
  /// ```dart
  /// swipeDirection: Axis.vertical    // Up/down only
  /// swipeDirection: Axis.horizontal  // Left/right only
  /// ```
  final Axis swipeDirection;

  /// The type of progress indicator to display.
  ///
  /// Choose from different progress indicator styles.
  ///
  /// Example:
  /// ```dart
  /// progressIndicatorType: ProgressIndicatorType.circular    // Default
  /// progressIndicatorType: ProgressIndicatorType.rotatingIcon
  /// progressIndicatorType: ProgressIndicatorType.scalingIcon
  /// ```
  final ProgressIndicatorType progressIndicatorType;

  /// Icon to display instead of progress indicator.
  ///
  /// Use custom icons for visual feedback.
  ///
  /// Example:
  /// ```dart
  /// progressIcon: Icons.lock      // For private content
  /// progressIcon: Icons.refresh   // For refresh action
  /// progressIcon: Icons.download  // For download action
  /// ```
  final IconData? progressIcon;

  /// Size of the progress icon.
  ///
  /// Control the size of icons and indicators.
  ///
  /// Example:
  /// ```dart
  /// progressIconSize: 30.0  // Default size
  /// progressIconSize: 40.0  // Larger
  /// progressIconSize: 24.0  // Smaller
  /// ```
  final double progressIconSize;

  /// Custom widget builder that receives progress value (0.0 to 1.0).
  ///
  /// Create completely custom progress indicators.
  ///
  /// Example:
  /// ```dart
  /// progressBuilder: (progress) => Stack(
  ///   children: [
  ///     CircularProgressIndicator(value: progress),
  ///     Icon(
  ///       Icons.lock,
  ///       color: progress >= 0.99 ? Colors.green : Colors.grey,
  ///     ),
  ///   ],
  /// )
  /// ```
  final Widget Function(double progress)? progressBuilder;

  /// Image to display instead of progress indicator.
  ///
  /// Use custom images for visual feedback.
  ///
  /// Example:
  /// ```dart
  /// progressImage: AssetImage('assets/loading.png')
  /// // Or network image:
  /// progressImage: NetworkImage('https://example.com/icon.png')
  /// ```
  final ImageProvider? progressImage;

  /// Whether to rotate the icon/image during drag.
  ///
  /// Add rotation animation to icons/images.
  ///
  /// Example:
  /// ```dart
  /// rotateProgress: true   // Enable rotation
  /// rotateProgress: false  // Disable rotation
  /// ```
  final bool rotateProgress;

  /// Custom rotation angle for icon/image (in radians).
  ///
  /// Control how much the icon/image rotates.
  ///
  /// Example:
  /// ```dart
  /// maxRotationAngle: 2 * pi  // Full rotation
  /// maxRotationAngle: pi      // Half rotation
  /// ```
  final double maxRotationAngle;

  /// Creates a `ReleaseToTrigger` widget.
  const ReleaseToTrigger({
    super.key,
    this.backgroundColor = Colors.transparent,
    this.progressColor = Colors.blue,
    this.initialText = 'Swipe to trigger',
    this.triggeredText = 'Release to trigger action',
    this.triggerHeight = 250.0,
    this.pullSensitivityHeight = 250.0,
    this.initialTextStyle = const TextStyle(
        fontSize: 12, color: Colors.black, fontWeight: FontWeight.bold),
    this.triggerTextStyle = const TextStyle(
        fontSize: 12, color: Colors.blue, fontWeight: FontWeight.bold),
    this.top = true,
    this.showProgressIndicator = true,
    required this.onTrigger,
    required this.child,
    this.animationDuration = const Duration(milliseconds: 300),
    this.animationCurve = Curves.easeInOut,
    this.dragThreshold = 10.0,
    this.hapticFeedback = true,
    this.customProgressIndicator,
    this.preventScrollingWhileDragging = true,
    this.enableHorizontalSwipe = false,
    this.swipeDirection = Axis.vertical,
    this.progressIndicatorType = ProgressIndicatorType.circular,
    this.progressIcon,
    this.progressIconSize = 30.0,
    this.progressBuilder,
    this.progressImage,
    this.rotateProgress = true,
    this.maxRotationAngle = 2 * 3.14159, // 360 degrees in radians
  });

  @override
  State<ReleaseToTrigger> createState() => _ReleaseToTriggerState();
}

class _ReleaseToTriggerState extends State<ReleaseToTrigger>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _springAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _rotationAnimation;

  double _dragOffset = 0.0;
  bool _triggered = false;
  String _statusText = '';
  double _progress = 0.0;
  bool _isDragging = false;

  @override
  void initState() {
    super.initState();
    _statusText = widget.initialText ?? "Swipe to trigger";

    _animationController = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    );

    _springAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOut,
      ),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _rotationAnimation = Tween<double>(begin: 0.0, end: widget.maxRotationAngle)
        .animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleDragStart(DragStartDetails details) {
    setState(() {
      _isDragging = true;
      _dragOffset = 0.0;
      _animationController.forward();
    });
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    if (!_isDragging) return;

    setState(() {
      final maxHeight = widget.triggerHeight ?? 250.0;
      final delta = details.delta.dy;

      // Allow dragging in both directions
      if (widget.top ?? true) {
        final newOffset = _dragOffset + delta;
        _dragOffset = newOffset.clamp(0.0, maxHeight);
      } else {
        final newOffset = _dragOffset - delta;
        _dragOffset = newOffset.clamp(0.0, maxHeight);
      }

      _progress = (_dragOffset / maxHeight).clamp(0.0, 1.0);

      final shouldTrigger = _progress >= 0.99;
      if (shouldTrigger != _triggered) {
        _triggered = shouldTrigger;
        _statusText = shouldTrigger
            ? (widget.triggeredText ?? "Release to trigger action")
            : (widget.initialText ?? "Swipe to trigger");

        if (widget.hapticFeedback && shouldTrigger) {
          HapticFeedback.mediumImpact();
        }
      }
    });
  }

  void _handleDragEnd(DragEndDetails details) {
    if (_triggered) {
      widget.onTrigger();
      if (widget.hapticFeedback) {
        HapticFeedback.heavyImpact();
      }
    }

    _animationController.reverse().then((_) {
      setState(() {
        _dragOffset = 0.0;
        _progress = 0.0;
        _triggered = false;
        _isDragging = false;
        _statusText = widget.initialText ?? "Swipe to trigger";
      });
    });
  }

  Widget _buildProgressIndicator() {
    if (widget.customProgressIndicator != null) {
      return widget.customProgressIndicator!;
    }

    switch (widget.progressIndicatorType) {
      case ProgressIndicatorType.circular:
        return SizedBox(
          width: widget.progressIconSize,
          height: widget.progressIconSize,
          child: CircularProgressIndicator(
            value: _progress,
            valueColor: AlwaysStoppedAnimation<Color>(
                widget.progressColor ?? Colors.blue),
            backgroundColor: widget.progressColor?.withAlpha(30) ??
                Colors.blue.withAlpha(30),
            strokeWidth: 6,
          ),
        );

      case ProgressIndicatorType.rotatingIcon:
        return Transform.rotate(
          angle:
              widget.rotateProgress ? _progress * widget.maxRotationAngle : 0,
          child: Icon(
            widget.progressIcon ?? Icons.refresh,
            size: widget.progressIconSize,
            color: widget.progressColor,
          ),
        );

      case ProgressIndicatorType.scalingIcon:
        return Transform.scale(
          scale: 0.5 + (_progress * 0.5),
          child: widget.progressImage != null
              ? Image(
                  image: widget.progressImage!,
                  width: widget.progressIconSize,
                  height: widget.progressIconSize,
                  color: widget.progressColor,
                )
              : Icon(
                  widget.progressIcon ?? Icons.refresh,
                  size: widget.progressIconSize,
                  color: widget.progressColor,
                ),
        );

      case ProgressIndicatorType.fadingIcon:
        return Opacity(
          opacity: _progress,
          child: widget.progressImage != null
              ? Image(
                  image: widget.progressImage!,
                  width: widget.progressIconSize,
                  height: widget.progressIconSize,
                  color: widget.progressColor,
                )
              : Icon(
                  widget.progressIcon ?? Icons.refresh,
                  size: widget.progressIconSize,
                  color: widget.progressColor,
                ),
        );

      case ProgressIndicatorType.custom:
        return widget.progressBuilder?.call(_progress) ??
            SizedBox(
              width: widget.progressIconSize,
              height: widget.progressIconSize,
              child: CircularProgressIndicator(
                value: _progress,
                valueColor: AlwaysStoppedAnimation<Color>(
                    widget.progressColor ?? Colors.blue),
                backgroundColor: widget.progressColor?.withAlpha(30) ??
                    Colors.blue.withAlpha(30),
                strokeWidth: 6,
              ),
            );
    }
  }

  Widget _buildPullContainer() {
    final containerHeight =
        _dragOffset.clamp(0.0, widget.triggerHeight ?? 250.0);

    return Container(
      height: containerHeight,
      color: _isDragging ? widget.backgroundColor : Colors.transparent,
      padding: EdgeInsets.symmetric(
        vertical: 16.0,
        horizontal: 16.0,
      ),
      child: _isDragging && containerHeight > 0
          ? FadeTransition(
              opacity: _fadeAnimation,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: containerHeight,
                ),
                child: SingleChildScrollView(
                  physics: NeverScrollableScrollPhysics(),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: widget.top ?? true
                        ? MainAxisAlignment.start
                        : MainAxisAlignment.end,
                    children: [
                      if (!(widget.top ?? true))
                        SizedBox(height: containerHeight * 0.2),
                      if (widget.showProgressIndicator ?? true)
                        ScaleTransition(
                          scale: _springAnimation,
                          child: _buildProgressIndicator(),
                        ),
                      SizedBox(height: 12),
                      Text(
                        _statusText,
                        style: _triggered
                            ? widget.triggerTextStyle
                            : widget.initialTextStyle,
                        textAlign: TextAlign.center,
                      ),
                      if (widget.top ?? true)
                        SizedBox(height: containerHeight * 0.2),
                    ],
                  ),
                ),
              ),
            )
          : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onVerticalDragStart: _handleDragStart,
      onVerticalDragUpdate: _handleDragUpdate,
      onVerticalDragEnd: _handleDragEnd,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(child: widget.child),
          if (_isDragging)
            Positioned(
              top: widget.top ?? true ? 0 : null,
              bottom: widget.top ?? true ? null : 0,
              left: 0,
              right: 0,
              child: Material(
                type: MaterialType.transparency,
                child: _buildPullContainer(),
              ),
            ),
        ],
      ),
    );
  }
}
