import 'package:flutter/material.dart';
import 'package:msm_client/widgets/wifi.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:msm_client/mqtt/MQTTManager.dart';
import 'package:msm_client/mqtt/state/MQTTAppState.dart';
import 'package:msm_client/globals.dart';

class RootView extends StatefulWidget {
  const RootView({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _RootViewState();
  }
}

class _RootViewState extends State<RootView> {
  late MQTTAppState _pubState;
  late MQTTManager _pubManager;
  late MQTTAppState _subState;
  late MQTTManager _subManager;

  @override
  void initState() {
    super.initState();
    _loadTopic();
  }

  _loadTopic() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      Globals.rasp = (prefs.getString('rasp') ?? '');
      Globals.app = (prefs.getString('app') ?? '');
    });

    /// TODO: fix me
    print(Globals.rasp);
    print(Globals.app);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final MQTTAppState appState = Provider.of<MQTTAppState>(context);
    // Keep a reference to the app state.
    _pubState = appState;
    _subState = appState;
    final Scaffold scaffold = Scaffold(
      appBar: AppBar(title: const Text('MSM Client')),
      body: _buildBody());
    return scaffold;
  }

  Widget _buildBody() {
    return Column(
      children: <Widget>[
        _buildSpaceWithImage(3),
        _buildConnectionButtons(2,
            _pubState.getAppConnectionState,
            _subState.getAppConnectionState),
        _buildConnectionStateView(1,
            _prepareStateMessageFrom(
                _pubState.getAppConnectionState,
                _subState.getAppConnectionState)),
        _buildMQTTLogView(7,
            _subState.getHistoryText),
        _buildFunctionButtons(3),
        _buildSpace(2)
      ]
    );
  }

  Widget _buildSpaceWithImage(int f) {
    return Flexible(
      flex: f,
      fit: FlexFit.tight,
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Image.asset('assets/images/kitty.png')
      )
    );
  }

  Widget _buildConnectionButtons(int f,
      MQTTAppConnectionState pubState,
      MQTTAppConnectionState subState) {
    return Flexible(
      flex: f,
      fit: FlexFit.tight,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: <Widget>[
            Expanded(
              child: ElevatedButton(
                onPressed:
                    (Globals.app.isNotEmpty && Globals.rasp.isNotEmpty) && (
                    pubState == MQTTAppConnectionState.disconnected ||
                    subState == MQTTAppConnectionState.disconnected) ?
                    _configureAndConnect :
                    null,
                style: ElevatedButton.styleFrom(
                    primary: Colors.lightBlueAccent
                ),
                child: const Text('Connect')
              )
            ),
            const SizedBox(width: 10),
            Expanded(
              child: ElevatedButton(
                onPressed:
                    pubState == MQTTAppConnectionState.connected &&
                    subState == MQTTAppConnectionState.connected ?
                    _disconnect :
                    null,
                style: ElevatedButton.styleFrom(
                    primary: Colors.redAccent
                ),
                child: const Text('Disconnect')
              )
            )
          ]
        )
      )
    );
  }

  void _configureAndConnect() {
    _pubManager = MQTTManager(
        host: Globals.mqttUrl,
        topic: Globals.rasp,
        identifier: Globals.pub,
        state: _pubState
    );
    _pubManager.initializeMQTTClient();
    _pubManager.connect();
    _subManager = MQTTManager(
        host: Globals.mqttUrl,
        topic: Globals.app,
        identifier: Globals.sub,
        state: _subState
    );
    _subManager.initializeMQTTClient();
    _subManager.connect();
  }

  void _disconnect() {
    _pubManager.disconnect();
    _subManager.disconnect();
  }

  Widget _buildConnectionStateView(int f, String status) {
    return Flexible(
      flex: f,
      fit: FlexFit.tight,
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Container(
          alignment: Alignment.center,
          child: Text('Status: $status', textAlign: TextAlign.center)
        )
      )
    );
  }

  String _prepareStateMessageFrom(MQTTAppConnectionState pubState,
      MQTTAppConnectionState subState) {
    if (pubState == MQTTAppConnectionState.connected &&
        subState == MQTTAppConnectionState.connected) {
      return 'Connected';
    }
    if (pubState == MQTTAppConnectionState.disconnected ||
        subState == MQTTAppConnectionState.disconnected) {
      return 'Disconnected';
    }
    return 'Connecting ...';
  }

  Widget _buildMQTTLogView(int f, String text) {
    return Flexible(
      flex: f,
      fit: FlexFit.tight,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: const Color(0xFFF8BBD0)
          ),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Scrollbar(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                reverse: true,
                child: Text(text)
              )
            )
          )
        )
      )
    );
  }

  Widget _buildFunctionButtons(int f) {
    return Flexible(
      flex: f,
      fit: FlexFit.tight,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: <Widget>[
            Expanded(
              child: ElevatedButton(
                child: const Text('WiFi Setup'),
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const WiFiView())
                  );
                }
              )
            ),
            const SizedBox(width: 10),
            Expanded(
              child: ElevatedButton(
                onPressed: _pubState.getAppConnectionState ==
                    MQTTAppConnectionState.connected ? () {
                      _pubManager.publish('play it');
                } : null,
                child: const Text('Play')
              )
            )
          ]
        )
      )
    );
  }

  Widget _buildSpace(int f) {
    return Flexible(
      flex: f,
      fit: FlexFit.tight,
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Container()
      )
    );
  }
}
