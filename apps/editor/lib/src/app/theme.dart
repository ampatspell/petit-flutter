import 'package:fluent_ui/fluent_ui.dart';
import 'package:google_fonts/google_fonts.dart';

abstract class Grey {
  static const Color grey020 = Color.fromARGB(255, 20, 20, 20);
  static const Color grey100 = Color.fromARGB(255, 100, 100, 100);
  static const Color grey245 = Color.fromARGB(255, 245, 245, 245);
  static const Color grey250 = Color.fromARGB(255, 250, 250, 250);

  static const Color grey221 = Color.fromARGB(255, 221, 221, 221);
  static const Color grey200 = Color.fromARGB(255, 200, 200, 200);
  static const Color red = Color.fromARGB(255, 226, 124, 133);
  static const Color blue = Color.fromARGB(255, 111, 190, 238);
}

final fontFamily = GoogleFonts.ubuntuMono().fontFamily;
final lightTheme = FluentThemeData.light();

final typography = Typography.raw(
  titleLarge: lightTheme.typography.titleLarge!.copyWith(fontFamily: fontFamily, fontSize: 21),
  title: lightTheme.typography.title!.copyWith(fontFamily: fontFamily, fontSize: 18),
  subtitle: lightTheme.typography.subtitle!.copyWith(fontFamily: fontFamily),
  bodyLarge: lightTheme.typography.bodyLarge!.copyWith(fontFamily: fontFamily),
  body: lightTheme.typography.body!.copyWith(fontFamily: fontFamily),
  bodyStrong: lightTheme.typography.bodyStrong!.copyWith(fontFamily: fontFamily),
  caption: lightTheme.typography.caption!.copyWith(fontFamily: fontFamily),
  display: lightTheme.typography.display!.copyWith(fontFamily: fontFamily),
);

final theme = lightTheme.copyWith(
  typography: typography,
  navigationPaneTheme: NavigationPaneThemeData(
    itemHeaderTextStyle: typography.bodyStrong,
    selectedTextStyle: ButtonState.all(typography.body),
    unselectedTextStyle: ButtonState.all(typography.body),
    selectedTopTextStyle: ButtonState.all(typography.body),
    unselectedTopTextStyle: ButtonState.all(typography.body),
  ),
  buttonTheme: ButtonThemeData(
    filledButtonStyle: ButtonStyle(
      padding: ButtonState.all(const EdgeInsets.fromLTRB(10, 7, 10, 8)),
    ),
    defaultButtonStyle: ButtonStyle(
      padding: ButtonState.all(const EdgeInsets.fromLTRB(10, 7, 10, 8)),
    ),
  ),
);
