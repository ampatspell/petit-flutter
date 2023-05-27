// import 'package:fluent_ui/fluent_ui.dart';
// import 'package:flutter_hooks/flutter_hooks.dart';
// import 'package:flutter_mobx/flutter_mobx.dart';
//
// import '../stores/sprite.dart';
//
// extension AligmentIncludes on Alignment {
//   bool get containsLeft => [
//         Alignment.centerLeft,
//         Alignment.bottomLeft,
//         Alignment.topLeft
//       ].contains(this);
//
//   bool get containsRight => [
//         Alignment.centerRight,
//         Alignment.bottomRight,
//         Alignment.topRight
//       ].contains(this);
//
//   bool get containsTop => [
//         Alignment.topLeft,
//         Alignment.topRight,
//         Alignment.topCenter
//       ].contains(this);
//
//   bool get containsBottom => [
//         Alignment.bottomRight,
//         Alignment.bottomLeft,
//         Alignment.bottomCenter
//       ].contains(this);
// }
//
// abstract class WithRenderedSize extends Widget {
//   const WithRenderedSize({super.key});
//
//   Size get renderedSize;
// }
//
// class ResizeState {
//   final Rect initial;
//   Rect previous;
//
//   ResizeState._(this.initial, this.previous);
//
//   factory ResizeState.create(Rect entity, double pixel) {
//     final scaled = Rect.fromLTWH(
//       entity.left * pixel,
//       entity.top * pixel,
//       entity.width * pixel,
//       entity.height * pixel,
//     );
//     return ResizeState._(scaled, scaled);
//   }
// }
//
// class Resizable extends HookWidget {
//   final handleSize = 10.0;
//   final WithRenderedSize child;
//   final double pixel;
//   final HasRect entity;
//
//   const Resizable({
//     super.key,
//     required this.child,
//     required this.entity,
//     required this.pixel,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     final stateRef = useRef<ResizeState?>(null);
//     return Observer(builder: (context) {
//       late Size size = child.renderedSize;
//       return SizedBox(
//         width: size.width + handleSize,
//         height: size.height + handleSize,
//         child: Stack(
//           fit: StackFit.expand,
//           children: [
//             Positioned(
//               top: handleSize / 2,
//               left: handleSize / 2,
//               child: child,
//             ),
//             ResizableHandles(
//               size: handleSize,
//               onDragStarted: (handle) => onDragStarted(stateRef, handle),
//               onDragUpdate: (handle, e) => onDragUpdate(stateRef, handle, e),
//               onDragEnd: (handle, e) => onDragEnd(stateRef, handle, e),
//             ),
//           ],
//         ),
//       );
//     });
//   }
//
//   void onDragStarted(ObjectRef<ResizeState?> ref, Alignment handle) {
//     final rect = entity.rect;
//     ref.value = ResizeState.create(rect, pixel);
//   }
//
//   void onDragUpdate(ObjectRef<ResizeState?> ref, Alignment handle,
//       DragUpdateDetails details) {
//     final state = ref.value!;
//     final delta = details.delta;
//     final screen = state.previous;
//
//     var left = screen.left;
//     var top = screen.top;
//     var right = screen.right;
//     var bottom = screen.bottom;
//
//     if (handle.containsTop) {
//       top = top + delta.dy;
//     }
//     if (handle.containsBottom) {
//       bottom = bottom + delta.dy;
//     }
//     if (handle.containsLeft) {
//       left = left + delta.dx;
//     }
//     if (handle.containsRight) {
//       right = right + delta.dx;
//     }
//
//     double r(value) => (value / pixel).roundToDouble();
//     final rect = Rect.fromLTRB(r(left), r(top), r(right), r(bottom));
//
//     state.previous = Rect.fromLTRB(left, top, right, bottom);
//     entity.updateRect(rect);
//   }
//
//   void onDragEnd(
//       ObjectRef<ResizeState?> ref, Alignment handle, DraggableDetails details) {
//     ref.value = null;
//   }
// }
//
// class ResizableHandles extends StatelessWidget {
//   final double size;
//   final void Function(Alignment handle) onDragStarted;
//   final void Function(Alignment handle, DragUpdateDetails details) onDragUpdate;
//   final void Function(Alignment handle, DraggableDetails details) onDragEnd;
//
//   const ResizableHandles({
//     super.key,
//     required this.size,
//     required this.onDragStarted,
//     required this.onDragUpdate,
//     required this.onDragEnd,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       fit: StackFit.expand,
//       clipBehavior: Clip.hardEdge,
//       children: [
//         ...buildHandles(context),
//       ],
//     );
//   }
//
//   Iterable<Widget> buildHandles(BuildContext context) {
//     final handles = [
//       Alignment.topLeft,
//       Alignment.topCenter,
//       Alignment.topRight,
//       Alignment.centerLeft,
//       Alignment.centerRight,
//       Alignment.bottomLeft,
//       Alignment.bottomCenter,
//       Alignment.bottomRight
//     ];
//     return handles.map(
//       (alignment) => ResizableHandle(
//         size: size,
//         alignment: alignment,
//         onDragStarted: onDragStarted,
//         onDragUpdate: onDragUpdate,
//         onDragEnd: onDragEnd,
//       ),
//     );
//   }
// }
//
// class ResizableHandle extends HookWidget {
//   final double size;
//   final Alignment alignment;
//   final void Function(Alignment handle) onDragStarted;
//   final void Function(Alignment handle, DragUpdateDetails details) onDragUpdate;
//   final void Function(Alignment handle, DraggableDetails details) onDragEnd;
//
//   const ResizableHandle({
//     super.key,
//     required this.size,
//     required this.alignment,
//     required this.onDragStarted,
//     required this.onDragUpdate,
//     required this.onDragEnd,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     final hover = useState(false);
//     final dragging = useState(false);
//     final content = buildContent(hover, dragging);
//
//     return Positioned.fill(
//       child: Align(
//         alignment: alignment,
//         child: Draggable(
//           feedback: Container(),
//           childWhenDragging: content,
//           child: content,
//           onDragStarted: () {
//             dragging.value = true;
//             onDragStarted(alignment);
//           },
//           onDragUpdate: (e) {
//             onDragUpdate(alignment, e);
//           },
//           onDragEnd: (e) {
//             dragging.value = false;
//             onDragEnd(alignment, e);
//           },
//         ),
//       ),
//     );
//   }
//
//   MouseRegion buildContent(
//       ValueNotifier<bool> hover, ValueNotifier<bool> dragging) {
//     return MouseRegion(
//       onEnter: (e) {
//         hover.value = true;
//       },
//       onExit: (e) {
//         hover.value = false;
//       },
//       child: Container(
//         width: size,
//         height: size,
//         decoration: BoxDecoration(
//           border: Border.all(
//             color: Colors.black.withAlpha(30),
//           ),
//           color: (hover.value || dragging.value)
//               ? Colors.black.withAlpha(60)
//               : Colors.black.withAlpha(30),
//           borderRadius: BorderRadius.circular(2),
//         ),
//       ),
//     );
//   }
// }
