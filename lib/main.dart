import 'package:flutter/material.dart';
import 'task1.dart';
import 'task2.dart';
import 'task3.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lab 4',
      theme: ThemeData(
      
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.cyanAccent),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Lab 4 App'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  int _tabIndex = 0;
  final List<Widget> _tabs = [
    const Task1(),
    const Task2(),
    const Task3(),
  ];
  
  void _tabChange(int index){
    setState(() {
      _tabIndex = index;
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
        child: _tabs[_tabIndex]
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: _tabChange,
        currentIndex: _tabIndex,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Task 1: ФИО'),
          BottomNavigationBarItem(icon: Icon(Icons.cloud), label: 'Task 2: REST API'),
          BottomNavigationBarItem(icon: Icon(Icons.star), label: 'Task 3: BD'),
          ],
      ),
    );
  }
}
