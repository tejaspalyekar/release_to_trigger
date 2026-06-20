import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sensors_plus/sensors_plus.dart';

/// Defines a progress threshold stage for multi-stage swipe/pull gestures.
class TriggerStage {
  /// The progress threshold for this stage (e.g., 0.5, 1.0, 1.5).
  final double threshold;

  /// The text label to display when this stage is active.
  final String label;

  /// An optional callback fired when this specific stage threshold is crossed.
  final VoidCallback? onStageReached;

  /// Optional text style to customize this stage's label style and color.
  final TextStyle? textStyle;

  /// Creates a [TriggerStage] with the given threshold, label, callback, and text style.
  const TriggerStage({
    required this.threshold,
    required this.label,
    this.onStageReached,
    this.textStyle,
  });
}

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

/// A widget that allows users to swipe down or up to trigger an action or reveal content.
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

  /// Determines if the horizontal pull gesture starts from the left (`true`) or right (`false`).
  ///
  /// Use this to create different interaction patterns.
  ///
  /// Example:
  /// ```dart
  /// left: true   // Pull from left to right
  /// left: false  // Pull from right to left
  /// ```
  final bool? left;

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

  /// Optional stages for multi-threshold pulling gestures.
  ///
  /// If provided, the widget will transition through multiple stages as the user
  /// pulls, triggering intermediate callbacks and updating the status text.
  final List<TriggerStage>? stages;

  /// Whether the user must long-press the widget before the pull gesture begins.
  ///
  /// Useful for lock screens, parental controls, or preventing accidental triggers.
  final bool requireLongPressBeforePull;

  /// The duration the user must press and hold before dragging is enabled.
  ///
  /// Defaults to 500 milliseconds. Only effective when [requireLongPressBeforePull] is true.
  final Duration longPressDuration;

  /// An optional custom builder for visual progress feedback during the long press hold.
  ///
  /// Receives the build context and a progress value ranging from 0.0 to 1.0.
  final Widget Function(BuildContext context, double progress)? longPressProgressBuilder;

  /// An optional callback fired on every drag update, receiving the current progress (0.0 to 1.0+).
  ///
  /// Consuming applications can use this to wire up custom audio feedback or advanced animations.
  final void Function(double progress)? onProgressTick;

  /// Whether shaking the device during an active drag cancels the gesture.
  ///
  /// Uses the `sensors_plus` package under the hood to detect shake motion.
  final bool enableShakeToCancel;

  /// Optional asynchronous callback for named constructor [ReleaseToTrigger.refresh].
  ///
  /// The drag container remains visible until the future returned by this callback resolves.
  final Future<void> Function()? onRefresh;

  /// Background color of the progress indicator (useful for circular progress track customization).
  final Color? progressBackgroundColor;

  /// Custom padding for the pull-to-trigger container drawer.
  final EdgeInsetsGeometry? padding;

  /// Spacing between the progress indicator and the status label.
  final double spacing;

  /// Stroke width of the circular progress indicator.
  final double progressStrokeWidth;

  /// Creates a standard `ReleaseToTrigger` widget.
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
    this.left = true,
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
    this.stages,
    this.requireLongPressBeforePull = false,
    this.longPressDuration = const Duration(milliseconds: 500),
    this.longPressProgressBuilder,
    this.onProgressTick,
    this.enableShakeToCancel = false,
    this.progressBackgroundColor,
    this.padding,
    this.spacing = 12.0,
    this.progressStrokeWidth = 6.0,
  }) : onRefresh = null;

  /// Creates a preset `ReleaseToTrigger` widget configured for pull-to-refresh.
  ///
  /// The drag container remains visible until the Future returned by [onRefresh] resolves.
  /// This constructor sets refresh-appropriate defaults for parameters.
  const ReleaseToTrigger.refresh({
    super.key,
    required this.onRefresh,
    this.backgroundColor = Colors.transparent,
    this.progressColor = Colors.blue,
    this.initialText = 'Pull to refresh',
    this.triggeredText = 'Release to refresh',
    this.triggerHeight = 150.0,
    this.pullSensitivityHeight = 150.0,
    this.initialTextStyle = const TextStyle(
        fontSize: 12, color: Colors.black, fontWeight: FontWeight.bold),
    this.triggerTextStyle = const TextStyle(
        fontSize: 12, color: Colors.blue, fontWeight: FontWeight.bold),
    this.top = true,
    this.left = true,
    this.showProgressIndicator = true,
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
    this.stages,
    this.requireLongPressBeforePull = false,
    this.longPressDuration = const Duration(milliseconds: 500),
    this.longPressProgressBuilder,
    this.onProgressTick,
    this.enableShakeToCancel = false,
    this.progressBackgroundColor,
    this.padding,
    this.spacing = 12.0,
    this.progressStrokeWidth = 6.0,
  })  : onTrigger = _dummyTrigger;

  static void _dummyTrigger() {}

  @override
  State<ReleaseToTrigger> createState() => _ReleaseToTriggerState();
}

