import 'package:fluent_ui/fluent_ui.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen();

  @override
  Widget build(BuildContext context) {
    return ScaffoldPage(
      content: Center(
        child: HyperlinkButton(
          child: SizedBox(
            width: 30,
            height: 40,
            child: Icon(
              FluentIcons.calories,
              color: Colors.black.withAlpha(150),
              size: 30,
            ),
          ),
          onPressed: () {},
        ),
      ),
    );
  }
}
