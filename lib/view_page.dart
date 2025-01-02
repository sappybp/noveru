import 'package:flutter/material.dart';

class APage extends StatelessWidget {
  const APage({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        color: Colors.black,
        child: Center(
          child: Column(
            children: [
              Text(
                text,
                style: const TextStyle(
                  fontSize: 100,
                  color: Colors.white,
                  ),
              ),
              Flexible(
                child: ListView(
                  padding: const EdgeInsets.all(8),
                  children: <Widget>[
                    Container( // ListTileウィジェットでもOK
                      height: 50,
                      color: Colors.amber[600],
                      child: const Center(child: Text('Entry A')),
                    ),
                    Container(
                      height: 50,
                      color: Colors.amber[500],
                      child: const Center(child: Text('Entry B')),
                    ),
                    Container(
                      height: 50,
                      color: Colors.amber[100],
                      child: const Center(child: Text('Entry C')),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                }, child: const Text('Back'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}