class NotificationPayload {
  final String title;
  final String body;
  final String? imageUrl;

  const NotificationPayload({
    required this.title,
    required this.body,
    this.imageUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "body": body,
      "image_url": imageUrl,
    };
  }
}