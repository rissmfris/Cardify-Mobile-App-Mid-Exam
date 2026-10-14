import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/app_colors.dart';

/// Smooth, tactile animated switch toggle component for Cardify.
/// Features fluid sliding animations with Curves.easeInOutCubic,
/// physics-inspired squash-and-stretch pill motion during transit,
/// tactile haptic feedback, and generous touch boundaries.
class SmoothSwitchToggle extends StatefulWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final Color activeTrackColor;
  final Color inactiveTrackColor;
  final Color thumbColor;
  final double width;
  final double height;

  const SmoothSwitchToggle({
    super.key,
    required this.value,
    required this.onChanged,
    this.activeTrackColor = AppColors.primaryBlack,
    this.inactiveTrackColor = const Color(0xFFD1D5DB),
    this.thumbColor = Colors.white,
    this.width = 52.0,
    this.height = 30.0,
  });

  @override
  State<SmoothSwitchToggle> createState() => _SmoothSwitchToggleState();
}

class _SmoothSwitchToggleState extends State<SmoothSwitchToggle>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 260),
      value: widget.value ? 1.0 : 0.0,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutCubic,
      reverseCurve: Curves.easeInOutCubic,
    );
  }

  @override
  void didUpdateWidget(covariant SmoothSwitchToggle oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      if (widget.value) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    HapticFeedback.lightImpact();
    final newValue = !widget.value;
    widget.onChanged(newValue);
  }

  @override
  Widget build(BuildContext context) {
    final thumbSize = widget.height - 6.0;
    final maxTravel = widget.width - thumbSize - 6.0;

    return Semantics(
      toggled: widget.value,
      button: true,
      child: GestureDetector(
        onTap: _handleTap,
        behavior: HitTestBehavior.opaque,
        child: Container(
          // Generous touch target wrapper (minimum 44x44)
          padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 6.0),
          child: AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              final progress = _animation.value;
              final trackColor = Color.lerp(
                widget.inactiveTrackColor,
                widget.activeTrackColor,
                progress,
              )!;

              // Gentle stretch effect while thumb is traveling
              final stretch = math.sin(progress * math.pi) * 3.5;
              final currentThumbWidth = thumbSize + stretch;
              final thumbOffset = progress * (maxTravel - (stretch / 2));

              return Container(
                width: widget.width,
                height: widget.height,
                padding: const EdgeInsets.all(3.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(widget.height / 2),
                  color: trackColor,
                  boxShadow: [
                    BoxShadow(
                      color: trackColor.withAlpha(progress > 0.5 ? 40 : 15),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    Positioned(
                      left: thumbOffset.clamp(0.0, maxTravel),
                      top: 0,
                      bottom: 0,
                      child: Container(
                        width: currentThumbWidth,
                        height: thumbSize,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(thumbSize / 2),
                          color: widget.thumbColor,
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x33000000),
                              blurRadius: 4,
                              offset: Offset(0, 1.5),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
