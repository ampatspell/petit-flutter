// import 'package:fluent_ui/fluent_ui.dart';
// import 'package:flutter_mobx/flutter_mobx.dart';
// import 'package:petit_zug/petit_zug.dart';
//
// class WithLoadedModel<T extends FirestoreEntity> extends StatelessWidget {
//   final FirestoreDocumentLoader<T> model;
//   final Widget Function(BuildContext context, T entity) builder;
//   final Widget Function(BuildContext context)? onMissing;
//
//   const WithLoadedModel({
//     super.key,
//     required this.model,
//     required this.builder,
//     this.onMissing,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Observer(builder: (context) {
//       if (model.isLoading) {
//         return const SizedBox.shrink();
//       }
//       final content = model.content;
//       if (content == null) {
//         if (onMissing != null) {
//           return onMissing!(context);
//         }
//         return buildPlaceholder('Not found');
//       }
//       if (content.isDeleted) {
//         return buildPlaceholder('Deleted');
//       }
//       return builder(context, content);
//     });
//   }
//
//   Widget buildPlaceholder(String message) {
//     return ScaffoldPage(
//       content: ConstrainedBox(
//         constraints: const BoxConstraints.expand(),
//         child: Padding(
//           padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
//           child: Text(message),
//         ),
//       ),
//     );
//   }
// }
