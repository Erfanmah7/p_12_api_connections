import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:p_12_api_connections/constants.dart';
import 'package:p_12_api_connections/models/post.dart';
import 'package:p_12_api_connections/widgets/custom_alert_dialog.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class PostScreen extends StatefulWidget {
  final Post post;
  final String type;
  final String token;


  PostScreen({
    required this.post,
    required this.type,
    required this.token,
  });

  @override
  _PostScreenState createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  late Size size;
  late TextEditingController titleController, descriptionController;

  File file = File('-1');
  bool progbol = false;
   late String pastImageUrl = '';
  @override
  void initState() {
    super.initState();
    titleController = TextEditingController();
    descriptionController = TextEditingController();

    if(widget.type == 'Update'){
      titleController.text = widget.post.title;
      descriptionController.text = widget.post.description;
    }

    if(widget.post.imageUrl.length != 0){
      pastImageUrl = widget.post.imageUrl;

  }

  }

  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
    descriptionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${widget.type} Post',
        ),
      ),
      body: ModalProgressHUD(
        inAsyncCall: progbol,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 20,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: size.height * 0.05,
                ),
                Text(
                  'Image',
                ),
                SizedBox(
                  height: size.height * 0.01,
                ),
                Row(
                  children: [
                    InkWell(
                      onTap: () {
                        selectImage();
                      },
                      child: CircleAvatar(
                        radius: 30,
                        child: Icon(
                          (widget.type == 'Add') ? Icons.add : Icons.edit,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    if (widget.type == 'Update')
                      ...[

                        //اگر فایلی انتخاب شد نشون بده
                        Visibility(
                          visible: file.path != '-1',
                          child: Image.file(
                            file,
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                        ),

                        //اگه فایلی انتخاب نشده و فایل api پر بود نمایش بده
                        Visibility(
                          visible: file.path == '-1' && pastImageUrl.length != 0,
                          child: FadeInImage(
                            placeholder: AssetImage('assets/images/default.png'),
                            image: NetworkImage('$kApi/media/$pastImageUrl'),
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                        ),


                      ]
                    else ...[
                      Visibility(
                        visible: file.path != '-1',
                        child: Image.file(
                          file,
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ],
                  ],
                ),
                SizedBox(
                  height: size.height * 0.05,
                ),
                Text(
                  'Title',
                ),
                SizedBox(
                  height: size.height * 0.01,
                ),
                TextField(
                  controller: titleController,
                  decoration: kTextfeild,
                ),
                SizedBox(
                  height: size.height * 0.05,
                ),
                Text(
                  'Description',
                ),
                SizedBox(
                  height: size.height * 0.01,
                ),
                TextField(
                  controller: descriptionController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  minLines: 4,
                  maxLines: 6,
                ),
                SizedBox(
                  height: size.height * 0.05,
                ),
                ElevatedButton(
                  onPressed: () {
                    uploading();
                  },
                  child: Text(
                    '${widget.type}',
                  ),
                ),
                SizedBox(
                  height: size.height * 0.05,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void selectImage() {
    showDialog(
      context: context,
      builder: (context) {
        return CustomAlertDialog(
          selectImageFromGallery: selectImageFromGallery,
          selectImageFromCamera: selectImageFromCamera,
        );
      },
    );
  }

  void selectImageFromGallery() async {
    print('gallery');
    bool status = await selectImagePiker(ImageSource.gallery);
    if (status == true) {
      Navigator.pop(context);
    }
  }

  void selectImageFromCamera() async {
    print('camera');
    bool status = await selectImagePiker(ImageSource.camera);
    if (status == true) {
      Navigator.pop(context);
    }
  }

  Future<bool> selectImagePiker(ImageSource source) async {
    try {
      ImagePicker imagePicker = ImagePicker();
      XFile imagePic =
          await imagePicker.pickImage(source: source) ?? XFile('-1');
      // print('-----------------------');
      // print(imagePic);
      // print(imagePic.path);
      // print(imagePic.name);
      // print('-----------------------');
      if (imagePic.path == '-1') return false;
      setState(() {});
      file = File(imagePic.path);
      return true;
    } catch (e) {
      return false;
    }
  }

  uploading() async {
    setState(() {
      progbol = true;
    });
    Map<String, dynamic> newMap = Map();
    newMap['title'] = titleController.text;
    newMap['description'] = descriptionController.text;

    if (file.path != '-1') {
      newMap['file'] = await MultipartFile.fromFile(file.path,
          filename: file.path.split('/').last);
    }

    FormData formData = FormData.fromMap(newMap);

    Dio dio = Dio();

    if (widget.type == 'Update') {
      //http.response =
      dio
          .put(
        '$kApi/api/post/update/${widget.post.id}/',
        data: formData,
        options: Options(
            headers: {HttpHeaders.authorizationHeader: widget.token},
            method: 'PUT',
            responseType: ResponseType.json),
      )
          .catchError((error) {
        print(error);
      }).then(
        (Response response) {
          print(response.statusCode);
          print(response.data);
          setState(() {
            progbol = false;
          });
        },
      );
    } else {
      //http.response =
      dio
          .post(
        '$kApi/api/post/create/',
        data: formData,
        options: Options(
            headers: {HttpHeaders.authorizationHeader: widget.token},
            method: 'POST',
            responseType: ResponseType.json),
      )
          .catchError((error) {
        print(error);
      }).then(
        (Response response) {
          print(response.statusCode);
          print(response.data);
          resetfiled();
        },
      );
    }
  }

  resetfiled() {
    titleController.text = '';
    descriptionController.text = '';
    file = File('-1');
    setState(() {
      progbol = false;
    });
  }
}
