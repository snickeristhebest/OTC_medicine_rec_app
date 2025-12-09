import 'package:flutter/material.dart';
import 'pages/landing_page.dart';
import 'pages/home_page.dart';
import 'api-test.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

// initializing firebase with config values for now, will move to env file later...
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    print("Starting Firebase initialization...");
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyCt0rH5UhpTlf1Ji2OCC30mKoke58M-q4k",
        authDomain: "otc-recs.firebaseapp.com",
        projectId: "otc-recs",
        storageBucket: "otc-recs.firebasestorage.app",
        messagingSenderId: "639474301712",
        appId: "1:639474301712:web:7c334677cad7f40c68c395",
        measurementId: "G-91MRJ123HG",
      ),
    );
    print("Firebase initialized: ${Firebase.apps.isNotEmpty}");
  } catch (e, stack) {
    print("Error initializing Firebase: $e");
    print(stack);
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OTC Recs',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/landing',
      routes: {
        '/landing': (context) => const LandingPage(),
        '/home': (context) => const HomePage(),

        //test api
        '/api-test': (context) => ApiTestPage(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  bool _isChecked = false;
  void _onButtonPressed() {
    // Action when button is pressed
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Button pressed!")));
  }

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('You have pushed the button this many times:'),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 20),
            // Checkbox with label
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Checkbox(
                  value: _isChecked,
                  onChanged: (bool? value) {
                    setState(() {
                      _isChecked = value ?? false;
                    });
                  },
                ),
                const Text("Check me!"),
              ],
            ),
            const SizedBox(height: 10),
            // Display the checkbox state
            Text(_isChecked ? "Checked" : "Unchecked"),
            const SizedBox(height: 10),
            // The button
            ElevatedButton(
              onPressed: _isChecked
                  ? _onButtonPressed
                  : null, //enable when chekced
              child: const Text("Button"),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
