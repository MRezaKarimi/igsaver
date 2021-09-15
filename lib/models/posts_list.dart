import 'package:flutter/widgets.dart';

// This model keeps a list of posts which are selected by user to be downloaded
class PostsList extends ChangeNotifier {
  Map<int, dynamic> _list = {};

  Map<int, dynamic> get list => _list;

  int get length => _list.length;

  void add(int index, data) {
    _list[index] = data;
    notifyListeners();
  }

  void remove(int index) {
    _list.remove(index);
    notifyListeners();
  }
}
