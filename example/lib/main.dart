import 'package:flutter/material.dart';
import 'package:clackety/clackety.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MaterialApp(
      title: 'Clackety Example',
      theme: ThemeData.dark().copyWith(
        appBarTheme: const AppBarTheme(color: Colors.pink),
        textTheme: ThemeData.dark().textTheme.copyWith(
            bodyMedium: const TextStyle(color: Colors.white, fontSize: 24)),
      ),
      home: ClacketyExample()));
}

class ClacketyExample extends StatelessWidget {
  final _clacketyController = ClacketyController(value: '');

  ClacketyExample({super.key}) {
    WidgetsBinding.instance.addPostFrameCallback((_) => _startTyping());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.restart_alt),
          onPressed: () {
            _startTyping();
          }),
      // You can put Clackety in any widget, even an App Bar!
      appBar: AppBar(
        title: Clackety.text(
          "Clackety Example",
        ),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.settings))
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(48),
        // This demonstrates a more advanced use case using a controller
        child: Clackety(
            controller: _clacketyController,
            builder: (context, text) => Text(text)),
      ),
    );
  }

  // Example of typing text with a controller
  Future _startTyping() async {
    // You wouldn't use like this, but just for a demo!
    _clacketyController.type(
      'Hello World!',
      onComplete: () async {
        _clacketyController.type("Hello, I'm Clackety!",
            onComplete: _asyncSimulation);
      },
    );
  }

  /// This just simulates updating clackety with progress
  Future _asyncSimulation([int? step]) async {
    final progress = ((step ?? 0) + 1) * 10;

    _clacketyController.type(
        step == null ? 'Progress simulation...' : 'Progress $progress%',
        onComplete:
            progress >= 100 ? _bye : () => _asyncSimulation((step ?? 0) + 1));
  }

  Future _bye() async {
    _clacketyController.type('... Happy clacking!');
  }
}
