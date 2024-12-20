import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:audio_waveforms/audio_waveforms.dart';

class AudioLogScreen extends StatefulWidget {
  const AudioLogScreen({super.key});

  @override
  State<AudioLogScreen> createState() => _AudioLogScreenState();
}

class _AudioLogScreenState extends State<AudioLogScreen> {
  final RecorderController recorderController = RecorderController();
  // firebase cloud storage
  final storageRef = FirebaseStorage.instance.ref();
  bool selecting = false;
  bool recording = true;

  @override
  initState() {
    super.initState();
    // Trigger allow permissions
    recorderController.checkPermission();
  }

  @override
  void dispose() {
    recorderController.dispose();
    super.dispose();
  }

  void _toggleRecording() async {
    try {
      if (recording) {
        recorderController.reset();
        if (recorderController.hasPermission) {
          String? path = await recorderController.stop(false);
          if (path != null) {
            // upload to blob storage
            storageRef.child('/');

            print(path);
          }
        }
      } else {
        await recorderController.record();
      }
    } catch(e) {
      print(e);
    } finally {
      setState(() {
        recording = !recording;
      });
    }
  }

  @override
  Widget build(BuildContext build) {
    return DefaultTabController(
      length: 2, 
      child: Scaffold(
        body: const Column(
          
        ),
        // multi action buttons
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            if (recording)
              DecoratedBox(
                
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.amber
                ),
                child: Row(children: [
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: (){},
                  ),
                  AudioWaveforms(
                    enableGesture: true,
                    size: Size(MediaQuery.of(context).size.width/2, 50), 
                    recorderController: recorderController,
                    waveStyle: const WaveStyle(
                      waveColor: Colors.white,
                      extendWaveform: true,
                      showMiddleLine: false,
                    ),
                  ),
                ],)
              ),
    
            // Show delete button if selecting items
            if (selecting)
              FloatingActionButton(
                child: const Icon(Icons.delete_forever),
                onPressed: () {}
              ),
            const SizedBox(width: 20,),  
            Container(
              width: 80,
              height: 80,
              child: FloatingActionButton(
                onPressed: _toggleRecording,
                child: Icon(recording ? Icons.stop : Icons.mic, size: 35,),
              ),
            ),
          ],
        ),
      ),
    );
  }
}