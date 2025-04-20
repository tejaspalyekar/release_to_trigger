import 'package:flutter/material.dart';

class ReleaseToTrigger extends StatefulWidget {
  final Color? backgroundColor;
  final Color? progressColor;
  final String? initialText;
  final String? triggeredText;
  final double? triggerHeight;

  final bool? showProgressIndicator;
  final TextStyle? initialTextStyle;
  final TextStyle? triggerTextStyle;
  final double? pullSensitivityHeight; // Height limit for pull sensitivity
  final bool? top; // Control whether the animation is at the top or bottom
  final Function onTrigger;
  final Widget child;

  const ReleaseToTrigger({
    super.key,
    this.backgroundColor = Colors.transparent,
    this.progressColor = Colors.blue,
    this.initialText = 'Swipe to trigger',
    this.triggeredText = 'Release to trigger action',
    this.triggerHeight = 250.0,
    this.pullSensitivityHeight = 250.0, // Default sensitive height
    this.initialTextStyle = const TextStyle(
        fontSize: 12, color: Colors.black, fontWeight: FontWeight.bold),
    this.triggerTextStyle = const TextStyle(
        fontSize: 12, color: Colors.blue, fontWeight: FontWeight.bold),
    this.top = true, // By default, the pull effect appears at the top
    this.showProgressIndicator = true,
    required this.onTrigger, // Developer's custom action callback
    required this.child,
  });

  @override
  State<ReleaseToTrigger> createState() => _ReleaseToTriggerState();
}

class _ReleaseToTriggerState extends State<ReleaseToTrigger> {
  double _dragOffset = 0.0;
  bool _triggered = false;
  String _statusText = '';
  double _progress = 0.0; // Track the progress of the swipe
  bool _isDragging = false;
  bool _withinSensitivity =
      false; // Track if drag started within the sensitivity area

  final double _dragThreshold =
      10.0; // Minimum drag distance to start pull-to-refresh

  @override
  void initState() {
    super.initState();
    _statusText = widget.initialText ?? "Swipe to trigger";
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        // Inside build method, GestureDetector code...
  
  onVerticalDragStart: (details) {
    print("Drag Start Detected"); // Debugging print
    // Sensitivity area checks remain the same as per your logic
  },
  
  onVerticalDragUpdate: (details) {
    if (!_withinSensitivity) return;

    setState(() {
      _isDragging = true;
      _dragOffset += details.delta.dy;
      _progress = (_dragOffset.abs() / (widget.triggerHeight ?? 250)).clamp(0.0, 1.0);
      print("Drag Update: Offset: $_dragOffset, Progress: $_progress"); // Debug

      if (_dragOffset.abs() >= widget.triggerHeight!) {
        _statusText = widget.triggeredText!;
        _triggered = true;
      } else {
        _statusText = widget.initialText!;
        _triggered = false;
      }
    });
  },

  onVerticalDragEnd: (details) {
    print("Drag End: Triggered: $_triggered"); // Debugging print
    if (_withinSensitivity && _triggered && _dragOffset.abs() >= widget.triggerHeight!) {
      widget.onTrigger(); // Action Triggered
    }

    // Reset State
    setState(() {
      _dragOffset = 0.0;
      _progress = 0.0;
      _statusText = widget.initialText!;
      _isDragging = false;
      _withinSensitivity = false;
    });
  },

  // Add more debugging prints within your Widget build methods
  // to track the actual values and state changes.

      child: Stack(
        children: [
          Positioned.fill(
            child: widget.child, // Take the full screen
          ),
          // Pull container for top drag
          if (widget.top ?? true)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: _buildPullContainer(),
            ),
          // Pull container for bottom drag
          if (!(widget.top ?? true))
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child:
                  _buildBottomPullContainer(), // Separate logic for bottom pull
            ),
        ],
      ),
    );
  }

  // For top drag container
  Widget _buildPullContainer() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: _isDragging
          ? _dragOffset.abs().clamp(0.0,
              widget.triggerHeight ?? 250) // Limit the height to triggerHeight
          : 0.0, // When not dragging, height should be 0
      color: widget.backgroundColor,
      alignment: Alignment.center,
      child: Visibility(
        visible: _isDragging,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Circular progress indicator that reflects swipe progress
              widget.showProgressIndicator ?? true
                  ? CircularProgressIndicator(
                      value: _progress,
                      valueColor: AlwaysStoppedAnimation<Color>(
                          widget.progressColor ?? Colors.white),
                      backgroundColor: widget.progressColor != null
                          ? widget.progressColor!.withOpacity(0.3)
                          : Colors.white.withOpacity(0.3),
                      strokeWidth: 6,
                    )
                  : const SizedBox(),
              const SizedBox(height: 20),
              // Status text
              Text(
                _statusText,
                style: _statusText == widget.triggeredText
                    ? widget.triggerTextStyle
                    : widget.initialTextStyle,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // For bottom drag container
  Widget _buildBottomPullContainer() {
    return AnimatedContainer(
      padding: EdgeInsets.only(top: widget.top ?? true ? 0 : 20),
      duration: const Duration(milliseconds: 300),
      height: _isDragging
          ? _dragOffset.abs().clamp(0.0,
              widget.triggerHeight ?? 250) // Limit the height to triggerHeight
          : 0.0, // When not dragging, height should be 0
      color: widget.backgroundColor,
      alignment: Alignment.bottomCenter, // Align to the bottom
      child: Visibility(
        visible: _isDragging,
        child: Column(
          mainAxisAlignment: widget.top ?? true
              ? MainAxisAlignment.center
              : MainAxisAlignment.start,
          children: [
            // Circular progress indicator that reflects swipe progress
            widget.showProgressIndicator ?? true
                ? CircularProgressIndicator(
                    value: _progress,
                    valueColor: AlwaysStoppedAnimation<Color>(
                        widget.progressColor ?? Colors.white),
                    backgroundColor: widget.progressColor != null
                        ? widget.progressColor!.withOpacity(0.3)
                        : Colors.white.withOpacity(0.3),
                    strokeWidth: 6,
                  )
                : const SizedBox(),
            const SizedBox(height: 20),
            // Status text
            Text(
              _statusText,
              style: _statusText == widget.triggeredText
                  ? widget.triggerTextStyle
                  : widget.initialTextStyle,
            ),
          ],
        ),
      ),
    );
  }
}
