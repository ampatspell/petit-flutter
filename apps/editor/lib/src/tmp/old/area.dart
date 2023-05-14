// import 'package:flutter/material.dart';
// import 'package:flutter_hooks/flutter_hooks.dart';
//
// import '../theme.dart';
//
// part 'draggable.dart';
//
// part 'node.dart';
//
// part 'node/container.dart';
//
// part 'resizable.dart';
//
// class AreaEditor extends HookWidget {
//   final EditorArea area;
//
//   const AreaEditor({
//     super.key,
//     required this.area,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Observer(
//       builder: (context) {
//         return Container(
//           color: Colors.black.withAlpha(10),
//           child: Stack(
//             fit: StackFit.expand,
//             children: [
//               for (var node in area.nodes)
//                 _AreaNodeEditor(
//                   node: node,
//                   area: area,
//                 ),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }
