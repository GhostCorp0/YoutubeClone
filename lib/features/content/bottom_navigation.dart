import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class BottomNavigation extends StatelessWidget {
  final Function(int index) onPressed;
  final int selectedIndex;
  final String? profileImageUrl;

  const BottomNavigation({
    Key? key,
    required this.onPressed,
    this.selectedIndex = 0,
    this.profileImageUrl,
  }) : super(key: key);

  static const double _iconSize = 26.0;
  static const double _labelSize = 10.0;
  static const double _youAvatarSize = 24.0;
  static const Color _selectedColor = Colors.black;
  static const Color _unselectedColor = Colors.black;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 56,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavItem(
                icon: Icons.home_outlined,
                iconActive: Icons.home_rounded,
                label: 'Home',
                isSelected: selectedIndex == 0,
                onTap: () => onPressed(0),
              ),
              _NavItem(
                icon: Icons.play_circle_outline_rounded,
                iconActive: Icons.play_circle_rounded,
                label: 'Shorts',
                isSelected: selectedIndex == 1,
                onTap: () => onPressed(1),
              ),
              _NavItem(
                icon: Icons.add_circle_outline_rounded,
                iconActive: Icons.add_circle_rounded,
                label: '',
                isSelected: selectedIndex == 2,
                onTap: () => onPressed(2),
              ),
              _NavItem(
                icon: Icons.search,
                iconActive: Icons.search_rounded,
                label: 'Search',
                isSelected: selectedIndex == 3,
                onTap: () => onPressed(3),
              ),
              _YouNavItem(
                profileImageUrl: profileImageUrl,
                label: 'You',
                isSelected: selectedIndex == 4,
                onTap: () => onPressed(4),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final IconData iconActive;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.iconActive,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = BottomNavigation._unselectedColor;

    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          splashColor: Colors.transparent,
          highlightColor: color.withOpacity(0.08),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isSelected ? iconActive : icon,
                size: BottomNavigation._iconSize,
                color: color,
              ),
              if (label.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: BottomNavigation._labelSize,
                    color: color,
                    fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _YouNavItem extends StatelessWidget {
  final String? profileImageUrl;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _YouNavItem({
    required this.profileImageUrl,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = isSelected ? BottomNavigation._selectedColor : BottomNavigation._unselectedColor;

    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          splashColor: Colors.transparent,
          highlightColor: color.withOpacity(0.08),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: BottomNavigation._youAvatarSize / 2,
                backgroundColor: Colors.grey[300],
                backgroundImage: profileImageUrl != null && profileImageUrl!.isNotEmpty
                    ? CachedNetworkImageProvider(profileImageUrl!)
                    : null,
                child: profileImageUrl == null || profileImageUrl!.isEmpty
                    ? Icon(Icons.person_rounded, size: BottomNavigation._youAvatarSize, color: color)
                    : null,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: BottomNavigation._labelSize,
                  color: color,
                  fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
