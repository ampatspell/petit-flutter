part of 'screen.dart';

class _Header extends StatelessWidget {
  final List<Widget>? accessories;

  const _Header({
    required this.accessories,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppEdgeInsets.symmetric15x7,
      child: Row(
        children: [
          Text('Petit', style: AppTextStyle.regularBold),
          const Spacer(),
          if (accessories != null) ...accessories!
        ],
      ),
    );
  }
}
