import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class ToolButtons extends StatelessWidget {
  final bool isPencilActivated;
  final Function() onPencilPressed;
  final Function() onUndoPressed;
  final Function() onEraserPressed;
  final Function() onHintPressed;
  final int remainingHints;
  final ThemeData theme;

  const ToolButtons({
    super.key,
    required this.isPencilActivated,
    required this.onPencilPressed,
    required this.onUndoPressed,
    required this.onEraserPressed,
    required this.onHintPressed,
    required this.remainingHints,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 7.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Undo button
          _buildToolButton(
            icon: Iconsax.undo,
            onPressed: onUndoPressed,
          ),

          // Eraser button
          _buildToolButton(
            icon: Iconsax.eraser_15,
            onPressed: onEraserPressed,
          ),

          // Pencil button
          _buildToolButton(
            icon: Iconsax.edit,
            onPressed: onPencilPressed,
            isActive: isPencilActivated,
          ),

          // Hint button
          _buildHintButton(
            icon: Icons.lightbulb_outline_sharp,
            onPressed: onHintPressed,
            remainingHints: remainingHints,
          ),
        ],
      ),
    );
  }

  Widget _buildToolButton({
    required IconData icon,
    required Function() onPressed,
    bool isActive = false,
  }) {
    return Ink(
      decoration: BoxDecoration(
        color: isActive ? theme.primaryColor : theme.colorScheme.secondary,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.secondary,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor,
            blurRadius: 5,
            spreadRadius: 2,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Icon(
            icon,
            size: 32,
            color: isActive
                ? theme.colorScheme.onSurface
                : theme.colorScheme.onSurface,
          ),
        ),
      ),
    );
  }

  Widget _buildHintButton({
    required IconData icon,
    required Function() onPressed,
    required int remainingHints,
  }) {
    return Ink(
      decoration: BoxDecoration(
        color: theme.colorScheme.secondary,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.secondary,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor,
            blurRadius: 5,
            spreadRadius: 2,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Stack(
            children: [
              Icon(
                icon,
                size: 32,
                color: theme.colorScheme.onSurface,
              ),
              Positioned(
                top: -4,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: theme.primaryColor,
                  ),
                  child: Text(
                    '$remainingHints',
                    style: theme.textTheme.bodySmall,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
