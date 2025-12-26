

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AddTopicPage extends StatefulWidget {
  const AddTopicPage({super.key});

  @override
  State<AddTopicPage> createState() => _AddTopicPageState();
}

class _AddTopicPageState extends State<AddTopicPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Topic"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Topic *"),
            SizedBox(height: 6.0,),
            TextField(decoration: InputDecoration(border: OutlineInputBorder(), focusedBorder: OutlineInputBorder()),),
            SizedBox(height: 25.0,),
            Text("Studied On"),
            SizedBox(height: 6.0,),
            TextField(decoration: InputDecoration(border: OutlineInputBorder(), focusedBorder: OutlineInputBorder()),),
            SizedBox(height: 25.0,),
            Text("Revision Cycle"),
            Radio(value: "fe", ),
            Radio(value: "fe", ),
            SizedBox(height: 25.0,),
            Text("Tags for you topic"),
            SizedBox(height: 6.0,),
            TextField(decoration: InputDecoration(border: OutlineInputBorder(), focusedBorder: OutlineInputBorder()),),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Expanded(
          child: ElevatedButton(
            onPressed: () => {}, 
            child: Text("Create Topic")
          )
        ),
      ),
    );
  }
}