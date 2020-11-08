import 'dart:convert';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter/material.dart';
import 'package:flutter_showdown/providers/global_messages_enums.dart';
import 'package:http/http.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsScreen extends StatefulWidget {
  @override
  _NewsScreenState createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  final _newFuture = get('https://pokemonshowdown.com/news.json');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(8)),
        ),
        title: const Text('News'),
      ),
      body: Container(
        color: ThemeData.light().scaffoldBackgroundColor,
        child: FutureBuilder(
          future: _newFuture,
          builder: (BuildContext context, AsyncSnapshot<Response> snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.data.statusCode == 200) {
                final json = jsonDecode(snapshot.data.body) as List<dynamic>;

                return ListView.builder(
                  itemCount: json.length,
                  itemBuilder: (BuildContext context, int i) {
                    final news = News.fromJson(json[i] as Map<String, dynamic>);
                    final date = DateTime.fromMillisecondsSinceEpoch(
                      news.date * 1000,
                    );

                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            news.title,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Html(
                            data: news.summaryHTML,
                            onLinkTap: (url) async {
                              final uri = Uri.parse(url);

                              if (['http', 'https', 'data', 'about']
                                  .contains(uri.scheme)) {
                                if (await canLaunch(url)) {
                                  await launch(url);
                                }
                              }
                            },
                          ),
                          Row(
                            children: [
                              Text('- ${news.author}'),
                              const Spacer(),
                              Text('${date.day}/${date.month}/${date.year}')
                            ],
                          ),
                          const Divider(),
                        ],
                      ),
                    );
                  },
                );
              }
              return const Center(
                child: Text('Error', style: TextStyle(color: Colors.red)),
              );
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
