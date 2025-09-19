enum DropType { water, acid }

class Drop {
  double x;
  double y;
  final DropType type;
  bool active;

  Drop({
    required this.x,
    required this.y,
    required this.type,
    this.active = true,
  });
}
