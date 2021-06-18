import 'package:flutter/material.dart';
import './screens/posts_screen.dart';
import './screens/new_post_form.dart';
import './screens/open_post.dart';

class App extends StatelessWidget {

  static final routes = {
    PostsScreen.routeName: (context) => PostsScreen(),
    NewPostForm.routeName: (context) => NewPostForm(),
    OpenPost.routeName: (context) => OpenPost(),
  };

  @override build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      routes: routes,
    );
  }
}