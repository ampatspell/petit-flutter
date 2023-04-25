import 'package:flutter/material.dart';

import '../theme.dart';

class Separator extends StatelessWidget {
  const Separator({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.grey230,
      height: 1,
    );
  }
}
