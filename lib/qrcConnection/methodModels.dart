class QRCCall {
  String jsonrpc = "2.0";
  String method;
  int id;
  dynamic params;

  QRCCall(this.method, {this.id = 0, this.params});

  Map<String, dynamic> toJson() {
    var container = <String, dynamic>{};
    container['jsonrpc'] = jsonrpc;
    container['method'] = method;

    if (id > 0) {
      container['id'] = id;
    }

    if (params != null) {
      container['params'] = params;
    }

    return container;
  }
}

class ComponentGetComponentsCall extends QRCCall {
  ComponentGetComponentsCall(): super("Component.GetComponents");
}

// this RPC call isn't documented by QSC
class ControlSetTranslateCall extends QRCCall {
  ControlSetTranslateCall(): super("Control.SetTranslate", params: false);
}

class StatusGetCall extends QRCCall {
  StatusGetCall(): super("StatusGet");
}

class ComponentGetControlsCall extends QRCCall {
  String componentName;

  ComponentGetControlsCall(this.componentName): super("Component.GetControls", params: <String, String>{"Name": componentName});
}
