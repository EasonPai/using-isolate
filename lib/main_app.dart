// Copyright (c) 2016, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.
@HtmlImport('main_app.html')
library pure_isolate.lib.main_app;		

import 'dart:html';

import 'package:polymer/polymer.dart';
import 'package:polymer_elements/paper_input.dart';
import 'package:polymer_elements/paper_button.dart';
import 'package:polymer_elements/paper_spinner.dart';
import 'package:web_components/web_components.dart';
import 'dart:isolate';
import 'dart:async';


@PolymerRegister('main-app')
class MainApp extends PolymerElement {
  @property
  String text;

  MainApp.created() : super.created();

  ready() {

    initIsolate();

    $['isolate_run']
      ..onClick.listen((e){
          output("");
          remote_sender.send(int.parse(text));
        });
    $['local_run']
      ..onClick.listen((e){
        output("");
        output(fibonacci(int.parse(text)));
    });

    outputView = $['output'];

    text = "20";
    set("text", text);
  }


  Element outputView;
  SendPort remote_sender;
  ReceivePort main_receive;
  void initIsolate() {
    main_receive = new ReceivePort();
    main_receive.listen((payload) {
      if (remote_sender == null) {
        remote_sender = payload;
      } else {
        output(payload);
      }
    });

    String workerUri = 'remote_isolate.dart';

    Future<Isolate> remoteIsolate = Isolate.spawnUri(
        Uri.parse(workerUri), [], main_receive.sendPort)
        .catchError((IsolateSpawnException e){
          print("Error in spawning isolate = $e");
    });

  }

  void output(value) {
    outputView.text = "fibonacci(${text}) outputs $value";
  }


  int fibonacci(int n) {
//    print("[fibonacci] n = $n");
    if (n == 0) return 0;
    if (n == 1) return 1;
    return fibonacci(n - 1) + fibonacci(n - 2);
  }

}
