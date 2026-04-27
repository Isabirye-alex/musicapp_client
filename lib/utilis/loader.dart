// Loading indicator widget
// Displays a centered loading animation with a message
import 'package:flutter/material.dart';

/// A reusable loading widget that displays a circular progress indicator
/// Used to indicate that a request is being processed
class Loader extends StatelessWidget {
  const Loader({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: MediaQuery.of(context).size.height * 0.4,
        width: MediaQuery.of(context).size.width * 0.4,
        decoration: BoxDecoration(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator.adaptive(),
            SizedBox(height: 10),
            Text('Processing Request...'),
          ],
        ),
      ),
    );
  }
}
