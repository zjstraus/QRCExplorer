import 'package:flutter/material.dart';
import 'package:qrcexplorer/qrcConnection/resultModels.dart';
import 'package:qrcexplorer/widgets/namedComponentPropertyTable.dart';

class NamedComponentList extends StatelessWidget {
  final List<QRCComponent> components;
  final List<String> expandedComponents;
  void Function(int, bool) expansionCallback;

  NamedComponentList(this.components, this.expandedComponents, this.expansionCallback);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: components.isEmpty
            ? Center(child: Text('No Named Components found on selected Core'))
            : ListView(children: <Widget>[
                ExpansionPanelList(
                  expansionCallback: expansionCallback,
                  children:
                      components.map<ExpansionPanel>((QRCComponent component) {
                    return ExpansionPanel(
                        headerBuilder: (BuildContext context, bool isExpanded) {
                          return ListTile(
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(component.name),
                                Expanded(child:
                                  RichText(
                                    textAlign: TextAlign.right,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    text: TextSpan(
                                      text: component.type,
                                      style: const TextStyle(
                                          fontStyle: FontStyle.italic,
                                      )
                                    )
                                  )
                                )
                              ]
                            )
                          );
                        },
                        body: component.properties.isEmpty
                          ? Center(child: Text('Named Component has no properties'))
                          : NamedComponentPropertyTable(component.properties),
                    isExpanded: expandedComponents.contains(component.name));
                  }).toList(),
                )
              ]));
  }
}
