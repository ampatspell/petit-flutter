part of 'properties.dart';

class PropertyGroupForm extends StatelessWidget {
  const PropertyGroupForm({super.key});

  @override
  Widget build(BuildContext context) {
    final group = context.watch<PropertyGroup>();
    final name = group.name;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Grey.grey245),
        ),
      ),
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (name != null) ...[
            DefaultFluentTextStyle(
              resolve: (typography) => typography.caption,
              child: Text(name),
            ),
            const Gap(3),
          ],
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: withGapsBetween(
              children: [
                for (final property in group.properties)
                  Expanded(
                    child: ProxyProvider0<Property<dynamic, dynamic>>(
                      update: (context, value) => property,
                      child: const PropertyGroupField(),
                    ),
                  ),
              ],
              gap: const Gap(10),
            ),
          ),
        ],
      ),
    );
  }
}
