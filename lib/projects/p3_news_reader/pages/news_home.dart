import 'package:flutter/material.dart';
import '../services/news_api.dart';
import 'news_detail.dart';

class NewsHomePage extends StatelessWidget {
  const NewsHomePage({super.key});

  final Color primary = const Color.fromARGB(255, 83, 177, 117);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("News Reader"),
        backgroundColor: primary,
      ),

      body: FutureBuilder(
        future: NewsApiService.fetchNews(),
        builder: (context, snapshot) {
          // LOADING
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // ERROR
          if (snapshot.hasError) {
            return Center(
              child: Text(
                "Error loading news.\n${snapshot.error}",
                textAlign: TextAlign.center,
              ),
            );
          }

          // SUCCESS
          final articles = snapshot.data as List<dynamic>;

          return ListView.builder(
            itemCount: articles.length,
            itemBuilder: (context, index) {
              final article = articles[index];

              return Card(
                margin: const EdgeInsets.all(10),
                child: ListTile(
                  leading: (article["urlToImage"] != null)
                      ? Image.network(
                    article["urlToImage"],
                    width: 80,
                    fit: BoxFit.cover,
                  )
                      : Container(
                    width: 80,
                    color: Colors.grey.shade300,
                    child: const Icon(Icons.image),
                  ),

                  title: Text(article["title"] ?? "No title"),
                  subtitle: Text(article["source"]["name"] ?? ""),

                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => NewsDetailPage(article: article),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
