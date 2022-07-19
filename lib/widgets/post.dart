import 'package:flutter/material.dart';
import 'package:home_rent/add_page.dart';
import 'package:timeago/timeago.dart' as timeago;

class PostContainer extends StatelessWidget {
  final post;
  final bool owner;

  const PostContainer({
    Key? key,
    required this.post,
    required this.owner,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(
        vertical: 5.0,
        horizontal: 0.0,
      ),
      elevation: 0.0,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        color: Colors.white,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _PostHeader(
                    post: post,
                    owner: owner,
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                      "Room: ${post['room']}\n\nRent: ${post['rent']}\n\nAddress:${post['address']}\n\nContact no:${post['mobile']}\n\n${post['extra_info']}"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PostHeader extends StatelessWidget {
  final post;
  final bool owner;

  const _PostHeader({
    Key? key,
    this.post,
    required this.owner,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // print(post["timestamp"].secoun?ds);
    return Row(
      children: [
        const SizedBox(width: 8.0),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${post['name']}",
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Row(
                children: [
                  Text(
                    '${timeago.format(DateTime.parse(post['timestamp'].toDate().toString()))} • ',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12.0,
                    ),
                  ),
                  Icon(
                    Icons.public,
                    color: Colors.grey[600],
                    size: 12.0,
                  )
                ],
              ),
            ],
          ),
        ),
        if (owner)
          IconButton(
            icon: const Icon(Icons.more_horiz),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddPage(
                  post: post,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
