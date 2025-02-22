import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('This is your Profile Page',
          style: Theme.of(context).textTheme.titleLarge),
    );
  }
}
