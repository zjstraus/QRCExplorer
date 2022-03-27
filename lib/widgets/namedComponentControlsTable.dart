import 'dart:math';

import 'package:flutter/material.dart';

import '../qrcConnection/resultModels.dart';

class NamedComponentControlTableData extends DataTableSource {
  final List<QRCComponentControl> controls;

  NamedComponentControlTableData(this.controls);

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => controls.length;

  @override
  int get selectedRowCount => 0;

  DataRow getRow(int index) {
    return DataRow(
        cells: <DataCell>[
          DataCell(Text(controls[index].name ?? 'UNKNOWN')),
          DataCell(Text(controls[index].type ?? 'UNKNOWN')),
          DataCell(Text(controls[index].string ?? controls[index].value.toString())),
        ]
    );
  }
}

class NamedComponentControlTable extends StatelessWidget {
  final List<QRCComponentControl> controls;

  NamedComponentControlTable(this.controls);

  @override
  Widget build(BuildContext context) {
      return ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 700),
         child: PaginatedDataTable(
           rowsPerPage: 5,
            header: Text("Controls", style: Theme.of(context).textTheme.headline6),
            source: NamedComponentControlTableData(controls),
            showFirstLastButtons: controls.length > 15,
            columns: const <DataColumn>[
              DataColumn(
                label: Text('Display Name')
              ),
              DataColumn(
                label: Text('Type')
              ),
              DataColumn(
                label: Text('Value')
              )
            ],
          ));
  }
}