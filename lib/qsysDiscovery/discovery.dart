import 'dart:async';
import 'dart:io';

import 'package:udp/udp.dart';
import 'package:xml/xml.dart';

class QSYSCore {
  String name;
  String partNumber;
  bool isVirtual;
  String lanAIP;
  String lanBIP;
  String auxAIP;
  String auxBIP;
  String webCfgURL;
  String designPretty;
  String designCode;

  String? receivedAddress;

  QSYSCore(this.name, this.partNumber, this.designCode,
      {this.isVirtual = false, this.lanAIP = "", this.lanBIP = "", this.auxAIP = "", this.auxBIP = "", this.webCfgURL = "", this.designPretty = "", this.receivedAddress});

  operator ==(Object other) {
    if (other is QSYSCore) {
      if (other.name != name) {
        return false;
      }

      if (other.partNumber != partNumber) {
        return false;
      }

      if (other.isVirtual != isVirtual) {
        return false;
      }

      if (other.lanAIP != lanAIP) {
        return false;
      }

      if (other.lanBIP != lanBIP) {
        return false;
      }

      if (other.auxAIP != auxAIP) {
        return false;
      }

      if (other.auxBIP != auxBIP) {
        return false;
      }

      if (other.designPretty != designPretty) {
        return false;
      }

      if (other.designCode != designCode) {
        return false;
      }
      return true;
    }
    return false;
  }
}

class xmlDocWithReceivedAddress {
  XmlDocument document;
  String? receivedAddress;

  xmlDocWithReceivedAddress(this.document, this.receivedAddress);
}

xmlDocWithReceivedAddress parseDatagramToXML(Datagram? datagram) {
  var str = '<xml></xml>';
  if (datagram != null) {
    str = String.fromCharCodes(datagram.data);
  }
  return xmlDocWithReceivedAddress(XmlDocument.parse(str), datagram?.address.host);
}

bool hasQDPSubSections(xmlDocWithReceivedAddress? documentWAddress) {
  if (documentWAddress == null) {
    return false;
  }
  final qdp = documentWAddress.document.getElement('QDP');
  if (qdp == null) {
    return false;
  }

  final device = qdp.getElement('device');
  final control = qdp.getElement('control');
  if (device == null || control == null) {
    return false;
  }
  return true;
}

class QsysDiscovery {
  Future<Stream<QSYSCore>> ListenMulticast() async {
    var multicastEndpoint = Endpoint.multicast(
        InternetAddress("224.0.23.175"), port: Port(2467));
    var multicastReceiver = await UDP.bind(multicastEndpoint);
    return multicastReceiver
        .asStream()
        .where((datagram) => datagram != null)
        .map(parseDatagramToXML)
        .where(hasQDPSubSections)
        .map((documentWAddress) {
      final qdp = documentWAddress.document.getElement('QDP');

      final device = qdp!.getElement('device');
      final control = qdp.getElement('control');

      final nameElement = device!.getElement('name');
      final name = nameElement != null ? nameElement.text : 'Unknown Name';

      final partNumberElement = device.getElement('part_number');
      final partNumber = partNumberElement != null
          ? partNumberElement.text
          : '';

      final isVirtualElement = device.getElement('is_virtual');
      final isVirtual = isVirtualElement != null ? isVirtualElement.text ==
          'true' : false;

      final lanAIPElement = device.getElement('lan_a_ip');
      final lanAIP = lanAIPElement != null ? lanAIPElement.text : '';

      final lanBIPElement = device.getElement('lan_b_ip');
      final lanBIP = lanBIPElement != null ? lanBIPElement.text : '';

      final auxAIPElement = device.getElement('aux_a_ip');
      final auxAIP = auxAIPElement != null ? auxAIPElement.text : '';

      final auxBIPElement = device.getElement('aux_b_ip');
      final auxBIP = auxBIPElement != null ? auxBIPElement.text : '';

      final webCfgURLElement = device.getElement('web_cfg_url');
      final webCfgURL = webCfgURLElement != null ? webCfgURLElement.text : '';

      final designPrettyElement = control!.getElement('design_pretty');
      final designPretty = designPrettyElement != null ? designPrettyElement
          .text : '';

      final designCodeElement = control.getElement('design_code');
      final designCode = designCodeElement != null
          ? designCodeElement.text
          : '';

      var parsedCore = QSYSCore(
          name, partNumber, designCode, isVirtual: isVirtual,
          lanAIP: lanAIP,
          lanBIP: lanBIP,
          auxAIP: auxAIP,
          auxBIP: auxBIP,
          webCfgURL: webCfgURL,
          designPretty: designPretty,
          receivedAddress: documentWAddress.receivedAddress);
      return parsedCore;
    }
  );
}}


