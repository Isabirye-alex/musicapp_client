import 'package:flutter/material.dart';

class ProfileAvatar extends StatelessWidget {
  final dynamic user;

  const ProfileAvatar({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 50,
      child: Text("${user.firstName[0]}${user.lastName[0]}".toUpperCase()),
    );
  }
}
