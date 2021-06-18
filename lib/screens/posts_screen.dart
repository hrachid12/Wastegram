import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import './open_post.dart';
import '../models/post.dart';
import '../widgets/custom_scaffold.dart';

class PostsScreen extends StatefulWidget {
  static final routeName = '/';

  @override
  _PostsScreenState createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {
  bool _initialized = false;
  bool _error = false;

  @override
  void initState() {
    initializeFlutterFire();
    super.initState();
  }

  void initializeFlutterFire() async {
    try {
      // Wait for Firebase to initialize and set `_initialized` state to true
      await Firebase.initializeApp();
      _initialized = true;
      setState(() {});
    } catch (e) {
      // Set `_error` state to true if Firebase initialization fails
      _error = true;
      setState(() {});
    }
  }

  @override
  build(BuildContext context) {
    return CustomScaffold(
      fab: true,
      title: 'Wasteagram',
      body: chooseBody(context),
    );
  }

  Widget chooseBody(BuildContext context) {
    if (_error) {
      return Text('Something went wrong');
    }

    if (!_initialized) {
      return Center(child: CircularProgressIndicator());
    }

    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('posts')
          .orderBy('date', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData &&
            snapshot.data.docs != null &&
            snapshot.data.docs.length > 0) {
          return ListView.builder(
            itemCount: snapshot.data.docs.length,
            itemBuilder: (context, index) {
              return buildListItem(context, snapshot.data.docs[index].data());
            },
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget buildListItem(BuildContext context, postSnapshot) {
    var tempPost = new Post(
      imageURL: postSnapshot['imageURL'],
      date: postSnapshot['date'].toDate(),
      quantity: postSnapshot['quantity'],
      longitude: postSnapshot['longitude'].toDouble(),
      latitude: postSnapshot['latitude'].toDouble(),
    );

    return Semantics(
      child: ListTile(
        title: Text(
          DateFormat('EEEE, MMMM d, yyyy').format(tempPost.date),
          style: TextStyle(fontSize: 28),
        ),
        trailing: Text('${tempPost.quantity}', style: TextStyle(fontSize: 24)),
        onTap: () {
          Navigator.of(context)
              .pushNamed(OpenPost.routeName, arguments: tempPost);
        },
      ),
      enabled: true,
      onTapHint: 'View post',
      label: 'Opens post for full view',
    );
  }
}
