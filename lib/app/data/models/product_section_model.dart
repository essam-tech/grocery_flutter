class ProductSectionModel {
  final String? title;     // عنوان الكارد
  final String? subtitle;  // الوصف أو النص الصغير
  final String? icon;      // رابط الأيقونة أو اسم الأيقونة

  ProductSectionModel({
    this.title,
    this.subtitle,
    this.icon,
  });

  factory ProductSectionModel.fromJson(Map<String, dynamic> json) {
    return ProductSectionModel(
      title: json['Title'] as String?,
      subtitle: json['Subtitle'] as String?,
      icon: json['Icon'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Title': title,
      'Subtitle': subtitle,
      'Icon': icon,
    };
  }
}
