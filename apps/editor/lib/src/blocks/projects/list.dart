import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:petit_editor/src/theme.dart';

import '../../get_it.dart';
import '../../stores/firestore/project.dart';
import '../stream_list_view.dart';

class ProjectsList extends StatelessWidget {
  final void Function(DocumentReference<Project> ref) onSelect;

  const ProjectsList({
    super.key,
    required this.onSelect,
  });

  FirebaseFirestore get firestore => it.get();

  @override
  Widget build(BuildContext context) {
    final ref = Project.collection().orderBy('name');
    return StreamListView(
      stream: ref.snapshots(),
      toList: (data) => data.docs,
      onSelect: (item) => onSelect(item.reference),
      itemBuilder: (item) {
        final data = item.data();
        return Padding(
          padding: AppEdgeInsets.symmetric15x7,
          child: Text('${data.name}'),
        );
      },
    );
  }
}
