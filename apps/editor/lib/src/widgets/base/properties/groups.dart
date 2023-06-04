part of 'properties.dart';

class PropertyGroupsForm extends StatelessWidget {
  const PropertyGroupsForm({super.key});

  @override
  Widget build(BuildContext context) {
    final groups = context.watch<PropertyGroups>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final group in groups.all)
          ProxyProvider0(
            update: (context, value) => group,
            child: const PropertyGroupForm(),
          ),
      ],
    );
  }
}
