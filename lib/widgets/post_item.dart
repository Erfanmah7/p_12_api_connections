import 'package:flutter/material.dart';
import 'package:p_12_api_connections/constants.dart';
import 'package:p_12_api_connections/models/post.dart';

class PostItem extends StatelessWidget {
  final Post post;
  final bool showDeleteOption;
  final VoidCallback onDeletePressed;
  final VoidCallback onUpdatePressed;

  PostItem({
    required this.post,
    required this.onDeletePressed,
    required this.onUpdatePressed,
    required this.showDeleteOption,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: onUpdatePressed,
        leading: FadeInImage(
          placeholder: AssetImage('assets/images/default.png'),
          image: showImage(post.imageUrl),
        ),
        title: Text(
          post.title,
        ),
        subtitle: Text(
          post.description,
        ),
        trailing: Visibility(
          visible: showDeleteOption,
          child: IconButton(
            icon: Icon(
              Icons.clear,
            ),
            onPressed: onDeletePressed,
          ),
        ),
      ),
    );
  }

  ImageProvider showImage(String image) {
    if (image.length != 0) {
      return NetworkImage('$kApi/media/$image');
    } //
    else {
      return AssetImage(
        'assets/images/default.png',
      );
    }
  }
}
