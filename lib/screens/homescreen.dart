import 'dart:io';

import 'package:flutter/material.dart';
import 'package:p_12_api_connections/constants.dart';
import 'package:p_12_api_connections/function.dart';
import 'package:p_12_api_connections/models/post.dart';
import 'package:p_12_api_connections/screens/post_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:p_12_api_connections/widgets/post_item.dart';

class HomeScreen extends StatefulWidget {
  late String token;
  late int userId;

  HomeScreen({required this.token, required this.userId});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Posts'),
        actions: [
          IconButton(
            tooltip: 'LogOut',
            onPressed: () async {
              bool flag = await kSignOut();
              if (flag) {
                kNavigat(context, 'login', '-1', -1);
              }
            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          navigate(
            'Add',
            Post(
              imageUrl: '',
              description: '',
              title: '',
              id: -1,
              UploaderId: -1,
            ),
          );
        },
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            return;
          });
        },
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 20,
          ),
          child: FutureBuilder(
            future: loadData(),
            builder: (context, AsyncSnapshot<http.Response> snapshot) {
              if (snapshot.hasData &&
                  snapshot.connectionState == ConnectionState.done) {
                http.Response response =
                    snapshot.data ?? http.Response('', 420);
                // print(response.statusCode);
                print(response.body);
                if (response.statusCode > 300) {
                  return Center(
                    child: Text(response.body),
                  );
                }
                List list = convert.json.decode(response.body);
                return ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (BuildContext context, int index) {
                    Map map = list[index];
                    Post post = Post(
                      title: map['title'],
                      description: map['description'],
                      imageUrl: map['image'],
                      id: map['id'],
                      UploaderId: map['uploader_id'],
                    );
                    if (list.length == 0) {
                      return Center(
                        child: Text('not is found'),
                      );
                    } else {
                      return PostItem(
                          showDeleteOption: map['uploader_id'] == widget.userId,
                          post: post,
                          onDeletePressed: () {
                            deletePost(map['id']);
                          },
                          onUpdatePressed: () {
                            if (post.UploaderId == widget.userId) {
                              navigate('Update', post);
                            }
                          });
                    }
                  },
                );
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        ),
      ),
    );
  }

  Future<http.Response> loadData() async {
    http.Response response = await http.get(
      Uri.parse('$kApi/api/post/all/'),
      headers: {HttpHeaders.authorizationHeader: widget.token},
    );
    return response;
  }

  navigate(String type, Post post) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return PostScreen(
            post: post,
            type: type,
            token: widget.token,
          );
        },
      ),
    );
  }

  deletePost(postId) async {
    http.Response response = await http.delete(
      Uri.parse('$kApi/api/post/delete/$postId/'),
      headers: {
        "Accept": "application/json",
        "content-type": "application/json",
        HttpHeaders.authorizationHeader: widget.token,
      },
    );

    if (response.statusCode < 300) {
      setState(() {});
    }
    print(response.statusCode);
  }
}
