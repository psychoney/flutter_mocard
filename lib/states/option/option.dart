class Option {
  final String title;
  final String price;
  final String description;
  final bool isRecommended;

  Option({required this.title, this.isRecommended = false, this.price = '', this.description = ''});
}
