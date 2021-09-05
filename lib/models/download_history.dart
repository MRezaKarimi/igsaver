import 'package:flutter/material.dart';

enum Status {
  inProgress,
  successful,
  failed,
}

class DownloadHistory extends ChangeNotifier {
  List<DownloadItem> _downloadsList = [];
  int _index = -1;

  List<DownloadItem> get downloadsList => _downloadsList;

  int addItem(String title, int total) {
    _index++;
    _downloadsList.add(DownloadItem(title, total));
    notifyListeners();
    return _index;
  }

  void setCount(int newCount, int index) {
    if (index < _downloadsList.length) {
      _downloadsList.elementAt(index).count = newCount;
      notifyListeners();
    }
  }
}

class DownloadItem extends ChangeNotifier {
  final String title;
  final int total;
  int _count = 0;
  Status status = Status.inProgress;

  DownloadItem(this.title, this.total);

  int get count => _count;

  double get percentage => _count / total;

  set count(int newCount) {
    _count = newCount;
    if (_count == total) {
      status = Status.successful;
    }
  }
}
