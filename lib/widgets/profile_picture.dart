import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:twine/helper.dart';


class ProfilePicture extends StatefulWidget {
  const ProfilePicture({
    super.key, 
    this.borderColour = Colors.white, 
    this.backgroundColour = Colors.white,
    this.radius = 100, 
    this.borderWidth = 5,
    required this.storagePath,
    this.imageUrl,
  });

  final double radius;
  final double borderWidth;
  final Color borderColour;
  final Color backgroundColour;
  final String storagePath;
  final String? imageUrl;

  @override
  State<ProfilePicture> createState() => _ProfilePictureState();
}

class _ProfilePictureState extends State<ProfilePicture> {
  final _picker = ImagePicker();
  Uint8List? compressedImage;

  Future<void> _pickImage(BuildContext context, ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(source: source);
      if (pickedFile != null) {
        // compress image to around 200kb standard
        Uint8List? result = await FlutterImageCompress.compressWithFile(
          minWidth: 1000,
          minHeight: 1000,
          quality: 50,
          pickedFile.path,
        );
        setState(() {
          compressedImage = result;
        });
        if (result != null) {
          // upload to firebase storage
          FirebaseStorage.instance.ref(widget.storagePath).putData(result, SettableMetadata(
            contentType: lookupMimeType(pickedFile.path)
          ));
        }
      }
    } on FirebaseException catch(e) {
      print('Error uploading image: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          generateSnackBar("Error, please select another image."));
      }
    } catch (e) {
      print('Error picking image: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          generateSnackBar("Error, please select another image."));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: widget.radius,
      height: widget.radius,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(width: widget.borderWidth, color: widget.borderColour),
        color: widget.backgroundColour
      ),
      child: ClipOval(
        child: GestureDetector(
          onTap: () => _pickImage(context, ImageSource.gallery),
          child: (widget.imageUrl?.isNotEmpty ?? false) ? 
            Image.network(widget.imageUrl!, fit: BoxFit.cover,) : compressedImage != null ? 
            Image.memory(compressedImage!, fit: BoxFit.cover,) :
            Icon(Icons.person, size: 3/4 * widget.radius, color: theme.colorScheme.primary,)
        )
      ),
    );
  }
}