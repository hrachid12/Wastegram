import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../screens/new_post_form.dart';

class CustomScaffold extends StatelessWidget {
  final Widget body;
  final bool fab;
  final String title;

  CustomScaffold({Key key, this.body, this.fab, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: body,
      floatingActionButton: (fab) ? _getFab(context) : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _getFab(BuildContext context) {
    return Semantics(
      child: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          getImage(context);
        },
      ),
      button: true,
      onTapHint: 'Select a photo',
      enabled: true,
      label: 'A button to add a post',
    );
  }

  void getImage(BuildContext context) async {
    final pickedFile =
        await ImagePicker().getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      var image = File(pickedFile.path);
      Navigator.of(context).pushNamed(NewPostForm.routeName, arguments: image);
    }
  }
}
