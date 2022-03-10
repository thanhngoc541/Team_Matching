class FilterObject {
  final String status;
  final Filter filter;

  FilterObject({required this.status, required this.filter});
}

class Filter {
  final String field;

  Filter(this.field);
}
