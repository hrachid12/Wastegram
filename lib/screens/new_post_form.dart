import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:location/location.dart';
import '../models/post.dart';
import '../widgets/custom_scaffold.dart';

class NewPostForm extends StatefulWidget {
  static final routeName = 'newPostForm';

  NewPostForm({Key key}) : super(key: key);

  @override
  _NewPostForm createState() => _NewPostForm();
}

class _NewPostForm extends State<NewPostForm> {
  final _formKey = GlobalKey<FormState>();
  Post post = Post();

  @override
  Widget build(BuildContext context) {
    final File image = ModalRoute.of(context).settings.arguments;
    Firebase.initializeApp();

    return CustomScaffold(
      fab: false,
      title: 'Wasteagram',
      body: Form(
        key: _formKey,
        child: SafeArea(
          left: true,
          right: true,
          bottom: true,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                child: Semantics(
                  image: true,
                  label: 'Image of wasted food',
                  child: Image.file(image),
                ),
                height: MediaQuery.of(context).size.height * 0.4,
                width: MediaQuery.of(context).size.height * 0.4,
              ),
              Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Semantics(
                    enabled: true,
                    label: 'Quantity of leftover items',
                    hint: 'Quantity of leftover items',
                    child: TextFormField(
                      autofocus: false,
                      decoration: InputDecoration(
                        labelText: 'Number of Leftover Items',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) => validateLeftovers(value),
                      onSaved: (value) {
                        post.quantity = int.parse(value);
                      },
                    ),
                  )),
              Semantics(
                button: true,
                label: 'Posts chosen image to Wasteagram',
                onTapHint: 'Submits post',
                enabled: true,
                child: ElevatedButton(
                  child: Icon(Icons.cloud_upload),
                  onPressed: () {
                    save(context, image);
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  String validateLeftovers(String amount) {
    if (amount.isEmpty) {
      return 'This field cannot be left empty';
    } else if (int.tryParse(amount) == null) {
      return 'Please enter a valid number';
    } else if (int.parse(amount) < 0) {
      return 'Please enter a number greater than 0';
    } else {
      return null;
    }
  }

  void save(BuildContext context, File image) async {
    final formState = _formKey.currentState;

    var locationService = Location();
    var locationData = await locationService.getLocation();

    if (formState.validate()) {
      formState.save();

      post.date = DateTime.now();
      post.imageURL = await getImageURL(image);
      post.latitude = locationData.latitude;
      post.longitude = locationData.longitude;

      FirebaseFirestore.instance.collection('posts').add({
        'imageURL': post.imageURL,
        'quantity': post.quantity,
        'latitude': post.latitude,
        'longitude': post.longitude,
        'date': Timestamp.fromDate(post.date)
      });

      Navigator.of(context).pop();
    }
  }

  Future<String> getImageURL(File image) async {
    final String ref = 'image-from-${DateTime.now()}.png';

    firebase_storage.FirebaseStorage storage =
        firebase_storage.FirebaseStorage.instance;

    firebase_storage.Reference reference = storage.ref().child(ref);
    await reference.putFile(image);

    String downloadURL = await storage.ref().child(ref).getDownloadURL();
    return downloadURL;
  }
}
