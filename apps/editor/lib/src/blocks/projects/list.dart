import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:petit_editor/src/theme.dart';

import '../../get_it.dart';
import '../../stores/firestore/project.dart';
import '../stream_list_view.dart';

class ProjectsList extends StatelessWidget {
  final void Function(DocumentReference<ProjectData> ref) onSelect;

  const ProjectsList({
    super.key,
    required this.onSelect,
  });

  FirebaseFirestore get firestore => it.get();

  @override
  Widget build(BuildContext context) {
    final ref = ProjectData.collection().orderBy('name');
    return FirestoreQueryStreamListView(
      stream: ref.snapshots(),
      onSelect: (ref, doc) => onSelect(ref),
      itemBuilder: (ref, doc) {
        return SizedBox(
          height: 44,
          child: Padding(
            padding: AppEdgeInsets.symmetric15x7,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${doc.name ?? 'Untitled'} ${ref.id} ${doc.createdAt.dateTime}',
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
