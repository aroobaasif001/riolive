class LiveCardData {
  final String image;
  final String name;
  final bool isGray;
  const LiveCardData({
    required this.image,
    required this.name,
    this.isGray = false,
  });
}
