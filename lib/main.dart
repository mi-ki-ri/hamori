import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_midi/flutter_midi.dart';
import 'package:flutter/foundation.dart';

// 値（ここでは "Hello world"）を格納する「プロバイダ」を作成します。
// プロバイダを使うことで値のモックやオーバーライドが可能になります。
final helloWorldProvider = Provider((_) => 'Hello world');

final _flutterMidi = FlutterMidi();
String _value = './assets/sf/Piano.sf2';

void load(String asset) async {
  print('Loading File...');
  _flutterMidi.unmute();
  ByteData _byte = await rootBundle.load(asset);
  //assets/sf2/SmallTimGM6mb.sf2
  //assets/sf2/Piano.SF2
  _flutterMidi
      .prepare(sf2: _byte, name: "Piano.sf2")
      .then((value) => print("Loaded"));
}

void main() {
  runApp(
    // プロバイダをウィジェットで利用するには、アプリ全体を
    // `ProviderScope` ウィジェットで囲む必要があります。
    // ここに各プロバイダのステート（状態）・値が格納されていきます。
    ProviderScope(
      child: MyApp(),
    ),
  );
}

// flutter_hooks 併用時は hooks_riverpod の HookConsumerWidget を継承します。
class MyApp extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String value = ref.watch(helloWorldProvider);
    load(_value);

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Example')),
        body: Center(
            child: OutlinedButton(
          child: Text("Play"),
          onPressed: () {
            if (kIsWeb) {
              // WebMidi.play(midi);
            } else {
              for (var i = 0; i < 256; i++) {
                _flutterMidi.stopMidiNote(midi: i);
              }

              int midiNum = max((Random().nextInt(255) - 127), 32);
              print(midiNum);
              _flutterMidi.playMidiNote(midi: midiNum);
              _flutterMidi.playMidiNote(midi: midiNum + 4);
              _flutterMidi.playMidiNote(midi: midiNum + 7);
            }
          },
        )),
      ),
    );
  }
}
