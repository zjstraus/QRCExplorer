import 'package:qrcexplorer/qrcConnection/resultModels.dart';
import 'package:qrcexplorer/qsysDiscovery/discovery.dart';

class AppState {
  Map<String, QSYSCore> cores = {};
  Map<String, QRCStatus> coreStatus = {};
  Map<String, List<QRCComponent>> coreNamedComponents = {};
  Map<String, List<String>> _expandedComponents = {};

  String selectedCore = 'Select a discovered Core in the hamburger menu';

  AppState();

  void setCore(QSYSCore core) {
    cores[core.name] = core;
  }

  bool coreUpdateNeeded(QSYSCore core) {
    if (cores.containsKey(core.name)) {
      if (cores[core.name] == core) {
        return false;
      }
    }
    return true;
  }

  void setSelectedCore(String core) {
    selectedCore = core;
  }

  List<coreWithStatus> coreList() {
    var endList = <coreWithStatus>[];
    for (MapEntry e in cores.entries) {
      QRCStatus? status = coreStatus[e.key];
      endList.add(coreWithStatus(e.value, status: status));
    }

    return endList;
  }

  void setCoreStatus(String core, QRCStatus status) {
    coreStatus[core] = status;
  }

  bool coreStatusUpdateNeeded(String core, QRCStatus status) {
    if (coreStatus.containsKey(core)) {
      return coreStatus[core] == status;
    }
    return true;
  }

  bool namedComponentUpdateNeeded(String core, QRCComponent component) {
    if (coreNamedComponents.containsKey(core)) {
      return !coreNamedComponents[core]!.contains(component);
    }
    return true;
  }

  void setNamedComponent(String core, QRCComponent component) {
    if (!coreNamedComponents.containsKey(core)) {
      coreNamedComponents[core] = <QRCComponent>[component];
    } else {
      coreNamedComponents[core]!.removeWhere((element) => element.name == component.name);
      coreNamedComponents[core]!.add(component);
    }
  }

  List<QRCComponent> namedComponents() {
    if (coreNamedComponents.containsKey(selectedCore)) {
      return coreNamedComponents[selectedCore]!;
    }
    return <QRCComponent>[];
  }

  List<String> expandedComponents() {
    if (_expandedComponents.containsKey(selectedCore)) {
      return _expandedComponents[selectedCore]!;
    }
    return <String>[];
  }

  void namedComponentExpansionCallback(int index, bool isExpanded) {
    QRCComponent? component = coreNamedComponents[selectedCore]?.elementAt(index);
    if (component == null) {
      return;
    }

    if (!_expandedComponents.containsKey(selectedCore)) {
      _expandedComponents[selectedCore] = <String>[];
    }

    if (!isExpanded) {
      if (_expandedComponents[selectedCore]!.contains(component.name)) {
        return;
      } else {
        _expandedComponents[selectedCore]!.add(component.name);
      }
    } else {
      _expandedComponents[selectedCore]!.remove(component.name);
    }
  }
}

class coreWithStatus {
  QSYSCore core;
  QRCStatus? status;

  coreWithStatus(this.core, {this.status});
}

