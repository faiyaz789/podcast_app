import 'dart:io';
import 'package:http/io_client.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:webfeed/webfeed.dart';

class Helper {
  final client = IOClient(HttpClient()
    ..badCertificateCallback =
        ((X509Certificate cert, String host, int port) => true));

  Future<List<AudioSource>> getData() async {
    List<AudioSource> audioList = [];
    // RSS feed
    var response =
        await client.get(Uri.parse('https://rss.acast.com/unraveled'));
    var channel = RssFeed.parse(response.body);
    int _nextMediaId = 0;
    for (RssItem rssItem in channel.items ?? []) {
      // Only print the titles of the articles: comments do not have a description (subtitle), but articles do
      if (rssItem.description != null) {
        print('Title: ${rssItem.title}');
        print('Link: ${rssItem.link}');
        print('Publish date: ${rssItem.pubDate.toString()}');
        print('media: ${rssItem.enclosure!.url}');
        print('media: ${rssItem.enclosure!.url}');

        // Create a new Medium article from the rssitem

        AudioSource audioSource = AudioSource.uri(
          Uri.parse(rssItem.enclosure!.url ??
              'https://sphinx.acast.com/unraveled/takemywordforit/media.mp3'),
          tag: MediaItem(
            id: '${_nextMediaId++}',
            album: 'Unraveled',
            title: rssItem.title ?? 'Unknown Episode',
            artUri: Uri.parse(
                "https://thumborcdn.acast.com/VLN0GUT-Zc2mLMp6Gbf-7K5colU=/1500x1500/https://mediacdn.acast.com/assets/5ea17537-f11f-4532-8202-294d976b9d5c/-ktbxw6kc-unraveled_generic-podcast_ka-3000x3000.jpg"),
          ),
        );
        // // Add the article to the list
        audioList.add(audioSource);
      }
    }
    return audioList;
  }
}
