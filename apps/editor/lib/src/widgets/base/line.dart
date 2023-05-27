import 'package:fluent_ui/fluent_ui.dart';

import '../../app/theme.dart';

class HorizontalLine extends StatelessWidget {
  const HorizontalLine({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 1,
      width: double.infinity,
      child: ColoredBox(
        color: Grey.grey245,
      ),
    );
  }
}
