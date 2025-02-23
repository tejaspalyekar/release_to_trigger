import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A widget that allows users to swipe down or up to trigger an action.
///
/// This widget provides a customizable way to detect pull gestures and
/// execute a function when the user swipes and releases at a certain threshold.
class ReleaseToTrigger extends StatefulWidget {
  /// Background color of the pull-to-trigger container.
  final Color? backgroundColor;

  /// Color of the progress indicator.
  final Color? progressColor;

  /// Initial text displayed before the trigger threshold is reached.
  final String? initialText;

  /// Text displayed when the trigger threshold is reached.
  final String? triggeredText;

  /// The height required to trigger the action.
  final double? triggerHeight;

  /// Defines the sensitivity range for detecting the pull gesture.
  final double? pullSensitivityHeight;

  /// Determines if the pull gesture starts from the top (`true`) or bottom (`false`).
  final bool? top;

  /// Whether to show a progress indicator during the pull gesture.
  final bool? showProgressIndicator;

  /// Text style for the initial state text.
  final TextStyle? initialTextStyle;

  /// Text style for the triggered state text.
  final TextStyle? triggerTextStyle;

  /// The function to execute when the user releases after reaching the trigger threshold.
  final Function onTrigger;

  /// The child widget over which the pull-to-trigger feature is implemented.
  final Widget child;

  /// Duration of the pull animation.
  final Duration animationDuration;

  /// The curve of the pull animation.
  final Curve animationCurve;

  /// The minimum drag distance required to start triggering the pull gesture.
  final double dragThreshold;

  /// Whether to provide haptic feedback when the trigger threshold is reached.
  final bool hapticFeedback;

  /// A custom widget to use as the progress indicator.
  final Widget? customProgressIndicator;

  /// If `true`, prevents scrolling while dragging the pull container.
  final bool preventScrollingWhileDragging;

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
      fontSize: 12,
      color: Colors.black,
      fontWeight: FontWeight.bold
    ),
    this.triggerTextStyle = const TextStyle(
      fontSize: 12,
      color: Colors.blue,
      fontWeight: FontWeight.bold
    ),
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
  });

  @override
  State<ReleaseToTrigger> createState() => _ReleaseToTriggerState();
}

class _ReleaseToTriggerState extends State<ReleaseToTrigger> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  
  double _dragOffset = 0.0;
  bool _triggered = false;
  String _statusText = '';
  double _progress = 0.0;
  bool _isDragging = false;
  bool _withinSensitivity = false;
  
  double _initialTouchY = 0.0;
  double _lastTouchY = 0.0;
  bool _isDragInProgress = false;

  @override
  void initState() {
    super.initState();
    _statusText = widget.initialText ?? "Swipe to trigger";
    
    _animationController = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  /// Handles the start of the drag gesture.
  void _handleDragStart(DragStartDetails details) {
    final screenHeight = MediaQuery.of(context).size.height;
    final sensitivity = widget.pullSensitivityHeight ?? 250.0;
    
    _initialTouchY = details.globalPosition.dy;
    _lastTouchY = _initialTouchY;
    _isDragInProgress = true;

    if (widget.top ?? true) {
      _withinSensitivity = _initialTouchY <= sensitivity;
    } else {
      _withinSensitivity = _initialTouchY >= (screenHeight - sensitivity);
    }

    if (_withinSensitivity) {
      setState(() {
        _isDragging = false;
      });
    }
  }

  /// Handles updates during the drag gesture.
  void _handleDragUpdate(DragUpdateDetails details) {
    if (!_withinSensitivity || !_isDragInProgress) return;

    final currentTouchY = details.globalPosition.dy;
    final dragDelta = currentTouchY - _lastTouchY;
    _lastTouchY = currentTouchY;

    final isValidDirection = widget.top ?? true
        ? dragDelta > 0
        : dragDelta < 0;

    if (!isValidDirection && _dragOffset.abs() < widget.dragThreshold) {
      return;
    }

    setState(() {
      if (!_isDragging) {
        _isDragging = true;
      }

      if (widget.top ?? true) {
        _dragOffset = (_dragOffset + dragDelta)
            .clamp(0.0, widget.triggerHeight ?? 250.0);
      } else {
        _dragOffset = (_dragOffset + dragDelta)
            .clamp(-(widget.triggerHeight ?? 250.0), 0.0);
      }
      
      _progress = (_dragOffset.abs() / (widget.triggerHeight ?? 250.0))
          .clamp(0.0, 1.0);
      
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

  /// Handles the end of the drag gesture.
  void _handleDragEnd(DragEndDetails details) {
    if (_withinSensitivity && _triggered) {
      widget.onTrigger();
      if (widget.hapticFeedback) {
        HapticFeedback.heavyImpact();
      }
    }

    setState(() {
      _dragOffset = 0.0;
      _progress = 0.0;
      _statusText = widget.initialText ?? "Swipe to trigger";
      _isDragging = false;
      _withinSensitivity = false;
      _isDragInProgress = false;
      _initialTouchY = 0.0;
      _lastTouchY = 0.0;
    });
  }

  /// Builds the progress indicator widget.
  Widget _buildProgressIndicator() {
    if (widget.customProgressIndicator != null) {
      return widget.customProgressIndicator!;
    }

    return SizedBox(
      width: 30,
      height: 30,
      child: CircularProgressIndicator(
        value: _progress,
        valueColor: AlwaysStoppedAnimation<Color>(
          widget.progressColor ?? Colors.blue
        ),
        backgroundColor: widget.progressColor?.withAlpha(30) ??
            Colors.blue.withAlpha(30),
        strokeWidth: 6,
      ),
    );
  }

  /// Builds the pull container that appears when dragging.
  Widget _buildPullContainer() {
    final containerHeight = _dragOffset.abs().clamp(0.0, widget.triggerHeight ?? 250.0);
    
    return Container(
      height: containerHeight,
      color: widget.backgroundColor,
      alignment: widget.top ?? true ? Alignment.center : Alignment.bottomCenter,
      child: containerHeight > 0 ? Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.showProgressIndicator ?? true) _buildProgressIndicator(),
          const SizedBox(height: 10),
          Text(_statusText, style: _triggered ? widget.triggerTextStyle : widget.initialTextStyle),
        ],
      ) : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragStart: _handleDragStart,
      onVerticalDragUpdate: _handleDragUpdate,
      onVerticalDragEnd: _handleDragEnd,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(child: widget.child),
          Positioned(top: 0, left: 0, right: 0, child: _buildPullContainer()),
        ],
      ),
    );
  }
}
