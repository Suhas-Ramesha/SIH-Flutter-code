import 'package:flutter/material.dart';
import '../core/theme.dart';

class VoteButton extends StatelessWidget {
  final IconData icon;
  final int count;
  final VoidCallback? onPressed;
  final bool isSelected;
  final Color? color;
  final Color? selectedColor;
  
  const VoteButton({
    super.key,
    required this.icon,
    required this.count,
    this.onPressed,
    this.isSelected = false,
    this.color,
    this.selectedColor,
  });
  
  @override
  Widget build(BuildContext context) {
    final effectiveColor = isSelected 
        ? (selectedColor ?? AppTheme.primaryColor)
        : (color ?? AppTheme.textSecondaryColor);
    
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? effectiveColor.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? effectiveColor : Colors.transparent,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 20,
              color: effectiveColor,
            ),
            const SizedBox(width: 8),
            Text(
              count.toString(),
              style: TextStyle(
                color: effectiveColor,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class VoteButtonGroup extends StatelessWidget {
  final int upvotes;
  final int downvotes;
  final VoidCallback? onUpvote;
  final VoidCallback? onDownvote;
  final VoidCallback? onRemoveVote;
  final String? userVote; // 'up', 'down', or null
  
  const VoteButtonGroup({
    super.key,
    required this.upvotes,
    required this.downvotes,
    this.onUpvote,
    this.onDownvote,
    this.onRemoveVote,
    this.userVote,
  });
  
  @override
  Widget build(BuildContext context) {
    final netVotes = upvotes - downvotes;
    
    return Row(
      children: [
        // Upvote Button
        VoteButton(
          icon: Icons.thumb_up,
          count: upvotes,
          onPressed: userVote == 'up' ? onRemoveVote : onUpvote,
          isSelected: userVote == 'up',
          color: AppTheme.textSecondaryColor,
          selectedColor: AppTheme.successColor,
        ),
        
        const SizedBox(width: 16),
        
        // Net Votes Display
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: netVotes >= 0 
                ? AppTheme.successColor.withOpacity(0.1)
                : AppTheme.errorColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            '${netVotes >= 0 ? '+' : ''}$netVotes',
            style: TextStyle(
              color: netVotes >= 0 ? AppTheme.successColor : AppTheme.errorColor,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        
        const SizedBox(width: 16),
        
        // Downvote Button
        VoteButton(
          icon: Icons.thumb_down,
          count: downvotes,
          onPressed: userVote == 'down' ? onRemoveVote : onDownvote,
          isSelected: userVote == 'down',
          color: AppTheme.textSecondaryColor,
          selectedColor: AppTheme.errorColor,
        ),
      ],
    );
  }
}
