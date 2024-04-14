import 'package:flutter/material.dart';

class AppColors {
  // * Convert Color from Hex to type Flutter 0xFFdddddd
  static Color _colorfromHex(String hexColor, [String opacity = 'FF']) {
    ///hex #FFFFFF
    final String color = hexColor.replaceAll('#', ''); //FFFFFF
    return Color(
        int.parse(opacity + color, radix: 16)); //FFFFFFFF => 0xFFFFFFFF
  }

  static final Color textColor100 = _colorfromHex('#333333');
  static final Color textColor200 = _colorfromHex('#5c5c5c');
  static final Color bgWhite = _colorfromHex('#FFFFFF');

  static final Color textColor = _colorfromHex('#333333');
  static final Color prColorblue = _colorfromHex('#71c4ef'); //#0077C2
  static final Color colorblueaccent = _colorfromHex('#59a5f5');
  static final Color prColor3 = _colorfromHex('#c8ffff');

  static final Color bg200 = _colorfromHex('#f5f5f5');
  static const kTextColor = Color(0xff535353);
  static const kTextlightColor = Color(0xDDACACAc);
  static final Color bg300 = _colorfromHex('#cccccc');
  static final Color blueAccent1 = _colorfromHex('#00BFFF');
  static final Color blueAccent2 = _colorfromHex('#00619a');
  static final Color darkpeimary1 = _colorfromHex('#0085ff');
  static final Color darkprimary2 = _colorfromHex('#69b4ff');
  static final Color darkprimary3 = _colorfromHex('#e0ffff');
  static final Color darkAccent1 = _colorfromHex('#006fff');
  static final Color darkAccent2 = _colorfromHex('#e1ffff');
  static final Color darkTextColor = _colorfromHex('#FFFFFF');
  static final Color darkTextcolor2 = _colorfromHex('#9e9e9e');
  static final Color darkBg100 = _colorfromHex('#1E1E1E');
  static final Color darkBg2 = _colorfromHex('#2d2d2d');
  static final Color darkBg3 = _colorfromHex('#454545');
  static final Color blueDetailsBG = _colorfromHex('#a2e7f5');
  static final Color darkMode = _colorfromHex('#3A3B3C');

  static final Color darkModeCardDetails = _colorfromHex('#484848');

  static final Color darkModeBodyDetails = _colorfromHex('#303030');

  static final Color lightmodeInstallbtn = _colorfromHex('#456369');

  static final Color darkModeInstallbtn = _colorfromHex('#BB86FC');

  static final Color lightModeUnInstallBtn = _colorfromHex('#e95f44');

  static final Color darkModeUnInstallBtn = _colorfromHex('#FF0266');

  static final Color lightModeToast = _colorfromHex('#90ee02');
  static final Color darkModeToast = _colorfromHex('#BB86FC');

  static final Color mb = _colorfromHex('#FF0266');

  static final Color red = _colorfromHex('#B71c1c');

  static final Color orange = _colorfromHex('#F57C00');

  static final Color blackCardSocial = _colorfromHex('#000000', '54');

  static final Color lightLoading = _colorfromHex('#46B5F6');

  static final Color darkLoading = _colorfromHex('#BB86FC');

  static final Color cardClick = _colorfromHex('#46B5F6');

  static final Color cardClickDart = _colorfromHex('#BB86FC');

  static final Color bgwhite = _colorfromHex('#FFFFFF');

  static final Color bgBlack = _colorfromHex('#000000');

  static final Color bgDark = _colorfromHex('#000000');

  static final Color bgCursor = _colorfromHex('#3A3B3C');

  static final Color bgGray = _colorfromHex('#C8C8C8');

  static final Color bgGreen = _colorfromHex('#A5D6A7');

  static final Color bgGreenBold = _colorfromHex('#1B5E20');

  static final Color bgBlue = _colorfromHex('#2196F3');

  static final Color bgRed = _colorfromHex('#FD1D1D');
}
