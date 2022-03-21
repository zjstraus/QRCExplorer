import 'package:flutter/material.dart';
import 'package:qrcexplorer/qrcConnection/resultModels.dart';

import '../models.dart';
import '../qsysDiscovery/discovery.dart';

class CoreEntry extends StatelessWidget {
  final QSYSCore core;
  final QRCStatus? status;
  void Function(String) coreSelectionCallback;

  CoreEntry({Key? key,
    required this.core,
    required this.status,
    required this.coreSelectionCallback
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    IconData statusIcon = Icons.question_mark;

    if (status != null) {
      switch (status!.code) {
        case 0: {
          statusIcon = Icons.check_circle;
        }
        break;

        case 1: {
          statusIcon = Icons.warning;
        }
      }
    }
    return GestureDetector(
      onTap: () {
        coreSelectionCallback(core.name);
      },
      child: ListTile(
        title: Text(core.name),
        subtitle: Text(core.designPretty),
        leading: Icon(statusIcon),
      )
    );
  }
}