import 'package:client_lpro_app/mqtt/state/MQTTAppState.dart';
import 'package:client_lpro_app/screens/home_screen.dart';

import 'package:client_lpro_app/services/product_service.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ProductService()),
        ChangeNotifierProvider(
          create: (context) => MQTTAppState(),
        )
      ],
      child: MaterialApp(
        title: 'Material App',
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: AppBar(
            title: const Text('Material App Bar'),
          ),
          body: Center(
            child: Container(
              child: const Text('Hello World'),
            ),
          ),
        ),
        initialRoute: 'home',
        routes: {'home': (_) => HomeScreen()},
      ),
    );
  }
}
