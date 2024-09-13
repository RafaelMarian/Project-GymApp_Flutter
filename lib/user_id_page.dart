import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class UserIdPage extends StatelessWidget {
  final String userId;

  const UserIdPage({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your User ID'),
        backgroundColor: Colors.grey[800],
      ),
      backgroundColor: Colors.grey[800],
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Your User ID:',
                style: TextStyle(fontSize: 18, color: Colors.yellow),
              ),
              const SizedBox(height: 10),
              SelectableText(
                userId,
                style: const TextStyle(fontSize: 24, color: Colors.yellow),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: userId));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('User ID copied to clipboard!')),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.yellow,
                ),
                child: const Text('Copy User ID'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