class _ReleaseToTriggerState extends State<ReleaseToTrigger>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _springAnimation;
  late Animation<double> _fadeAnimation;

  late AnimationController _longPressAnimationController;

  double _dragOffset = 0.0;
  bool _triggered = false;
  String _statusText = '';
  double _progress = 0.0;
  bool _isDragging = false;

  double _longPressProgress = 0.0;
  bool _longPressCompleted = false;
  bool _isLongPressing = false;
  Offset? _longPressStartOffset;

  StreamSubscription<UserAccelerometerEvent>? _accelerometerSubscription;
  bool _isRefreshing = false;
  List<TriggerStage> _sortedStages = [];
  int _currentStageIndex = -1;

  bool get _isHorizontal =>
      widget.swipeDirection == Axis.horizontal || widget.enableHorizontalSwipe;

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

    _longPressAnimationController = AnimationController(
      vsync: this,
      duration: widget.longPressDuration,
    );
    _longPressAnimationController.addListener(() {
      setState(() {
        _longPressProgress = _longPressAnimationController.value;
      });
    });
    _longPressAnimationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _longPressCompleted = true;
        });
        if (widget.hapticFeedback) {
          HapticFeedback.lightImpact();
        }
      }
    });

    if (widget.stages != null) {
      _sortedStages = List.from(widget.stages!)
        ..sort((a, b) => a.threshold.compareTo(b.threshold));
    }
  }

  @override
  void didUpdateWidget(covariant ReleaseToTrigger oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.longPressDuration != oldWidget.longPressDuration) {
      _longPressAnimationController.duration = widget.longPressDuration;
    }
    if (widget.stages != oldWidget.stages) {
      if (widget.stages != null) {
        _sortedStages = List.from(widget.stages!)
          ..sort((a, b) => a.threshold.compareTo(b.threshold));
      } else {
        _sortedStages = [];
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _longPressAnimationController.dispose();
    _accelerometerSubscription?.cancel();
    super.dispose();
  }

  void _startListeningToShake() {
    if (widget.enableShakeToCancel) {
      _accelerometerSubscription?.cancel();
      _accelerometerSubscription = userAccelerometerEventStream().listen((UserAccelerometerEvent event) {
        final double magnitude = event.x.abs() + event.y.abs() + event.z.abs();
        if (magnitude > 15.0) { // Shake threshold of 15.0 is standard
          _cancelPull();
        }
      });
    }
  }

  void _stopListeningToShake() {
    _accelerometerSubscription?.cancel();
    _accelerometerSubscription = null;
  }

  void _cancelPull() {
    if (widget.hapticFeedback) {
      HapticFeedback.mediumImpact();
    }
    _cancelLongPress();
    _stopListeningToShake();
    _animateCollapse();
  }

  bool _isWithinSensitivity(Offset localPosition) {
    final sensitivity = widget.pullSensitivityHeight;
    if (sensitivity == null) return true;
    final renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox != null && renderBox.hasSize) {
      final size = renderBox.size;
      if (_isHorizontal) {
        final startX = localPosition.dx;
        if (widget.left ?? true) {
          if (startX > sensitivity) return false;
        } else {
          if (startX < size.width - sensitivity) return false;
        }
      } else {
        final startY = localPosition.dy;
        if (widget.top ?? true) {
          if (startY > sensitivity) return false;
        } else {
          if (startY < size.height - sensitivity) return false;
        }
      }
    }
    return true;
  }

  void _handlePointerDown(PointerDownEvent event) {
    if (_isRefreshing) return;
    if (widget.requireLongPressBeforePull) {
      if (!_isWithinSensitivity(event.localPosition)) return;
      setState(() {
        _isLongPressing = true;
        _longPressCompleted = false;
        _longPressProgress = 0.0;
        _longPressStartOffset = event.position;
      });
      _longPressAnimationController.forward(from: 0.0);
    }
  }

  void _handlePointerMove(PointerMoveEvent event) {
    if (_isLongPressing && !_longPressCompleted && _longPressStartOffset != null) {
      final difference = (event.position - _longPressStartOffset!).distance;
      if (difference > 20.0) { // Cancel on significant movement during long press
        _cancelLongPress();
      }
    }
  }

  void _handlePointerUp(PointerUpEvent event) {
    if (!_isDragging) {
      _cancelLongPress();
    }
  }

  void _handlePointerCancel(PointerCancelEvent event) {
    _cancelLongPress();
  }

  void _cancelLongPress() {
    if (_isLongPressing) {
      _longPressAnimationController.stop();
      setState(() {
        _isLongPressing = false;
        _longPressCompleted = false;
        _longPressProgress = 0.0;
      });
    }
  }

  void _handleDragStart(DragStartDetails details) {
    if (_isRefreshing) return;
    if (!_isWithinSensitivity(details.localPosition)) return;

    setState(() {
      _isDragging = true;
      _dragOffset = 0.0;
      _currentStageIndex = -1;
      if (!widget.requireLongPressBeforePull || _longPressCompleted) {
        _animationController.forward();
      }
    });

    _startListeningToShake();
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    if (!_isDragging || _isRefreshing) return;
    if (widget.requireLongPressBeforePull && !_longPressCompleted) {
      return;
    }

    if (widget.requireLongPressBeforePull &&
        _longPressCompleted &&
        !_animationController.isAnimating &&
        _animationController.value == 0) {
      _animationController.forward();
    }

    setState(() {
      double maxThreshold = 1.0;
      if (_sortedStages.isNotEmpty) {
        maxThreshold = _sortedStages.last.threshold;
      }

      final triggerHeight = widget.triggerHeight ?? 250.0;
      final maxDistance = triggerHeight * maxThreshold;
      final isHorizontal = _isHorizontal;
      final delta = isHorizontal ? details.delta.dx : details.delta.dy;

      if (isHorizontal) {
        if (widget.left ?? true) {
          final newOffset = _dragOffset + delta;
          _dragOffset = newOffset.clamp(0.0, maxDistance);
        } else {
          final newOffset = _dragOffset - delta;
          _dragOffset = newOffset.clamp(0.0, maxDistance);
        }
      } else {
        if (widget.top ?? true) {
          final newOffset = _dragOffset + delta;
          _dragOffset = newOffset.clamp(0.0, maxDistance);
        } else {
          final newOffset = _dragOffset - delta;
          _dragOffset = newOffset.clamp(0.0, maxDistance);
        }
      }

      _progress = (_dragOffset / triggerHeight).clamp(0.0, maxThreshold);

      // Notify progress tick callback
      widget.onProgressTick?.call(_progress);

      if (_sortedStages.isNotEmpty) {
        int activeIndex = -1;
        for (int i = 0; i < _sortedStages.length; i++) {
          if (_progress >= _sortedStages[i].threshold) {
            activeIndex = i;
          }
        }

        if (activeIndex > _currentStageIndex) {
          for (int i = _currentStageIndex + 1; i <= activeIndex; i++) {
            _sortedStages[i].onStageReached?.call();
          }
          if (widget.hapticFeedback) {
            HapticFeedback.mediumImpact();
          }
        }
        _currentStageIndex = activeIndex;

        if (activeIndex >= 0) {
          _statusText = _sortedStages[activeIndex].label;
          _triggered = activeIndex == _sortedStages.length - 1;
        } else {
          _statusText = widget.initialText ?? "Swipe to trigger";
          _triggered = false;
        }
      } else {
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
      }
    });
  }

  void _handleDragEnd(DragEndDetails details) {
    if (!_isDragging || _isRefreshing) return;

    _stopListeningToShake();

    if (_triggered) {
      if (widget.hapticFeedback) {
        HapticFeedback.heavyImpact();
      }

      if (widget.onRefresh != null) {
        setState(() {
          _isRefreshing = true;
          _dragOffset = widget.triggerHeight ?? 250.0;
          _progress = 1.0;
          _statusText = widget.triggeredText ?? "Refreshing...";
        });

        widget.onRefresh!().then((_) {
          if (mounted) {
            _animateCollapse();
          }
        }).catchError((error) {
          if (mounted) {
            _animateCollapse();
          }
        });
        return;
      } else {
        widget.onTrigger();
      }
    }

    _animateCollapse();
  }

  void _animateCollapse() {
    _animationController.reverse().then((_) {
      if (mounted) {
        setState(() {
          _dragOffset = 0.0;
          _progress = 0.0;
          _triggered = false;
          _isDragging = false;
          _isRefreshing = false;
          _longPressCompleted = false;
          _isLongPressing = false;
          _longPressProgress = 0.0;
          _statusText = widget.initialText ?? "Swipe to trigger";
        });
      }
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
            value: _isRefreshing ? null : _progress,
            valueColor: AlwaysStoppedAnimation<Color>(
                widget.progressColor ?? Colors.blue),
            backgroundColor: widget.progressBackgroundColor ??
                widget.progressColor?.withAlpha(30) ??
                Colors.blue.withAlpha(30),
            strokeWidth: widget.progressStrokeWidth,
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
          opacity: _progress.clamp(0.0, 1.0),
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
                value: _isRefreshing ? null : _progress,
                valueColor: AlwaysStoppedAnimation<Color>(
                    widget.progressColor ?? Colors.blue),
                backgroundColor: widget.progressBackgroundColor ??
                    widget.progressColor?.withAlpha(30) ??
                    Colors.blue.withAlpha(30),
                strokeWidth: widget.progressStrokeWidth,
              ),
            );
    }
  }

  Widget _buildPullContainer() {
    if (!_isRefreshing && _dragOffset < widget.dragThreshold) {
      return const SizedBox.shrink();
    }

    // Determine maxThreshold
    double maxThreshold = 1.0;
    if (_sortedStages.isNotEmpty) {
      maxThreshold = _sortedStages.last.threshold;
    }

    final maxDistance = (widget.triggerHeight ?? 250.0) * maxThreshold;
    final currentOffset = _dragOffset.clamp(0.0, maxDistance);
    final isHorizontal = _isHorizontal;

    TextStyle? labelStyle;
    if (_currentStageIndex >= 0 && _currentStageIndex < _sortedStages.length) {
      labelStyle = _sortedStages[_currentStageIndex].textStyle;
    }
    labelStyle ??= _triggered ? widget.triggerTextStyle : widget.initialTextStyle;

    return Container(
      height: isHorizontal ? double.infinity : currentOffset,
      width: isHorizontal ? currentOffset : double.infinity,
      color: _isDragging ? widget.backgroundColor : Colors.transparent,
      padding: widget.padding ?? const EdgeInsets.symmetric(
        vertical: 16.0,
        horizontal: 16.0,
      ),
      child: (_isDragging || _isRefreshing) && currentOffset > 0
          ? FadeTransition(
              opacity: _fadeAnimation,
              child: ConstrainedBox(
                constraints: isHorizontal
                    ? BoxConstraints(maxWidth: currentOffset)
                    : BoxConstraints(maxHeight: currentOffset),
                child: isHorizontal
                    ? SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        physics: const NeverScrollableScrollPhysics(),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: widget.left ?? true
                              ? MainAxisAlignment.start
                              : MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            if (!(widget.left ?? true))
                              SizedBox(width: currentOffset * 0.2),
                            if (widget.showProgressIndicator ?? true)
                              ScaleTransition(
                                scale: _springAnimation,
                                child: _buildProgressIndicator(),
                              ),
                            SizedBox(width: widget.spacing),
                            Text(
                              _statusText,
                              style: labelStyle,
                              textAlign: TextAlign.center,
                            ),
                            if (widget.left ?? true)
                              SizedBox(width: currentOffset * 0.2),
                          ],
                        ),
                      )
                    : SingleChildScrollView(
                        physics: const NeverScrollableScrollPhysics(),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: widget.top ?? true
                              ? MainAxisAlignment.start
                              : MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            if (!(widget.top ?? true))
                              SizedBox(height: currentOffset * 0.2),
                            if (widget.showProgressIndicator ?? true)
                              ScaleTransition(
                                scale: _springAnimation,
                                child: _buildProgressIndicator(),
                              ),
                            SizedBox(height: widget.spacing),
                            Text(
                              _statusText,
                              style: labelStyle,
                              textAlign: TextAlign.center,
                            ),
                            if (widget.top ?? true)
                              SizedBox(height: currentOffset * 0.2),
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
    final isHorizontal = _isHorizontal;
    
    Widget result = GestureDetector(
      behavior: HitTestBehavior.opaque,
      onVerticalDragStart: isHorizontal ? null : _handleDragStart,
      onVerticalDragUpdate: isHorizontal ? null : _handleDragUpdate,
      onVerticalDragEnd: isHorizontal ? null : _handleDragEnd,
      onHorizontalDragStart: isHorizontal ? _handleDragStart : null,
      onHorizontalDragUpdate: isHorizontal ? _handleDragUpdate : null,
      onHorizontalDragEnd: isHorizontal ? _handleDragEnd : null,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(
            child: AbsorbPointer(
              absorbing: (widget.preventScrollingWhileDragging && _isDragging) || _isRefreshing,
              child: widget.child,
            ),
          ),
          if (_isDragging || _isRefreshing)
            Positioned(
              top: isHorizontal ? 0 : (widget.top ?? true ? 0 : null),
              bottom: isHorizontal ? 0 : (widget.top ?? true ? null : 0),
              left: isHorizontal ? (widget.left ?? true ? 0 : null) : 0,
              right: isHorizontal ? (widget.left ?? true ? null : 0) : 0,
              child: Material(
                type: MaterialType.transparency,
                child: _buildPullContainer(),
              ),
            ),
          if (_isLongPressing && !_longPressCompleted)
            Positioned.fill(
              child: Center(
                child: widget.longPressProgressBuilder?.call(context, _longPressProgress) ??
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.black.withAlpha(150),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: CircularProgressIndicator(
                        value: _longPressProgress,
                        valueColor: AlwaysStoppedAnimation<Color>(
                            widget.progressColor ?? Colors.blue),
                        strokeWidth: 4,
                      ),
                    ),
              ),
            ),
        ],
      ),
    );

    if (widget.requireLongPressBeforePull) {
      result = Listener(
        onPointerDown: _handlePointerDown,
        onPointerMove: _handlePointerMove,
        onPointerUp: _handlePointerUp,
        onPointerCancel: _handlePointerCancel,
        child: result,
      );
    }

    return result;
  }
}
