import 'package:flutter/material.dart';

import 'package:msm_client/mqtt/state/MQTTAppState.dart';
import 'package:msm_client/widgets/root.dart';
import 'package:provider/provider.dart';

void main() => runApp(const MSMApp());

class MSMApp extends StatelessWidget {
  const MSMApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: Colors.blue,
        ),
        home: ChangeNotifierProvider<MQTTAppState>(
          create: (_) => MQTTAppState(),
          child: const RootView()
        )
    );
  }
}
