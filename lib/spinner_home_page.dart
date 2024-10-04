import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';

class SpinnerHomePage extends StatefulWidget {
  const SpinnerHomePage({super.key});

  @override
  SpinnerHomePageState createState() => SpinnerHomePageState();
}

class SpinnerHomePageState extends State<SpinnerHomePage> {
  final TextEditingController _controller = TextEditingController();
  List<String> _names = [];
  String? _winner;
  StreamController<int> selected = StreamController<int>();

  @override
  void initState() {
    super.initState();
    _controller.addListener(_updateNamesList);
  }

  @override
  void dispose() {
    _controller.removeListener(_updateNamesList);
    _controller.dispose();
    super.dispose();
  }

  void _updateNamesList() {
    setState(() {
      _names = _controller.text
          .split('\n')
          .where((name) => name.trim().isNotEmpty)
          .toList();
    });
  }

  void _shuffleNames() {
    setState(() {
      _names.shuffle();
    });
  }

  void _resetNames() {
    setState(() {
      _controller.clear();
      _names.clear();
    });
  }

  void _showWinnerDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Winner!'),
          content: Text('The winner is: $_winner'),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  _names.remove(_winner);
                  _controller.text = _names.join('\n');
                });
                Navigator.of(context).pop();
              },
              child: const Text('Remove'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Spinner'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          TextField(
            controller: _controller,
            decoration: const InputDecoration(
              hintText: 'Enter names or values (separated by new line)',
            ),
            keyboardType: TextInputType.multiline,
            maxLines: null,
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: _shuffleNames,
                child: const Text('Shuffle'),
              ),
              ElevatedButton(
                onPressed: _resetNames,
                child: const Text('Reset'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // if(_names.length > 1)
          SizedBox(
            height: 300,
            width: 300,
            child: GestureDetector(
                onTap: () {
                  setState(() {
                    selected.add(
                      Fortune.randomInt(0, _names.length),
                    );
                  });
                },
                child: FortuneWheel(
                  selected: selected.stream,
                  items: (_names.length > 1)
                      ? [
                          for (var it in _names) FortuneItem(child: Text(it)),
                        ]
                      : [
                          const FortuneItem(child: Text("")),
                          const FortuneItem(child: Text("")),
                        ],
                  onFocusItemChanged: (index) {
                    _winner = (_names.length > 1) ? _names[index] : "";
                  },
                  animateFirst: false,
                  // onFling: () {
                  //   debugPrint("Winner");
                  //   debugPrint(_winner);
                  //   if(_names.length > 1) {
                  //     _showWinnerDialog();
                  //   }
                  // },
                  onAnimationEnd: () {
                    debugPrint("Winner");
                    debugPrint(_winner);
                    _showWinnerDialog();
                  },
                )),
          ),
          const SizedBox(height: 16),
          if (_names.isNotEmpty) Text('Current Names: ${_names.join(', ')}'),
        ],
      ),
    );
  }
}