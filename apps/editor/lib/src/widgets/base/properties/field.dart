part of 'properties.dart';

class _Pair {
  const _Pair(this.state, this.child);

  final PropertyState state;
  final Widget child;
}

class PropertyGroupField extends StatelessWidget {
  const PropertyGroupField({super.key});

  @override
  Widget build(BuildContext context) {
    final property = context.watch<Property<dynamic, dynamic>>();
    final type = property.presentation.type;
    final pair = resolve(type, property);
    return MountingProxyProvider<PropertyState>(
      create: (context) => pair.state,
      child: pair.child,
    );
  }

  _Pair resolve(PropertyPresentationType type, Property<dynamic, dynamic> property) {
    switch (type) {
      case PropertyPresentationType.textBox:
        return _Pair(PropertyTextBoxState(property: property), const PropertyTextBox());
    }
  }
}
