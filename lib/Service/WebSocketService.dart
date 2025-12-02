import 'dart:async';
import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketService {
  WebSocketChannel? _channel;
  StreamController<String> _controller = StreamController.broadcast();

  Stream<String> get stream => _controller.stream;

  void connect() {
    _channel = WebSocketChannel.connect(
      Uri.parse("wss://groundable-slumberously-kandis.ngrok-free.dev/ws"),
    );

    _channel!.stream.listen(
          (message) {
        _controller.add(message); // đẩy message cho UI
      },
      onError: (error) {
        print("WebSocket error: $error");
      },
      onDone: () {
        print("WebSocket closed → reconnecting...");
        reconnect();
      },
    );
  }

  void reconnect() {
    Future.delayed(Duration(seconds: 2), () {
      connect();
    });
  }

  void disconnect() {
    _channel?.sink.close();
  }
}