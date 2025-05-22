import 'package:flutter/material.dart';

class PageViewModel extends ChangeNotifier{
  bool _showFab = false;
  VoidCallback? _fabAction;
  Widget? _fabIcon;
  Widget _fabLabel = SizedBox();

  bool get showFab => _showFab;
  VoidCallback? get fabAction => _fabAction;
  Widget? get fabIcon => _fabIcon;
  Widget get fabLabel => _fabLabel;

  void _clear() {
    _showFab = false;
    _fabAction = null;
    _fabIcon = null;
    _fabLabel = SizedBox();
  }

  void configureFab(int barIndex) {
    if (barIndex == 0) {
      _showFab = true;
      _fabAction = (){};
      _fabIcon = Icon(Icons.post_add_outlined, size: 24);
      _fabLabel = Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: Text('잃어버렸어요'),
      );
    }
    else if (barIndex == 1) {
      _showFab = true;
      _fabAction = (){};
      _fabIcon = Icon(Icons.post_add_outlined, size: 24);
      _fabLabel = Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: Text('주웠어요'),
      );
    } else {
      _clear();
    }  
    notifyListeners();
  }

  void hideFab() {
    _showFab = false;
    _clear();
    notifyListeners();
  }
}