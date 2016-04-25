library pure_isolate.lib.remote_isolate;

import 'dart:isolate';
import 'dart:convert';

main(List<String> args, SendPort sender) {

  var remote_receive = new ReceivePort();

  main_sender = sender;
  main_sender.send(remote_receive.sendPort);

  remote_receive.listen((payload) {
    print("received $payload");
    sendOutput(fibonacci(payload));
  });
}

SendPort main_sender;

void sendOutput(int value) {
  main_sender.send(value);
}

int fibonacci(int n) {
//	print("[fibonacci] n = $n");
  if (n == 0) return 0;
  if (n == 1) return 1;
  return fibonacci(n - 1) + fibonacci(n - 2);
}
