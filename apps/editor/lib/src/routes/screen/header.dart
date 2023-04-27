part of 'screen.dart';

class _Header extends StatelessWidget {
  final List<Widget>? accessories;

  const _Header({
    required this.accessories,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Row(
        children: [
          InkWell(
            hoverColor: Colors.transparent,
            borderRadius: const BorderRadius.all(Radius.circular(3)),
            onTap: () => HomeRoute().go(context),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Text('Petit', style: AppTextStyle.regularBold),
            ),
          ),
          const Spacer(),
          if (accessories != null) ...accessories!
        ],
      ),
    );
  }
}
