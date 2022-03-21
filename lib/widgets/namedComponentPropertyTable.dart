import 'package:flutter/material.dart';

import '../qrcConnection/resultModels.dart';

class NamedComponentPropertyTable extends StatelessWidget {
  final List<QRCComponentProperty> properties;

  NamedComponentPropertyTable(this.properties);

  @override
  Widget build(BuildContext context) {
    return DataTable(
      columns: const <DataColumn>[
        DataColumn(
          label: Text('Display Name')
        ),
        DataColumn(
          label: Text('Name')
        ),
        DataColumn(
          label: Text('Value')
        )
      ],
      rows: properties.map((e) {
        return DataRow(
          cells: <DataCell>[
            DataCell(Text(e.prettyName)),
            DataCell(Text(e.name)),
            DataCell(Text(e.value)),
          ]
        );
      }).toList(),
    );
  }
}