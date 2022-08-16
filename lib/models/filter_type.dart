class FilterType {
  String? emoji;
  String? label;
  // Color color;
  bool? isSelected;
  FilterType(this.emoji, this.label, this.isSelected);
}

class FilterTypes {
  List<FilterType>? filterType;
  int? index;
  String? current;
  FilterTypes(this.filterType, this.index, this.current);
}
