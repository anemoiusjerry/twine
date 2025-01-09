import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:twine/models/audio_log_model.dart';
import 'package:twine/repositories/audio_log_interface.dart';
import 'package:twine/styles/colours.dart';
import 'package:twine/widgets/wave_bubble.dart';

class AudioLogScreen extends StatefulWidget {
  const AudioLogScreen({
    super.key, 
    required this.partnerName, 
    required this.coupleId,
    required this.group});

  final String partnerName;
  final String coupleId;
  // user ids in couple
  final List<String> group;
  @override
  State<AudioLogScreen> createState() => _AudioLogScreenState();
}

class _AudioLogScreenState extends State<AudioLogScreen> {
  final RecorderController recorderController = RecorderController();
  final AudioLogRepository audioLogsTable = AudioLogRepository(FirebaseFirestore.instance);
  late Reference storageRef;
  String? _pageToken;

  Future<List<String>>? partnerMessages;
  bool selecting = false;
  bool recording = false;

  @override
  initState() {
    super.initState();
    // Trigger allow permissions
    recorderController.checkPermission();
    // use same encoders across platforms
    recorderController.androidEncoder = AndroidEncoder.aac;
    recorderController.androidOutputFormat = AndroidOutputFormat.mpeg4;
    recorderController.iosEncoder = IosEncoder.kAudioFormatMPEG4AAC;
    storageRef = FirebaseStorage.instance.ref().child(widget.coupleId);
    // get partner recording
    final partnerId = widget.group.where((item) => item == FirebaseAuth.instance.currentUser!.uid).first;
    partnerMessages = getAudioLogs(partnerId);
  }

  @override
  void dispose() {
    recorderController.dispose();
    super.dispose();
  }

  Future<List<String>> getAudioLogs(String userId) async {
    final audioFolderRef = storageRef.child("$userId/audioLogs");
    final files = await audioFolderRef.list(ListOptions(maxResults: 20, pageToken: _pageToken));
    print(audioFolderRef.fullPath);
    return [for (var file in files.items) await file.getDownloadURL()];
  }

  void _toggleRecording() async {
    if (recording) {
      recorderController.reset();
      if (recorderController.hasPermission) {
        String? path = await recorderController.stop(false);
        print(path);
        if (path != null) {
          String uid = FirebaseAuth.instance.currentUser!.uid;
          final newAudioLog = AudioLog(
            creationDate: Timestamp.now(),
            name: "",
            favourite: false,
            recordedBy: uid,
          );

          String? docId;
          try {
            // create entry in firestore
            docId = await audioLogsTable.create(newAudioLog);
            // upload to blob storage
            String storagePath = "$uid/audioLogs/$docId.m4a";
            storageRef.child(storagePath).putFile(File(path));
          } catch(e) {
            print(e);
            if (docId != null) {
              await audioLogsTable.delete(docId);
            }
          }
          // add to current list of recordings  
        }
      }
    } else {
      await recorderController.record();
    }
    setState(() {
      recording = !recording;
    });
  }

  void _cancelRecording() async {
    recorderController.reset();
    if (recorderController.hasPermission) {
      String? path = await recorderController.stop(false);
      if (path != null) {
        File(path).delete();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
        body: TabBarView(children: [
          FutureBuilder(future: partnerMessages, builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                print(snapshot.data);
                final width = MediaQuery.of(context).size.width/1.5;
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final audioMessage = snapshot.data![index];
                    return WaveBubble(url: audioMessage, width: width,);
                  }
                );
              }
            }
            return Center(child: Text("Record a Message!"),);
          }),
          Column(children: [],),
        ]),
        // multi action buttons
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            if (recording)
              DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: AppColours.lightGray,
                ),
                child: Row(children: [
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red,),
                    onPressed: _cancelRecording,
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
      );
  }
}