import 'package:flutter/widgets.dart';

class PostsList extends ChangeNotifier {
  Map<int, dynamic> _list = {};

  get list => _list;

  get length => _list.length;

  void add(int index, data) {
    _list[index] = data;
    notifyListeners();
  }

  void remove(int index) {
    _list.remove(index);
    notifyListeners();
  }
}
