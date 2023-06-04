import 'package:fluent_ui/fluent_ui.dart';
import 'package:gap/gap.dart';

import '../../app/router.dart';

class DevelopmentScreen extends StatelessWidget {
  const DevelopmentScreen({super.key});

  List<Widget> _buildItems(BuildContext context) {
    Widget item({
      IconData icon = FluentIcons.code,
      required String label,
      VoidCallback? onPressed,
    }) {
      return ListTile.selectable(
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            children: [
              Icon(icon, size: 13),
              const Gap(10),
              Text(label),
            ],
          ),
        ),
        onPressed: onPressed,
      );
    }

    return [
      item(
        label: 'Measurable',
        onPressed: () => DevelopmentOneRoute().go(context),
      ),
      item(
        label: 'Two',
        onPressed: () => DevelopmentTwoRoute().go(context),
      ),
      item(
        label: 'Three',
        onPressed: () => DevelopmentThreeRoute().go(context),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldPage(
      header: const PageHeader(
        title: Text('Development'),
      ),
      content: ListView(children: _buildItems(context)),
    );
  }
}
