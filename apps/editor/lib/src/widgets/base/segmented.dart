import 'package:fluent_ui/fluent_ui.dart';
import 'package:gap/gap.dart';

import '../../app/theme.dart';
import '../../app/utils.dart';
import 'gaps.dart';

class Segment<T> {
  const Segment({
    required this.label,
    required this.value,
  });

  final String label;
  final T value;
}

class Segmented<T> extends StatelessWidget {
  const Segmented({
    super.key,
    required this.segments,
    required this.selected,
    this.disabled = false,
    this.onSelect,
  });

  final List<Segment<T>> segments;
  final T? selected;
  final ValueChanged<T>? onSelect;
  final bool disabled;

  @override
  Widget build(BuildContext context) {
    const borderRadius = BorderRadius.all(Radius.circular(4));
    return Opacity(
      opacity: disabled ? 0.5 : 1.0,
      child: Container(
        decoration: BoxDecoration(
          color: Grey.grey245,
          border: Border.all(
            color: Grey.grey245,
            strokeAlign: BorderSide.strokeAlignOutside,
          ),
          borderRadius: borderRadius,
        ),
        child: ClipRRect(
          borderRadius: borderRadius,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: withGapsBetween(
              children: [
                for (var segment in segments)
                  Expanded(
                    child: _Segment(
                      model: segment,
                      isSelected: segment.value == selected,
                      onSelect: (onSelect != null && !disabled).ifTrue(() => onSelect!(segment.value)),
                    ),
                  ),
              ],
              gap: const Gap(1),
            ),
          ),
        ),
      ),
    );
  }
}

class _Segment<T> extends StatelessWidget {
  const _Segment({
    required this.model,
    required this.isSelected,
    required this.onSelect,
  });

  final Segment<T> model;
  final bool isSelected;
  final VoidCallback? onSelect;

  @override
  Widget build(BuildContext context) {
    return Button(
      style: ButtonStyle(
        shape: ButtonState.all(LinearBorder.none),
        backgroundColor: ButtonState.resolveWith((states) {
          return isSelected ? Colors.black.withAlpha(240) : Colors.white;
        }),
      ),
      child: Text(
        model.label,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.black.withAlpha(240),
        ),
      ),
      onPressed: onSelect,
    );
  }
}
