class EventCategory {
  final String category;
  final String data;

  EventCategory({
    required this.category,
    required this.data,
  });

  factory EventCategory.fromJson(Map<String, dynamic> json) {
    return EventCategory(
      category: json['category'],
      data: json['data'],
    );
  }
}
