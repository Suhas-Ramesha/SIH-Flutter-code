import 'package:flutter/material.dart';
import '../core/theme.dart';

class ModernCard extends StatefulWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;
  final bool enableHover;
  final double? elevation;
  final Color? backgroundColor;
  final BorderRadius? borderRadius;
  
  const ModernCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.onTap,
    this.enableHover = true,
    this.elevation,
    this.backgroundColor,
    this.borderRadius,
  });
  
  @override
  State<ModernCard> createState() => _ModernCardState();
}

class _ModernCardState extends State<ModernCard> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _elevationAnimation;
  bool _isHovered = false;
  
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.02,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    
    _elevationAnimation = Tween<double>(
      begin: widget.elevation ?? 8.0,
      end: (widget.elevation ?? 8.0) + 4.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }
  
  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
  
  void _onHoverEnter() {
    if (widget.enableHover && widget.onTap != null) {
      setState(() => _isHovered = true);
      _animationController.forward();
    }
  }
  
  void _onHoverExit() {
    if (widget.enableHover && widget.onTap != null) {
      setState(() => _isHovered = false);
      _animationController.reverse();
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            margin: widget.margin ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: widget.onTap,
                onTapDown: (_) => _onHoverEnter(),
                onTapUp: (_) => _onHoverExit(),
                onTapCancel: () => _onHoverExit(),
                borderRadius: widget.borderRadius ?? BorderRadius.circular(16),
                child: Container(
                  padding: widget.padding ?? const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: widget.backgroundColor ?? AppTheme.cardColor,
                    borderRadius: widget.borderRadius ?? BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: _elevationAnimation.value * 2,
                        offset: Offset(0, _elevationAnimation.value),
                        spreadRadius: _isHovered ? 2 : 0,
                      ),
                      if (_isHovered)
                        BoxShadow(
                          color: AppTheme.secondaryColor.withOpacity(0.1),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                          spreadRadius: 2,
                        ),
                    ],
                    border: Border.all(
                      color: _isHovered 
                          ? AppTheme.secondaryColor.withOpacity(0.3)
                          : AppTheme.borderColor.withOpacity(0.5),
                      width: _isHovered ? 1.5 : 1,
                    ),
                  ),
                  child: widget.child,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class ModernButton extends StatefulWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final ButtonStyle? style;
  final bool enableHover;
  
  const ModernButton({
    super.key,
    required this.child,
    this.onPressed,
    this.style,
    this.enableHover = true,
  });
  
  @override
  State<ModernButton> createState() => _ModernButtonState();
}

class _ModernButtonState extends State<ModernButton> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;
  
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }
  
  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: ElevatedButton(
            onPressed: widget.onPressed,
            style: widget.style ?? ElevatedButton.styleFrom(
              backgroundColor: AppTheme.secondaryColor,
              foregroundColor: Colors.black,
              elevation: 6,
              shadowColor: AppTheme.secondaryColor.withOpacity(0.4),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            ),
            onTapDown: widget.enableHover ? (_) {
              setState(() => _isPressed = true);
              _animationController.forward();
            } : null,
            onTapUp: widget.enableHover ? (_) {
              setState(() => _isPressed = false);
              _animationController.reverse();
            } : null,
            onTapCancel: widget.enableHover ? () {
              setState(() => _isPressed = false);
              _animationController.reverse();
            } : null,
            child: widget.child,
          ),
        );
      },
    );
  }
}

class ModernChip extends StatefulWidget {
  final Widget label;
  final VoidCallback? onTap;
  final bool selected;
  final Color? backgroundColor;
  final Color? selectedColor;
  final bool enableHover;
  
  const ModernChip({
    super.key,
    required this.label,
    this.onTap,
    this.selected = false,
    this.backgroundColor,
    this.selectedColor,
    this.enableHover = true,
  });
  
  @override
  State<ModernChip> createState() => _ModernChipState();
}

class _ModernChipState extends State<ModernChip> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<Color?> _colorAnimation;
  bool _isHovered = false;
  
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    
    _colorAnimation = ColorTween(
      begin: widget.backgroundColor ?? AppTheme.cardColor,
      end: widget.selectedColor ?? AppTheme.secondaryColor.withOpacity(0.3),
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }
  
  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
  
  void _onHoverEnter() {
    if (widget.enableHover) {
      setState(() => _isHovered = true);
      _animationController.forward();
    }
  }
  
  void _onHoverExit() {
    if (widget.enableHover) {
      setState(() => _isHovered = false);
      _animationController.reverse();
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: GestureDetector(
            onTap: widget.onTap,
            onTapDown: (_) => _onHoverEnter(),
            onTapUp: (_) => _onHoverExit(),
            onTapCancel: () => _onHoverExit(),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: widget.selected 
                    ? (widget.selectedColor ?? AppTheme.secondaryColor.withOpacity(0.3))
                    : _colorAnimation.value,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: widget.selected 
                      ? AppTheme.secondaryColor
                      : AppTheme.borderColor.withOpacity(0.5),
                  width: widget.selected ? 2 : 1,
                ),
                boxShadow: [
                  if (_isHovered || widget.selected)
                    BoxShadow(
                      color: AppTheme.secondaryColor.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                      spreadRadius: 1,
                    ),
                ],
              ),
              child: widget.label,
            ),
          ),
        );
      },
    );
  }
}
