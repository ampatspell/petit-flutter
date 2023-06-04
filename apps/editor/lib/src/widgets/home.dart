import 'package:fluent_ui/fluent_ui.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScaffoldPage(
      content: Center(
        child: HyperlinkButton(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 17, horizontal: 10),
            child: Icon(
              FluentIcons.calories,
              color: Colors.black.withAlpha(150),
              size: 30,
            ),
          ),
          onPressed: null,
        ),
      ),
    );
  }
}
