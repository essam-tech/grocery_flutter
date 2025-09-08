class CategoryModel {
  final String id;
  final String name;
  final String image;
  final bool isDefault;

  CategoryModel({
    required this.id,
    required this.name,
    required this.image,
    this.isDefault = false,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'].toString(),
      name: json['name'] ?? '',
      image: json['image'] ?? '',
      isDefault: json['isDefault'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'isDefault': isDefault,
    };
  }
}
