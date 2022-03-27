import 'package:flutter/material.dart';
import 'package:qrcexplorer/qrcConnection/resultModels.dart';
import 'package:qrcexplorer/qsysDiscovery/discovery.dart';

class CoreInfoDialog extends StatelessWidget {
  final QSYSCore core;
  final QRCStatus? status;

  CoreInfoDialog(this.core, this.status);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title: Text(core.name),
        content: Container(
            width: double.maxFinite,
            child:
                ListView(padding: const EdgeInsets.all(8), children: <Widget>[
              Column(children: <Widget>[
                ListTile(title: Text("General")),
                GridView(
                    padding: const EdgeInsets.all(4),
                    primary: false,
                    shrinkWrap: true,
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 300,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8,
                            childAspectRatio: 3),
                    children: <Widget>[
                      Container(
                          width: 300,
                          child: ListTile(
                            title: Text("Part Number"),
                            subtitle: Text(core.partNumber),
                          )),
                      Container(
                          width: 300,
                          child: ListTile(
                            title: Text("Design Name"),
                            subtitle: Text(core.designPretty),
                          )),
                      Container(
                          width: 300,
                          child: ListTile(
                            title: Text("Design Code"),
                            subtitle: Text(core.designCode),
                          ))
                    ]),
                Divider(),
                ListTile(title: Text("Status")),
                GridView(padding: const EdgeInsets.all(4),
                    primary: false,
                    shrinkWrap: true,
                    gridDelegate:
                    const SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 300,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                        childAspectRatio: 3),
                    children: <Widget>[
                    Container(
                    width: 300,
                    child: ListTile(
                      title: Text("Code"),
                      subtitle: Text(status?.code.toString() ?? 'Unknown'),
                    )),
                      Container(
                          width: 600,
                          child: ListTile(
                            title: Text("Text"),
                            subtitle: Text(status?.string ?? 'Unknown'),
                          )),
                ]),
                Divider(),
                ListTile(title: Text("Network")),
                GridView(
                    padding: const EdgeInsets.all(4),
                    primary: false,
                    shrinkWrap: true,
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 300,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8,
                            childAspectRatio: 3),
                    children: <Widget>[
                      Container(
                          width: 300,
                          child: ListTile(
                            title: Text("LAN A"),
                            subtitle: Text(core.lanAIP),
                          )),
                      Container(
                          width: 300,
                          child: ListTile(
                            title: Text("LAN B"),
                            subtitle: Text(core.lanBIP),
                          )),
                      Container(
                          width: 300,
                          child: ListTile(
                            title: Text("AUX A"),
                            subtitle: Text(core.auxAIP),
                          )),
                      Container(
                          width: 300,
                          child: ListTile(
                            title: Text("AUX B"),
                            subtitle: Text(core.auxBIP),
                          ))
                    ])
              ]),
            ])),
        actions: <Widget>[
          TextButton(
              onPressed: () => Navigator.pop(context, 'Dismiss'),
              child: const Text('Dismiss'))
        ]);
  }
}
