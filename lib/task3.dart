import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Task3 extends StatefulWidget {
  const Task3({super.key});

  @override
  State<Task3> createState() => _Task3State();
}

class _Task3State extends State<Task3> {
  double _rating = 0;
  int userCounter = 0;
  final textFieldController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      RatingBar.builder(
        initialRating: 0,
        allowHalfRating: false,
        itemCount: 5,
        itemBuilder: (context, _) =>
            Icon(Icons.star, color: Colors.yellow[600]),
        onRatingUpdate: (rating) {
          setState(() {
            _rating = rating;
          });
        },
      ),
      const SizedBox(height: 15),

      SizedBox(
          width: 250,
          height: 100,
          child: TextField(
            controller: textFieldController,
            textCapitalization: TextCapitalization.sentences,
            autofocus: true,
            maxLines: null,
            expands: true,
            decoration: const InputDecoration(
              hintText: 'Leave your feedback here...',
              border: OutlineInputBorder(),
            )
          )),
      const SizedBox(height: 15),

      ElevatedButton(
        onPressed: () async {
          http.Response response = await sendFeedback(
              _rating.toInt(), textFieldController.text, ++userCounter);
          String message;
          if (response.statusCode == 201) {
            message = 'Feedback sent successfuly';
          } else {
            message = 'API returned error. Code: ${response.statusCode}';
          }
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(message),
              duration: const Duration(seconds: 3),
            ));
          }
        },
        child: const Text('Send'),
      )
    ]));
  }
}

Future<http.Response> sendFeedback(
    int rating, String feedbackText, int userId) {
  return http.post(
    Uri.parse('https://jsonplaceholder.typicode.com/posts'),
    headers: <String, String>{
      'Content-Type': 'application/json;charset=UTF-8',
    },
    body: jsonEncode(<String, dynamic>{
      'title': rating.toString(),
      'body': feedbackText,
      'userId': userId
    }),
  );
}
