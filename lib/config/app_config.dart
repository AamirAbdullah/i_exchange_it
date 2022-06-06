import 'package:flutter/cupertino.dart';

class App {
  late BuildContext _context;
  late double _height;
  late double _width;
  late double _heightPadding;
  late double _widthPadding;

  App(_context) {
    this._context = _context;
    MediaQueryData _queryData = MediaQuery.of(this._context);
    _height = _queryData.size.height / 100.0;
    _width = _queryData.size.width / 100.0;
    _heightPadding = _height - ((_queryData.padding.top + _queryData.padding.bottom) / 100.0);
    _widthPadding = _width - (_queryData.padding.left + _queryData.padding.right) / 100.0;
  }

  double appHeight(double v) {
    return _height * v;
  }

  double appWidth(double v) {
    return _width * v;
  }

  double appVerticalPadding(double v) {
    return _heightPadding * v;
  }

  double appHorizontalPadding(double v) {
    return _widthPadding * v;
  }
}

class Colors {
  Color _mainDarkColor = Color(0xFFf38f1f);
  Color _mainDarkColor2 = Color(0xFF6b3d09);
  Color _secondDarkColor = Color(0xFFccccdd);
  Color _accentDarkColor = Color(0xFF9999aa);
  Color _scaffoldDarkColor = Color(0xFF2C2C2C);
  // Color _captionColor = Color(0xFF);

  Color _featuredColor = Color(0xFF2AB7CA);
  Color _favoriteColor = Color(0xFFd62828);
  Color _topColor = Color(0xFFffe066);
  Color _recentColor = Color(0xFFf7fff7);

  Color _splashColor = Color(0xFF121212);

  Color mainDarkColor(double opacity) {
    return this._mainDarkColor.withOpacity(opacity);
  }

  Color secondDarkColor(double opacity) {
    return this._secondDarkColor.withOpacity(opacity);
  }

  Color accentDarkColor(double opacity) {
    return this._accentDarkColor.withOpacity(opacity);
  }

  Color scaffoldDarkColor(double opacity) {
    return _scaffoldDarkColor.withOpacity(opacity);
  }

  Color splashColor(double opacity) {
    return this._splashColor.withOpacity(opacity);
  }

  Color featuredColor(double opacity) {
    return this._featuredColor.withOpacity(opacity);
  }
  Color topColor(double opacity) {
    return this._topColor.withOpacity(opacity);
  }
  Color recentColor(double opacity) {
    return this._recentColor.withOpacity(opacity);
  }

  Color favoriteColor(double opacity) {
    return this._favoriteColor.withOpacity(opacity);
  }

  LinearGradient appGradient(){
    return LinearGradient(
        colors: [
          Color.fromRGBO(0, 0, 0, 0.85),
          Color.fromRGBO(0, 0, 0, 0.75),
        ],
        begin: FractionalOffset.topCenter,
        end: FractionalOffset.bottomCenter);
  }

  LinearGradient primaryGradient(){
    return LinearGradient(
        colors: <Color>[
          _mainDarkColor2,
          _mainDarkColor,
        ]
    );
  }

}