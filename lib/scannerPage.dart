import 'package:flutter/material.dart';
import 'package:flutter_nfc_reader/flutter_nfc_reader.dart';

class ScannerPage extends StatefulWidget {
  @override
  _ScannerPageState createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage> {
  NfcData nfcData;
  bool isScanning = false;

  @override
  void initState() {
    super.initState();
    startScanner();
  }

  @override
  void dispose() {
    stopScanner();
    super.dispose();
  }

  void startScanner() {
    setState(() => isScanning = true);
    FlutterNfcReader.onTagDiscovered().listen((onData) {
      setState(() {
        nfcData = onData;
      });

      print("id: ${onData.id}");
      print("content: ${onData.content}");


    });
  }

  void stopScanner() {
    setState(() {
      nfcData = null;
      isScanning = false;
    });

    FlutterNfcReader.stop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("NFC Scanner")),
      floatingActionButton: fab,
      body: Container(
        padding: EdgeInsets.all(20),
        alignment: Alignment.center,
        child: nfcData == null ? nfcDataNull : dataList,
      ),
    );
  }

  get nfcDataNull {
    if (!isScanning) {
      return Container(
        width: 100,
        height: 100,
        child: CircleAvatar(
          backgroundColor: Colors.blue,
          child: Icon(
            Icons.nfc,
            color: Colors.white.withOpacity(0.2),
            size: 50,
          ),
        ),
      );
    }

    return Container(
      width: 100,
      height: 100,
      child: CircleAvatar(
        backgroundColor: Colors.blue,
        child: Icon(
          Icons.nfc,
          color: Colors.white,
          size: 50,
        ),
      ),
    );
  }

  get dataList => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          buildContent(
            "Id",
            nfcData.id,
            icon: Icon(Icons.perm_device_information),
          ),
          buildContent(
            "Content",
            nfcData.content,
            icon: Icon(Icons.content_paste),
          ),
          buildContent(
            "Status Mapper",
            nfcData.statusMapper,
            icon: Icon(Icons.settings),
          ),
        ],
      );

  buildContent(String title, String subtitle, {Icon icon}) {
    return ListTile(
      leading: icon,
      title: Text(title),
      subtitle: Text(subtitle),
    );
  }

  get fab {
    if (isScanning) {
      return FloatingActionButton(
        backgroundColor: Colors.red,
        onPressed: () => stopScanner(),
        child: Icon(Icons.power_settings_new),
      );
    }

    return FloatingActionButton(
      onPressed: () => startScanner(),
      child: Icon(Icons.power_settings_new),
    );
  }
}
