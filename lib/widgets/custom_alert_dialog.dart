import 'package:flutter/material.dart';

class CustomAlertDialog extends StatelessWidget {
  final VoidCallback selectImageFromGallery, selectImageFromCamera;

  CustomAlertDialog({
    required this.selectImageFromCamera,
    required this.selectImageFromGallery,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      title: Text(
        'Select image from',
      ),
      content: Container(
        height: 60,
        child: Center(
          child: Row(
            children: [
              Expanded(
                child: TextButton.icon(
                  onPressed: selectImageFromGallery,
                  icon: Icon(Icons.image),
                  label: Text('Gallery'),
                ),
              ),
              Expanded(
                child: TextButton.icon(
                  onPressed: selectImageFromCamera,
                  icon: Icon(Icons.camera),
                  label: Text('Camera'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
