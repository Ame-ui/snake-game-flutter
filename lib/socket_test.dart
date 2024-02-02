import 'package:cube/ybs/util/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_super_scaffold/flutter_super_scaffold.dart';
import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart';

class SocketTest extends StatefulWidget {
  const SocketTest({super.key});

  @override
  State<SocketTest> createState() => _SocketTestState();
}

class _SocketTestState extends State<SocketTest> {
  TextEditingController socketUrlText = TextEditingController();
  TextEditingController dataText = TextEditingController();
  TextEditingController event = TextEditingController();

  SocketServices socketServices = SocketServices();
  String socketReturn = 'No Data';
  @override
  void dispose() {
    socketUrlText.dispose();
    dataText.dispose();
    event.dispose();
    socketServices.disposeSocket();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(
            controller: socketUrlText,
            decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                filled: true,
                hintText: 'Socket url',
                fillColor: Colors.grey.withOpacity(0.3)),
          ),
          ElevatedButton(
            onPressed: () {
              try {
                socketServices.socket.disconnect();
              } catch (e) {}
              socketServices.initSocket(socketUrlText.text);
            },
            child: const Text(
              'Join',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          100.heightBox(),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: event,
                  decoration: InputDecoration(
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 20),
                      filled: true,
                      hintText: 'Event',
                      fillColor: Colors.grey.withOpacity(0.3)),
                ),
              ),
              10.widthBox(),
              Expanded(
                child: TextField(
                  controller: dataText,
                  decoration: InputDecoration(
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 20),
                      filled: true,
                      hintText: 'Data',
                      fillColor: Colors.grey.withOpacity(0.3)),
                ),
              ),
            ],
          ),
          ElevatedButton(
            onPressed: () {
              socketServices.socket.emitWithAck(event.text, dataText.text,
                  ack: (data) {
                setState(() {
                  socketReturn = data.toString();
                });
              });
            },
            child: const Text(
              'Send',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          100.heightBox(),
          Container(
            width: Get.width,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            color: Colors.grey.withOpacity(0.1),
            child: Text(
              socketReturn,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SocketServices {
  late Socket socket;

  void initSocket(String socketEndPoint) {
    socket = io(socketEndPoint,
        OptionBuilder().setTransports(['websocket']).enableForceNew().build());
    socket.connect();
    socket.onConnectError(
        (data) => superPrint(data, title: 'Socket Connect Error'));
    socket.on('connect', (data) => superPrint('SOCKET CONNECTED'));
    socket.on('disconnect', (data) => superPrint('SOCKET DISCONNECTED'));
  }

  void disposeSocket() {
    socket.disconnect();
    socket.dispose();
  }
}
