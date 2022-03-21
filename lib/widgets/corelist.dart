import 'package:flutter/material.dart';
import 'package:qrcexplorer/models.dart';
import 'package:qrcexplorer/widgets/coreentry.dart';

import '../qsysDiscovery/discovery.dart';

class CoreList extends StatelessWidget {
  final List<coreWithStatus> cores;
  void Function(String) coreSelectionCallback;


  CoreList({
    required this.cores,
    required this.coreSelectionCallback
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: cores.isEmpty
        ? Center(
        child: CircularProgressIndicator()
      )
      : ListView.builder(itemCount: cores.length,
        itemBuilder: (BuildContext context, int index) {
          final core = cores[index];

          if (core != null) {
            return CoreEntry(core: core.core, status: core.status, coreSelectionCallback: coreSelectionCallback,);
          } else {
            return const Text('Error looking up core internally');
          }
        })
    );
  }
}