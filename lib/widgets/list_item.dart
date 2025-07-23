class ListItem {
   ListItem({
    required this.title,
    required this.currentTime,
    required this.done,
  });

  final String title;
  final DateTime currentTime;
  bool done = false;
}
