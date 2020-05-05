import 'package:flutter_mmhelper/interface/search_listenter.dart';

class SearchClickUtil {
  static final SearchClickUtil _instance = new SearchClickUtil.internal();

  SearchClickUtil.internal();

  factory SearchClickUtil() {
    return _instance;
  }

  SearchClickListener _view;

  setScreenListener(SearchClickListener view) {
    _view = view;
  }

  void onClickSearchButton() {
    if (_view != null) _view.onClickSearch();
  }
}
