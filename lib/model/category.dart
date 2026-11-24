class Category {
  Category(this._name, {this.id});

  final int? id;
  String _name;

  String get name {
    return _name;
  }

  set name(String name) {
    this._name = name;
  }
}
