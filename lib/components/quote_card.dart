import 'package:flutter/material.dart';

class QuoteCard extends StatelessWidget {
  final String body;
  final String author;
  const QuoteCard({super.key, required this.body, required this.author});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('"$body"',
                style:
                    const TextStyle(fontSize: 18, fontStyle: FontStyle.italic)),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.bottomRight,
              child: Text('- $author',
                  style: const TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}
