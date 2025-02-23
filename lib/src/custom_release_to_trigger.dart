import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ReleaseToTrigger extends StatefulWidget {
  final Color? backgroundColor;
  final Color? progressColor;
  final String? initialText;
  final String? triggeredText;
  final double? triggerHeight;
  final bool? showProgressIndicator;
  final TextStyle? initialTextStyle;
  final TextStyle? triggerTextStyle;
  final double? pullSensitivityHeight;
  final bool? top;
  final Function onTrigger;
  final Widget child;
  
  // New parameters for better customization
  final Duration animationDuration;
  final Curve animationCurve;
  final double dragThreshold;
  final bool hapticFeedback;
  final Widget? customProgressIndicator;
  final bool preventScrollingWhileDragging;

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

      // Ensure drag offset stays within bounds and positive
      if (widget.top ?? true) {
        _dragOffset = (_dragOffset + dragDelta)
            .clamp(0.0, widget.triggerHeight ?? 250.0);
      } else {
        _dragOffset = (_dragOffset + dragDelta)
            .clamp(-(widget.triggerHeight ?? 250.0), 0.0);
      }
      
      // Calculate progress
      _progress = (_dragOffset.abs() / (widget.triggerHeight ?? 250.0))
          .clamp(0.0, 1.0);
      
      // Update triggered state
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
        backgroundColor: widget.progressColor?.withOpacity(0.3) ??
            Colors.blue.withOpacity(0.3),
        strokeWidth: 6,
      ),
    );
  }

  Widget _buildPullContainer() {
    final containerHeight = _dragOffset.abs().clamp(0.0, widget.triggerHeight ?? 250.0);
    
    return Container(
      height: containerHeight,
      color: widget.backgroundColor,
      alignment: widget.top ?? true ? Alignment.center : Alignment.bottomCenter,
      child: containerHeight > 0 ? SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: widget.top ?? true
                ? MainAxisAlignment.center
                : MainAxisAlignment.end,
            children: [
              if (widget.showProgressIndicator ?? true) 
                _buildProgressIndicator(),
              const SizedBox(height: 10),
              Text(
                _statusText,
                style: _triggered
                    ? widget.triggerTextStyle
                    : widget.initialTextStyle,
              ),
            ],
          ),
        ),
      ) : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onVerticalDragStart: _handleDragStart,
      onVerticalDragUpdate: _handleDragUpdate,
      onVerticalDragEnd: _handleDragEnd,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(child: widget.child),
          if (widget.top ?? true)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: _buildPullContainer(),
            ),
          if (!(widget.top ?? true))
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: _buildPullContainer(),
            ),
        ],
      ),
    );
  }
}