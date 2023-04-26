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
          InkWell(
            borderRadius: const BorderRadius.all(Radius.circular(3)),
            onTap: () => HomeRoute().go(context),
            child: Text('Petit', style: AppTextStyle.regularBold),
          ),
          const Spacer(),
          if (accessories != null) ...accessories!
        ],
      ),
    );
  }
}
