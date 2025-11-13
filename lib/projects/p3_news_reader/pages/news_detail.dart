import 'package:flutter/material.dart';

class NewsDetailPage extends StatelessWidget {
  final Map<String, dynamic> article;

  const NewsDetailPage({super.key, required this.article});

  final Color primary = const Color.fromARGB(255, 83, 177, 117);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(article["source"]["name"] ?? "News Detail"),
        backgroundColor: primary,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // IMAGE
            if (article["urlToImage"] != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(article["urlToImage"]),
              ),
            const SizedBox(height: 16),

            // TITLE
            Text(
              article["title"] ?? "",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            // DESCRIPTION
            Text(
              article["description"] ?? "No description available.",
              style: const TextStyle(fontSize: 16),
            ),

            const SizedBox(height: 16),

            Text(
              article["content"] ?? "",
              style: const TextStyle(fontSize: 15),
            ),
          ],
        ),
      ),
    );
  }
}
