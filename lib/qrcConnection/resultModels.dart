class QRCResponse {
  String jsonrpc = "2.0";
  int id = 0;
  String method = "";
  dynamic rawResult = <String, dynamic>{};

  QRCResponse.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('jsonrpc')) {
      jsonrpc = json['jsonrpc'];
    }
    if (json.containsKey('id')) {
      id = json['id'];
    }
    if (json.containsKey('result')) {
      rawResult = json['result'];
    }
  }
}

class QRCStatus {
  int code = -1;
  String string = "UNKNOWN";

  QRCStatus();

  QRCStatus.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('Code')) {
      code = json['Code'];
    }

    if (json.containsKey('String')) {
      string = json['String'];
    }
  }

  bool operator ==(Object other) {
    if (other is QRCStatus) {
      if (other.code != code) {
        return false;
      }
      if (other.string != string) {
        return false;
      }
      return true;
    }
    return false;
  }
}

class NoOpResponse extends QRCResponse {
  NoOpResponse.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    method = "NoOp";
  }
}

class StatusGetResult {
  String platform = "UNKNOWN";
  String state = "UNKNOWN";
  String designName = "UNKNOWN";
  String designCode = "UNKNOWN";
  bool isRedundant = false;
  bool isEmulator = true;
  QRCStatus status = QRCStatus();

  StatusGetResult.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('Platform')) {
      platform = json['Platform'];
    }

    if (json.containsKey('State')) {
      state = json['State'];
    }

    if (json.containsKey('DesignName')) {
      designName = json['DesignName'];
    }

    if (json.containsKey('DesignCode')) {
      designCode = json['DesignCode'];
    }

    if (json.containsKey('IsRedundant')) {
      isRedundant = json['IsRedundant'];
    }

    if (json.containsKey('IsEmulator')) {
      isEmulator = json['IsEmulator'];
    }

    if (json.containsKey('Status')) {
      status = QRCStatus.fromJson(json['Status']);
    }
  }
}

class StatusGetResponse extends QRCResponse {
  StatusGetResult? result;

  StatusGetResponse.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
      method = "StatusGet";
      result = StatusGetResult.fromJson(rawResult);
  }
}

class QRCNamedControl {
  String name = "";
  String string = "";
  dynamic value;

  QRCNamedControl.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('Name')) {
      name = json['Name'];
    }

    if (json.containsKey('String')) {
      string = json['String'];
    }

    if (json.containsKey('Value')) {
      value = json['Value'];
    }
  }
}

class QRCComponentProperty {
  String name = "UNKNOWN";
  String value = "UNSET";
  String prettyName = "UNKNOWN";

  QRCComponentProperty.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('Name')) {
      name = json['Name'];
    }

    if (json.containsKey('Value')) {
      value = json['Value'];
    }

    if (json.containsKey('PrettyName')) {
      prettyName = json['PrettyName'];
    }
  }
}

class QRCComponent {
  List<QRCComponentProperty> properties = <QRCComponentProperty>[];
  String id = "UNKNOWN";
  String name = "UNKOWN";
  String type = "UNKNOWN";

  QRCComponent.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('Name')) {
      name = json['Name'];
    }

    if (json.containsKey('Type')) {
      type = json['Type'];
    }

    if (json.containsKey('ID')) {
      id = json['ID'];
    }

    if (json.containsKey('Properties')) {
      if (json['Properties'] is List) {
        List rawProperties = json['Properties'] as List;
        properties = rawProperties.map((e) => QRCComponentProperty.fromJson(e)).toList();
      }
    }
  }

  @override
  bool operator ==(Object other) {
    if (other is QRCComponent) {
      if (other.name != name) {
        return false;
      }
      if (other.type != type) {
        return false;
      }
      if (other.id != id) {
        return false;
      }
      return true;
    }
    return false;
  }
}

class ComponentGetComponentsResponse extends QRCResponse {
  List<QRCComponent>? result;

  ComponentGetComponentsResponse.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    method = "Component.GetComponents";
    if (rawResult is List) {
      List listResult = rawResult as List;
      result = listResult.map((e) => QRCComponent.fromJson(e)).toList();
    }
  }
}