import 'package:flutter/material.dart';

class ReleaseToTrigger extends StatefulWidget {
  final Color backgroundColor;
  final Color progressColor;
  final String initialText;
  final String triggeredText;
  final double triggerHeight;

  final bool showProgressIndicator;
  final TextStyle initialTextStyle;
  final TextStyle triggerTextStyle;
  final double pullSensitivityHeight; // Height limit for pull sensitivity
  final bool top; // Control whether the animation is at the top or bottom
  final Function onTrigger;
  final Widget child;

  const ReleaseToTrigger({
    super.key,
    this.backgroundColor = Colors.transparent,
    this.progressColor = Colors.white,
    this.initialText = 'Swipe to trigger',
    this.triggeredText = 'Release to trigger action',
    this.triggerHeight = 250.0,
    this.pullSensitivityHeight = 250.0, // Default sensitive height
    this.initialTextStyle = const TextStyle(
        fontSize: 12, color: Colors.black, fontWeight: FontWeight.bold),
    this.triggerTextStyle = const TextStyle(
        fontSize: 12, color: Colors.red, fontWeight: FontWeight.bold),
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
    _statusText = widget.initialText;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragStart: (details) {
        // Detect if the drag starts within the pull sensitivity area
        if (details.globalPosition.dy <= widget.pullSensitivityHeight &&
            widget.top) {
          _withinSensitivity = true; // Start dragging from the top
        } else if (details.globalPosition.dy >=
                MediaQuery.of(context).size.height -
                    widget.pullSensitivityHeight &&
            !widget.top) {
          _withinSensitivity = true; // Start dragging from the bottom
        } else {
          _withinSensitivity = false; // Ignore drag outside sensitivity area
        }
      },
      onVerticalDragUpdate: (details) {
        if (!_withinSensitivity)
          return; // Ignore if drag starts outside sensitivity area

        setState(() {
          // Only start showing the pull effect if the user has dragged more than the threshold
          if (details.delta.dy.abs() > _dragThreshold || _isDragging) {
            _isDragging = true;
            _dragOffset += details.delta.dy;
            _progress = (_dragOffset.abs() / widget.triggerHeight)
                .clamp(0.0, 1.0); // Progress between 0 and 1

            // Update status based on the current drag position
            if (_dragOffset.abs() >= widget.triggerHeight) {
              _statusText = widget.triggeredText;
              _triggered = true;
            } else {
              _statusText = widget.initialText;
              _triggered = false;
            }
          }
        });
      },
      onVerticalDragEnd: (details) {
        if (_withinSensitivity &&
            _triggered &&
            _dragOffset.abs() >= widget.triggerHeight) {
          widget.onTrigger(); // Trigger developer's custom action
        }
        setState(() {
          _dragOffset = 0.0;
          _progress = 0.0; // Reset progress
          _statusText = widget.initialText;
          _isDragging = false; // Reset dragging state
          _withinSensitivity = false; // Reset sensitivity state
        });
      },
      child: Stack(
        children: [
          Positioned.fill(
            child: widget.child, // Take the full screen
          ),
          // Pull container for top drag
          if (widget.top)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: _buildPullContainer(),
            ),
          // Pull container for bottom drag
          if (!widget.top)
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
          ? _dragOffset.abs().clamp(
              0.0, widget.triggerHeight) // Limit the height to triggerHeight
          : 0.0, // When not dragging, height should be 0
      color: widget.backgroundColor,
      alignment: Alignment.center,
      child: Visibility(
        visible: _isDragging,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Circular progress indicator that reflects swipe progress
            widget.showProgressIndicator
                ? CircularProgressIndicator(
                    value: _progress,
                    valueColor:
                        AlwaysStoppedAnimation<Color>(widget.progressColor),
                    backgroundColor: widget.progressColor.withOpacity(0.3),
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

  // For bottom drag container
  Widget _buildBottomPullContainer() {
    return AnimatedContainer(
      padding: EdgeInsets.only(top: widget.top ? 0 : 20),
      duration: const Duration(milliseconds: 300),
      height: _isDragging
          ? _dragOffset.abs().clamp(
              0.0, widget.triggerHeight) // Limit the height to triggerHeight
          : 0.0, // When not dragging, height should be 0
      color: widget.backgroundColor,
      alignment: Alignment.bottomCenter, // Align to the bottom
      child: Visibility(
        visible: _isDragging,
        child: Column(
          mainAxisAlignment:
              widget.top ? MainAxisAlignment.center : MainAxisAlignment.start,
          children: [
            // Circular progress indicator that reflects swipe progress
            widget.showProgressIndicator
                ? CircularProgressIndicator(
                    value: _progress,
                    valueColor:
                        AlwaysStoppedAnimation<Color>(widget.progressColor),
                    backgroundColor: widget.progressColor.withOpacity(0.3),
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
