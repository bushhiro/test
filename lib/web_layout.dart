import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'menu_item_model.dart';

class WebLayout extends StatefulWidget {
  const WebLayout({super.key});

  @override
  State<WebLayout> createState() => _WebLayoutState();
}

class _WebLayoutState extends State<WebLayout> {
  int _selectedIndex = 0;
  bool _isExpanded = true;
  bool _isAnimationCompleted = true;
  List<MenuItemModel> _menuItems = [];

  static const double collapsedWidth = 56;
  static const double expandedWidth = 200;

  @override
  void initState() {
    super.initState();
    _loadMenu();
  }

  Future<void> _loadMenu() async {
    final String jsonStr = await rootBundle.loadString('assets/menu.json');
    final List<dynamic> jsonData = json.decode(jsonStr)['menuItems'];

    setState(() {
      _menuItems =
          jsonData.map((item) => MenuItemModel.fromJson(item)).toList();
    });
  }

  void _toggleMenu() {
    setState(() {
      _isExpanded = !_isExpanded;
      _isAnimationCompleted = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: _isExpanded ? expandedWidth : collapsedWidth,
            onEnd: () {
              setState(() {
                _isAnimationCompleted = true;
              });
            },
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
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
                  child: _menuItems.isEmpty
                      ? const Center(child: CircularProgressIndicator())
                      : NavigationRail(
                    selectedIndex: _selectedIndex.clamp(0, _menuItems.length - 1),
                    onDestinationSelected: (int index) {
                      setState(() {
                        _selectedIndex = index;
                      });
                    },
                    extended: _isExpanded,
                    destinations: _menuItems
                        .map(
                          (item) => NavigationRailDestination(
                        icon: Icon(_getIconByName(item.icon)),
                        selectedIcon:
                        Icon(_getIconByName(item.icon), color: Colors.blue),
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
              child: _menuItems.isEmpty
                  ? const CircularProgressIndicator()
                  : Text(
                'Вы выбрали: ${_menuItems[_selectedIndex].label}',
                style: const TextStyle(fontSize: 24),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Преобразует имя иконки в соответствующий объект Icons.
  IconData _getIconByName(String iconName) {
    const Map<String, IconData> iconMap = {
      'home': Icons.thermostat,
      'person': Icons.folder_copy,
      'message': Icons.currency_ruble_outlined,
      'settings': Icons.settings,
      'info': Icons.info,
    };
    return iconMap[iconName] ?? Icons.circle_outlined;
  }
}