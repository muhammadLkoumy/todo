import 'package:flutter/material.dart';

Widget emptyPage() {

  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children:
      [
        Icon(Icons.menu, size: 100, color: Colors.grey.shade300,),
        const SizedBox(height: 15,),
        Text('No tasks!', style: TextStyle(color: Colors.grey.shade500),),
      ],
    ),
  );

}
