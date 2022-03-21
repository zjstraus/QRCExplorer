import 'dart:async';
import 'dart:convert';

import 'package:qrcexplorer/qrcConnection/resultModels.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import 'methodModels.dart';

class QRCEngineStatus {
  String state;
  String designName;
  String designCode;
  bool isRedundant = false;
  bool isEmulator = true;
  String platform = "UNKNOWN";
  int statusCode = -1;
  String statusString = "UNKNOWN";

  QRCEngineStatus(this.state, this.designName, this.designCode);
}

class QRCconnection {
  WebSocketChannel channel;
  int _jsonrpcid = 0;
  Map<int, String> _calledMethods = {};

  void _callJSONRPCWithReturn(QRCCall message) {
    _jsonrpcid += 1;
    message.id = _jsonrpcid;
    _calledMethods[_jsonrpcid] = message.method;
    channel.sink.add(jsonEncode(message));
  }

  void _callJSONRPCWithoutReturn(QRCCall message) {
    message.id = -1;
    channel.sink.add(jsonEncode(message));
  }

  final _onResponse = StreamController<QRCResponse>();
  Stream<QRCResponse> get onResponse => _onResponse.stream;
  bool _onResponseSubscribed = false;
  void _registerOnResponseSubscribe() {
    _onResponseSubscribed = true;
    statusGet();
    controlSetTranslate();
    componentGetComponents();
  }
  void _registerOnResponseCancel() {
    _onResponseSubscribed = false;
  }

  QRCconnection._(this.channel) {
    _onResponse.onListen = _registerOnResponseSubscribe;
    _onResponse.onCancel = _registerOnResponseCancel;
    channel.stream.listen((event) {
      Map<String, dynamic> message = jsonDecode(event.toString());
      if (message.containsKey('method')) {
        return;
      }
      final partialResponse = QRCResponse.fromJson(message);
      QRCResponse result;

      switch (_calledMethods[partialResponse.id]) {
        case 'NoOp': {
          result = NoOpResponse.fromJson(message);
        }
        break;

        case 'StatusGet': {
          result = StatusGetResponse.fromJson(message);
        }
        break;

        case 'Component.GetComponents': {
          result = ComponentGetComponentsResponse.fromJson(message);
        }
        break;

        default: {
          result = partialResponse;
        }
      }
      if (_onResponseSubscribed) {
        _onResponse.add(result);
      };
    });

    const thirtySec = Duration(seconds: 30);
    Timer.periodic(thirtySec, (timer) {
      statusGet();
    });
  }

  factory QRCconnection(String target) {
    WebSocketChannel newChannel = WebSocketChannel.connect(Uri.parse(target));
    return new QRCconnection._(newChannel);
  }

  void componentGetComponents() {
    var request = ComponentGetComponentsCall();
    _callJSONRPCWithReturn(request);
  }

  void controlSetTranslate() {
    var request = ControlSetTranslateCall();
    _callJSONRPCWithoutReturn(request);
  }

  void statusGet() {
    var request = StatusGetCall();
    _callJSONRPCWithReturn(request);
  }
}