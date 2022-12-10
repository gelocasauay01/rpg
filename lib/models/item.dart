class Item {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final Function onUse;

  const Item({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.onUse
  });

}