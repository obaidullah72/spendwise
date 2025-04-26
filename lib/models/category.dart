class Category {
  final int? id;
  final String name;
  final String icon; // Store icon name or path

  Category({this.id, required this.name, required this.icon});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'icon': icon,
    };
  }

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      id: map['id'],
      name: map['name'],
      icon: map['icon'],
    );
  }
}