// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'menu_item_model.dart';
//
// class WebLayout extends StatefulWidget {
//   const WebLayout({super.key});
//
//   @override
//   State<WebLayout> createState() => _WebLayoutState();
// }
//
// class _WebLayoutState extends State<WebLayout> {
//   int _selectedIndex = 0;
//   bool _isExpanded = true;
//   bool _isAnimationCompleted = true;
//   List<MenuItemModel> _menuItems = [];
//
//   static const double collapsedWidth = 56;
//   static const double expandedWidth = 200;
//
//   @override
//   void initState() {
//     super.initState();
//     _loadMenu();
//   }
//
//   Future<void> _loadMenu() async {
//     final String jsonStr = await rootBundle.loadString('assets/menu.json');
//     final List<dynamic> jsonData = json.decode(jsonStr)['menuItems'];
//
//     setState(() {
//       _menuItems =
//           jsonData.map((item) => MenuItemModel.fromJson(item)).toList();
//     });
//   }
//
//   void _toggleMenu() {
//     setState(() {
//       _isExpanded = !_isExpanded;
//       _isAnimationCompleted = false;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Row(
//         children: [
//           AnimatedContainer(
//             duration: const Duration(milliseconds: 300),
//             width: _isExpanded ? expandedWidth : collapsedWidth,
//             onEnd: () {
//               setState(() {
//                 _isAnimationCompleted = true;
//               });
//             },
//             decoration: BoxDecoration(
//               color: Colors.blue.shade50,
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black.withOpacity(0.1),
//                   blurRadius: 4,
//                   offset: const Offset(2, 0),
//                 ),
//               ],
//             ),
//             child: Column(
//               children: [
//                 Align(
//                   alignment: Alignment.centerRight,
//                   child: IconButton(
//                     icon: Icon(
//                       _isExpanded
//                           ? Icons.arrow_back_ios
//                           : Icons.arrow_forward_ios,
//                     ),
//                     onPressed: _toggleMenu,
//                   ),
//                 ),
//                 Expanded(
//                   child: _menuItems.isEmpty
//                       ? const Center(child: CircularProgressIndicator())
//                       : NavigationRail(
//                     selectedIndex: _selectedIndex.clamp(0, _menuItems.length - 1),
//                     onDestinationSelected: (int index) {
//                       setState(() {
//                         _selectedIndex = index;
//                       });
//                     },
//                     extended: _isExpanded,
//                     destinations: _menuItems
//                         .map(
//                           (item) => NavigationRailDestination(
//                         icon: Icon(_getIconByName(item.icon)),
//                         selectedIcon:
//                         Icon(_getIconByName(item.icon), color: Colors.blue),
//                         label: _isExpanded && _isAnimationCompleted
//                             ? Text(item.label)
//                             : const SizedBox.shrink(),
//                       ),
//                     )
//                         .toList(),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           const VerticalDivider(thickness: 1, width: 1),
//           Expanded(
//             child: Center(
//               child: _menuItems.isEmpty
//                   ? const CircularProgressIndicator()
//                   : Text(
//                 'Вы выбрали: ${_menuItems[_selectedIndex].label}',
//                 style: const TextStyle(fontSize: 24),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   /// Преобразует имя иконки в соответствующий объект Icons.
//   IconData _getIconByName(String iconName) {
//     const Map<String, IconData> iconMap = {
//       'home': Icons.thermostat,
//       'person': Icons.folder_copy,
//       'message': Icons.currency_ruble_outlined,
//       'settings': Icons.settings,
//       'info': Icons.info,
//     };
//     return iconMap[iconName] ?? Icons.circle_outlined;
//   }
// }

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'menu_item_model.dart';

class WebLayout extends StatefulWidget {
  const WebLayout({super.key});

  @override
  State<WebLayout> createState() => _WebLayoutState();
}

class _WebLayoutState extends State<WebLayout> {
  List<MenuItemModel> _menuItems = [];
  int _selectedIndex = 0;
  bool _isExpanded = true;
  bool _isAnimationCompleted = true;

  static const double collapsedWidth = 56;
  static const double expandedWidth = 200;

  @override
  void initState() {
    super.initState();
    _loadMenu();
  }

  Future<void> _loadMenu() async {
    final jsonStr = await rootBundle.loadString('assets/menu.json');
    final jsonData = json.decode(jsonStr)['menuItems'] as List;
    setState(() {
      _menuItems =
          jsonData.map((e) => MenuItemModel.fromJson(e)).toList();
    });
  }

  void _toggleMenu() {
    setState(() {
      _isExpanded = !_isExpanded;
      _isAnimationCompleted = false;
    });
  }

  void _onSelect(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final bool isMobile = !kIsWeb &&
        (defaultTargetPlatform == TargetPlatform.iOS ||
            defaultTargetPlatform == TargetPlatform.android);

    if (_menuItems.isEmpty) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      body: isMobile ? _buildMobileLayout() : _buildDesktopLayout(),
      bottomNavigationBar: isMobile ? _buildBottomBar() : null,
    );
  }

  /// Вариант для Web/Desktop
  Widget _buildDesktopLayout() {
    return Row(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: _isExpanded ? expandedWidth : collapsedWidth,
          onEnd: () => setState(() => _isAnimationCompleted = true),
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 4,
                offset: const Offset(2, 0),
              ),
            ],
          ),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  icon: Icon(
                    _isExpanded
                        ? Icons.arrow_back_ios
                        : Icons.arrow_forward_ios,
                  ),
                  onPressed: _toggleMenu,
                ),
              ),
              Expanded(
                child: NavigationRail(
                  selectedIndex: _selectedIndex,
                  onDestinationSelected: _onSelect,
                  extended: _isExpanded,
                  destinations: _menuItems
                      .map(
                        (item) => NavigationRailDestination(
                      icon: Icon(_getIcon(item.icon)),
                      selectedIcon: Icon(
                        _getIcon(item.icon),
                        color: Colors.blue,
                      ),
                      label: _isExpanded && _isAnimationCompleted
                          ? Text(item.label)
                          : const SizedBox.shrink(),
                    ),
                  )
                      .toList(),
                ),
              ),
            ],
          ),
        ),
        const VerticalDivider(thickness: 1, width: 1),
        Expanded(
          child: Center(
            child: Text(
              'Вы выбрали: ${_menuItems[_selectedIndex].label}',
              style: const TextStyle(fontSize: 24),
            ),
          ),
        ),
      ],
    );
  }

  /// Вариант для Mobile
  Widget _buildMobileLayout() {
    return Center(
      child: Text(
        'Вы выбрали: ${_menuItems[_selectedIndex].label}',
        style: const TextStyle(fontSize: 24),
      ),
    );
  }

  Widget _buildBottomBar() {
    // Ограничим до 4 пунктов
    final items = _menuItems.take(4).toList();

    return BottomNavigationBar(
      selectedItemColor: Colors.blueGrey,
      unselectedItemColor: Colors.black,
      currentIndex: _selectedIndex < items.length ? _selectedIndex : 0,
      onTap: _onSelect,
      items: items
          .map(
            (item) => BottomNavigationBarItem(
          icon: Icon(_getIcon(item.icon)),
          label: item.label,
        ),
      )
          .toList(),
    );
  }

  IconData _getIcon(String name) {
    const icons = {
      'home': Icons.home,
      'person': Icons.person,
      'message': Icons.message,
      'settings': Icons.settings,
      'info': Icons.info,
      'thermometer': Icons.device_thermostat,
    };
    return icons[name] ?? Icons.circle_outlined;
  }
}