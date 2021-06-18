import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import '../models/post.dart';
import '../widgets/custom_scaffold.dart';

class OpenPost extends StatelessWidget {
  static final routeName = 'openPost';

  @override
  Widget build(BuildContext context) {
    final Post post = ModalRoute.of(context).settings.arguments;

    return CustomScaffold(
        fab: false,
        title: 'Wasteagram',
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 10),
              Text(
                DateFormat('EEEE, MMMM d, yyyy').format(post.date),
                style: TextStyle(fontSize: 28),
              ),
              Container(
                child: Semantics(
                  image: true,
                  label: 'Image of wasted food',
                  child: Image.network(post.imageURL),
                ),
                height: MediaQuery.of(context).size.height * 0.4,
                width: MediaQuery.of(context).size.height * 0.4,
              ),
              Text(
                'Items: ${post.quantity}',
                style: TextStyle(fontSize: 24),
              ),
              SizedBox(height: 15),
              Text('(${post.latitude}, ${post.longitude})'),
            ],
          ),
        ));
  }
}
