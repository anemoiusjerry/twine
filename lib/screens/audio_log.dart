import 'package:flutter/material.dart';

class AudioLogScreen extends StatefulWidget {
  const AudioLogScreen({super.key});

  @override
  State<AudioLogScreen> createState() => _AudioLogScreenState();
}

class _AudioLogScreenState extends State<AudioLogScreen> {
  bool selecting = false;

  @override
  Widget build(BuildContext build) {
    return DefaultTabController(
      length: 2, 
      child: Scaffold(
        body: const Column(
          
        ),
        // multi action buttons
        floatingActionButton: Stack(
          children: [
            Positioned(
              child: FloatingActionButton(
                child: const Icon(Icons.mic),
                onPressed: (){},
              ),
            ),

            // Show delete button if selecting items
            if (selecting)
              Positioned(
                child: FloatingActionButton(
                  child: const Icon(Icons.delete_forever),
                  onPressed: () {}
                ),
              )
          ],
        ),
      ),
    );
  }
}