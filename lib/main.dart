import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:qrcexplorer/models.dart';
import 'package:qrcexplorer/qrcConnection/connection.dart';
import 'package:qrcexplorer/qrcConnection/resultModels.dart';
import 'package:qrcexplorer/qsysDiscovery/discovery.dart';
import 'package:qrcexplorer/widgets/corelist.dart';
import 'package:qrcexplorer/widgets/namedComponentList.dart';

import 'models.dart';

Future<void> main() async {
  runApp(QsysApp());
}

class QsysApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return QsysAppState();
  }
}

class QsysAppState extends State<QsysApp> {
  AppState appState = AppState();
  Map<String, QRCconnection> connections = {};


  // Android needs to acquire a lock to enable multicast, so do some platform
  // specific stuff to call into a handler there
  static const platform = MethodChannel('com.github/zjstraus/QRCExplorer/multicast');
  Future<void> _enableMulticast() async {
    try {
      await platform.invokeMethod('enableMulticast');
    } on PlatformException catch (e) {
      // nothing to do if the platform doesn't implement this
    } on MissingPluginException catch (e) {
      // nothing to do if the platform doesn't implement this
    }
  }

  @override
  initState() {
    super.initState();
    subscribeMulticast();
  }

  subscribeMulticast() async {
    await _enableMulticast();
    final discovery = QsysDiscovery();
    final messageStream = await discovery.ListenMulticast();
    messageStream.listen(coreDiscoveryHandler);
  }

  setSelectedCore(String core) {
    setState(() {
      appState.setSelectedCore(core);
    });
  }

  coreStatusUpdateHandler(String core, QRCStatus status) {
    if (appState.coreStatusUpdateNeeded(core, status)) {
      setState(() {
        appState.setCoreStatus(core, status);
      });
    }
  }

  coreNamedControlUpdateHandler(String core, QRCComponent component) {
    if (appState.namedComponentUpdateNeeded(core, component)) {
      setState(() {
        appState.setNamedComponent(core, component);
      });
    }
  }

  namedComponentControlsUpdateHandler(String component, List<QRCComponentControl> controls) {
    setState(() {
      appState.updateNamedControls(component, controls);
    });
  }

  coreDiscoveryHandler(QSYSCore core) {
    if (appState.coreUpdateNeeded(core)) {
      setState(() {
        appState.setCore(core);
      });

      if (core.receivedAddress != null) {
        var connection = QRCconnection("ws://" + core.receivedAddress! + "/qrc");
        connection.onResponse.listen((event) {
          if (event is StatusGetResponse) {
            if (event.result != null) {
              coreStatusUpdateHandler(core.name, event.result!.status);
            }
          }

          if (event is ComponentGetComponentsResponse) {
            if (event.result != null) {
              for (QRCComponent component in event.result!) {
                coreNamedControlUpdateHandler(core.name, component);
              }
            }
          }

          if (event is ComponentGetControlsResponse) {
            if (event.result.isNotEmpty) {
              event.result.forEach((key, value) => namedComponentControlsUpdateHandler(key, value));
            }
          }
        });
        connections[core.name] = connection;
      }
    }
  }

  namedComponentExpansionCallback(int index, bool isExpanded) {
    setState(() {
      appState.namedComponentExpansionCallback(index, isExpanded);
    });
    var component = appState.namedComponentAtIndex(index);
    if (component != null) {
      var connection = connections[appState.selectedCore];
      if (connection != null) {
        connection.componentGetControls(component.name);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QSYS Core Explorer',
      theme: ThemeData.dark(),
      home: Scaffold(
        appBar: AppBar(
          title: Text('QSYS Core Explorer (' + appState.selectedCore + ')'),
        ),
        drawer: Drawer(
            child: CoreList(cores: appState.coreList(), coreSelectionCallback: setSelectedCore,)
        ),
        body: Center(
          // Center is a layout widget. It takes a single child and positions it
          // in the middle of the parent.
          child: NamedComponentList(appState.namedComponents(), appState.expandedComponents(), namedComponentExpansionCallback, appState.controlsOnComponent),
        ), // This trailing comma makes auto-formatting nicer for build methods.
      ),
    );
  }
}
