part of 'properties.dart';

class PropertyGroupField extends StatelessWidget {
  const PropertyGroupField({super.key});

  @override
  Widget build(BuildContext context) {
    final property = context.watch<Property<dynamic, dynamic>>();
    final type = property.presentation.type;
    switch (type) {
      case PropertyPresentationType.textBox:
        return const PropertyTextBox();
    }
  }
}
