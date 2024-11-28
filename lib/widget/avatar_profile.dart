import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../constant.dart';

class AvatarProfile extends StatelessWidget {
  const AvatarProfile({
    super.key,
    required this.url,
    required this.id,
    this.customGesture,
    this.height,
    this.width,
    this.image,
  });
  final String url;
  final String id;
  final VoidCallback? customGesture;
  final double? width;
  final double? height;
  final dynamic image;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: customGesture ??
            () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => SeeDetailImage(
                      url: url,
                      id: id,
                    ),
                  ),
                ),
        child: Container(
          width: width ?? 40,
          height: height ?? 40,
          decoration: BoxDecoration(
            color: Colors.transparent,
            shape: BoxShape.circle,
            border: Border.all(
              color: secondaryColor,
              width: 1,
            ),
          ),
          child: Hero(
            tag: id,
            child: kIsWeb
                ? image != null && image is Uint8List
                    ? CircleAvatar(
                        backgroundImage: MemoryImage(image),
                      )
                    : CircleAvatar(
                        backgroundImage: NetworkImage(url),
                      )
                : image != null && image is File
                    ? CircleAvatar(
                        backgroundImage: FileImage(image!),
                      )
                    : CircleAvatar(
                        backgroundImage: NetworkImage(url),
                      ),
          ),
        ),
      ),
    );
  }
}

class SeeDetailImage extends StatelessWidget {
  const SeeDetailImage({super.key, required this.url, required this.id});
  final String url;
  final String id;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
      ),
      backgroundColor: Colors.transparent,
      body: Center(
        child: Hero(
          tag: id,
          child: Container(
            width: double.infinity,
            height: 500,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(url),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
