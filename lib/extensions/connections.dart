import 'dart:io'; //InternetAddress utility
import 'dart:async'; //For StreamController/Stream

import 'package:connectivity/connectivity.dart';

class ConnectionStatusSingleton {
    //This creates the single instance by calling the `_internal` constructor specified below
    static final ConnectionStatusSingleton _singleton = new ConnectionStatusSingleton._internal();
    ConnectionStatusSingleton._internal();

    //This is what's used to retrieve the instance through the app
    static ConnectionStatusSingleton getInstance() => _singleton;

    //This tracks the current connection status
    bool hasConnection = false;

    //This is how we'll allow subscribing to connection changes
    StreamController connectionChangeController = new StreamController.broadcast();

    //flutter_connectivity
    final Connectivity _connectivity = Connectivity();

    //Hook into flutter_connectivity's Stream to listen for changes
    //And check the connection status out of the gate
    void initialize() {
        _connectivity.onConnectivityChanged.listen(_connectionChange);
        checkConnection();
    }

    Stream get connectionChange => connectionChangeController.stream;

    //A clean up method to close our StreamController
    //   Because this is meant to exist through the entire application life cycle this isn't
    //   really an issue
    void dispose() {
        connectionChangeController.close();
    }

    //flutter_connectivity's listener
    void _connectionChange(ConnectivityResult result) {
        checkConnection();
    }

    //The test to actually see if there is a connection
    Future<bool> checkConnection() async {
        bool previousConnection = hasConnection;

        try {
            final result = await InternetAddress.lookup('google.com');
            if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
                hasConnection = true;
            } else {
                hasConnection = false;
            }
        } on SocketException catch(_) {
            hasConnection = false;
        }

        //The connection status changed send out an update to all listeners
        if (previousConnection != hasConnection) {
            connectionChangeController.add(hasConnection);
        }

        return hasConnection;
    }
}





class MyConnectivity {
  MyConnectivity._internal();

  static final MyConnectivity _instance = MyConnectivity._internal();

  static MyConnectivity get instance => _instance;

  Connectivity connectivity = Connectivity();

  StreamController controller = StreamController.broadcast();

  Stream get myStream => controller.stream;

  void initialise() async {
    ConnectivityResult result = await connectivity.checkConnectivity();
    _checkStatus(result);
    connectivity.onConnectivityChanged.listen((result) {
      _checkStatus(result);
    });
  }

  void _checkStatus(ConnectivityResult result) async {
    bool isOnline = false;
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        isOnline = true;
      } else
        isOnline = false;
    } on SocketException catch (_) {
      isOnline = false;
    }
    controller.sink.add({result: isOnline});
  }

  void disposeStream() => controller.close();
}