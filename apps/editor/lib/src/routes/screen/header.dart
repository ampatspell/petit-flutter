part of 'screen.dart';

class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppEdgeInsets.symmetric15x7,
      child: Row(
        children: [
          Text('Petit', style: AppTextStyle.regularBold),
        ],
      ),
    );
  }
}
