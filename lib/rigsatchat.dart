import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hidden_drawer_menu/controllers/simple_hidden_drawer_controller.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import 'video_player_item.dart';

class RigSatChat extends StatefulWidget {
  const RigSatChat({super.key});

  @override
  State<RigSatChat> createState() => _RigSatChatState();
}

class _RigSatChatState extends State<RigSatChat> {
  final TextEditingController _messageController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DateFormat _dateFormat = DateFormat('MM/dd/yyyy HH:mm');

  Future<String> _fetchDisplayName(String uid) async {
    final userDoc = await _firestore.collection('users').doc(uid).get();
    return userDoc.data()?['displayName'] ?? '';
  }

  void _sendMessage(
      {String? text,
      String? imageUrl,
      String? videoUrl,
      String? mediaType}) async {
    final user = _auth.currentUser;
    if (user == null) {
      print('User is not signed in');
      return;
    }
    await _firestore.collection('messages').add({
      'text': text ?? '',
      'imageUrl': imageUrl,
      'videoUrl': videoUrl,
      'mediaType': mediaType,
      'timestamp': FieldValue.serverTimestamp(),
      'userId': user.uid,
    });
    _messageController.clear();
  }

  Widget _buildMessageContent(DocumentSnapshot message) {
    Map<String, dynamic> messageData =
        message.data() as Map<String, dynamic>? ?? {};

    final String text = messageData['text'] ?? '';
    final String imageUrl = messageData['imageUrl'] ?? '';
    final String videoUrl = messageData['videoUrl'] ?? '';
    final String mediaType = messageData['mediaType'] ?? '';

    if (mediaType == 'image' && imageUrl.isNotEmpty) {
      return Image.network(imageUrl);
    } else if (mediaType == 'video' && videoUrl.isNotEmpty) {
      return VideoPlayerItem(url: videoUrl);
    } else {
      return RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: text,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            // Add more TextSpans for links, images, and videos as needed
          ],
        ),
      );
    }
  }

  Future<String?> _uploadImage(File imageFile) async {
    print('In _uploadImage');
    if (imageFile == null) {
      print('Image file is null');
      return null;
    }
    print('Image file: ${imageFile.path}');
    if (!imageFile.existsSync()) {
      print('Image file does not exist');
      return null;
    }

    final user = _auth.currentUser;
    if (user == null) {
      print('User is not signed in');
      return null;
    }
    final fileName = '${DateTime.now().millisecondsSinceEpoch}_${user.uid}';
    final ref = FirebaseStorage.instance.ref().child('images').child(fileName);
    print('Reference created: ${ref.fullPath}');
    final uploadTask = ref.putFile(imageFile);
    print('Upload task created');
    final snapshot = await uploadTask.whenComplete(() => null);
    print('Upload task completed');

    if (snapshot.state == TaskState.success) {
      print('Upload is successful');
      final imageUrl = await snapshot.ref.getDownloadURL();
      print('Image URL: $imageUrl');
      return imageUrl;
    } else {
      print('File upload failed with state: ${snapshot.state}');
      return null;
    }
  }

  Future<String?> _uploadVideo(File videoFile) async {
    if (videoFile == null) {
      return null;
    }
    final user = _auth.currentUser;
    if (user == null) {
      print('User is not signed in');
      return null;
    }
    final fileName = '${DateTime.now().millisecondsSinceEpoch}_${user.uid}';
    final ref = FirebaseStorage.instance.ref().child('videos').child(fileName);
    final uploadTask = ref.putFile(videoFile);
    final snapshot = await uploadTask;
    if (snapshot.state == TaskState.success) {
      // The file was successfully uploaded.
      final videoUrl = await snapshot.ref.getDownloadURL();
      // Use the videoUrl to send the message
    } else {
      // Handle the upload failure
      print('File upload failed with state: ${snapshot.state}');
    }

    return await snapshot.ref.getDownloadURL();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[1],
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _firestore
                    .collection('messages')
                    .orderBy('timestamp', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: SpinKitFadingGrid(
                        color: Color.fromARGB(255, 27, 2, 191),
                        size: 50.0,
                      ),
                    );
                  }

                  return ListView.builder(
                    reverse: true,
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      final message = snapshot.data!.docs[index];
                      return FutureBuilder<String>(
                        future: _fetchDisplayName(message['userId']),
                        builder: (context, displayNameSnapshot) {
                          if (!displayNameSnapshot.hasData) {
                            return const SpinKitSpinningCircle(
                              color: Colors.blueGrey,
                              size: 50.0,
                            );
                          }

                          final timestamp = message['timestamp'] != null
                              ? (message['timestamp'] as Timestamp).toDate()
                              : DateTime.now();

                          return ListTile(
                            title: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  displayNameSnapshot.data!,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Color.fromARGB(255, 0, 6, 119),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      _buildMessageContent(message),
                                      const SizedBox(height: 4),
                                      Text(
                                        _dateFormat.format(timestamp),
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: const InputDecoration(
                        hintText: 'Type your message',
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: () {
                      _sendMessage(text: _messageController.text);
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.image),
                    onPressed: () async {
                      final picker = ImagePicker();
                      final pickedImage =
                          await picker.pickImage(source: ImageSource.gallery);
                      if (pickedImage != null) {
                        final imageFile = File(pickedImage.path);
                        final imageUrl = await _uploadImage(imageFile);
                        if (imageUrl != null) {
                          _sendMessage(imageUrl: imageUrl, mediaType: 'image');
                        }
                      } else {
                        print('No image selected.');
                      }
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.video_library),
                    onPressed: () async {
                      final picker = ImagePicker();
                      final pickedVideo =
                          await picker.pickVideo(source: ImageSource.gallery);
                      if (pickedVideo != null) {
                        final videoFile = File(pickedVideo.path);
                        final videoUrl = await _uploadVideo(videoFile);
                        if (videoUrl != null) {
                          _sendMessage(videoUrl: videoUrl, mediaType: 'video');
                        }
                      } else {
                        print('No video selected.');
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 48.0),
        child: FloatingActionButton(
          onPressed: () {
            SimpleHiddenDrawerController.of(context).toggle();
          },
          child: const Icon(Icons.menu),
        ),
      ),
    );
  }
}
