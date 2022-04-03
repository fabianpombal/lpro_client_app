import 'package:client_lpro_app/screens/home_screen.dart';
import 'package:client_lpro_app/services/product_service.dart';
import 'package:client_lpro_app/services/socket_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => SocketService()),
        ChangeNotifierProvider(create: (context) => ProductService())
      ],
      child: MaterialApp(
        title: 'Material App',
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: AppBar(
            title: Text('Material App Bar'),
          ),
          body: Center(
            child: Container(
              child: Text('Hello World'),
            ),
          ),
        ),
        initialRoute: 'home',
        routes: {'home': (_) => HomeScreen()},
      ),
    );
  }
}
