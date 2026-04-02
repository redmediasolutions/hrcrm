import 'package:flutter/material.dart';

class AppHeader extends StatelessWidget implements PreferredSizeWidget {
  final String searchHint;
  final bool showBackButton;
  final double searchWidth;
  final double toolbarHeight;
  final EdgeInsets searchPadding;
  final Color backgroundColor;
  final Color searchFillColor;
  final double searchBorderRadius;
  final ValueChanged<String>? onSearchChanged;
  final VoidCallback? onNotificationsPressed;
  final VoidCallback? onAppsPressed;
  final Widget? avatar;

  const AppHeader({
    super.key,
    required this.searchHint,
    this.showBackButton = false,
    this.searchWidth = 400,
    this.toolbarHeight = 80,
    this.searchPadding = const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
    this.backgroundColor = Colors.white,
    this.searchFillColor = const Color(0xFFF5F5F5),
    this.searchBorderRadius = 8,
    this.onSearchChanged,
    this.onNotificationsPressed,
    this.onAppsPressed,
    this.avatar,
  });

  @override
  Size get preferredSize => Size.fromHeight(toolbarHeight);

  @override
  Widget build(BuildContext context) {
    final searchField = SizedBox(
      width: searchWidth,
      child: TextFormField(
        onChanged: onSearchChanged,
        decoration: InputDecoration(
          hintText: searchHint,
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(searchBorderRadius),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: searchFillColor,
        ),
      ),
    );

    return AppBar(
      elevation: 0,
      toolbarHeight: toolbarHeight,
      backgroundColor: backgroundColor,
      leading: showBackButton ? const BackButton(color: Colors.black) : Padding(padding: searchPadding, child: searchField),
      leadingWidth: showBackButton ? null : searchWidth + searchPadding.horizontal,
      title: showBackButton ? searchField : null,
      actions: [
        IconButton(
          onPressed: onNotificationsPressed ?? () {},
          icon: const Icon(Icons.notifications_none_rounded, color: Colors.black),
        ),
        IconButton(
          onPressed: onAppsPressed ?? () {},
          icon: const Icon(Icons.apps_outlined, color: Colors.black),
        ),
        const VerticalDivider(indent: 20, endIndent: 20, thickness: 1),
        avatar ??
            const CircleAvatar(
              backgroundColor: Color(0xFF0C5D6B),
              child: Icon(Icons.person, color: Colors.white, size: 20),
            ),
        const SizedBox(width: 16),
      ],
    );
  }
}
