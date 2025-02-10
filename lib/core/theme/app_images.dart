import 'package:flutter_svg/svg.dart';

class AppImages {
  static const basepath = 'images/';

  static final SvgPicture arrowBackImage =
      SvgPicture.asset('${basepath}arrow_back.svg');
  static final SvgPicture logoutImage =
      SvgPicture.asset('${basepath}logout.svg');

  static const splashBg = '${basepath}splash_bg.jpg';
}
