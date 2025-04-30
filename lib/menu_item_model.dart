class MenuItemModel {
  final String icon;
  final String label;

  MenuItemModel({required this.icon, required this.label});

  factory MenuItemModel.fromJson(Map<String, dynamic> json) {
    return MenuItemModel(
      icon: json['icon'] as String,
      label: json['label'] as String,
    );
  }
}