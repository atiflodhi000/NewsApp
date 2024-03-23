import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:news_headlie/models/catagpries_news_model.dart';
import 'package:news_headlie/models/news_channel_headlines_model.dart';

class NewsRepository {
  Future<NewsChannelHeadlinesModel> fetchnewschannelhlapi(String channelName) async{
    String url = 'https://newsapi.org/v2/top-headlines?sources=$channelName&apiKey=c95e7e2638b54947b913a4c77b45c60e';
    final response = await http.get(Uri.parse(url));
    if(kDebugMode){
      //print(response.body);
    }
    if(response.statusCode==200){
      final body = jsonDecode(response.body);
      return NewsChannelHeadlinesModel.fromJson(body);

    }
    throw Exception('Error');
  }

  Future<CatagpriesNewsModel> fetchCatagoriesNewsapi(String catgory) async{
    String url = 'https://newsapi.org/v2/everything?q=${catgory}&apiKey=c95e7e2638b54947b913a4c77b45c60e';
    final response = await http.get(Uri.parse(url));
    if(kDebugMode){
      //print(response.body);
    }
    if(response.statusCode==200){
      final body = jsonDecode(response.body);
      return CatagpriesNewsModel.fromJson(body);

    }
    throw Exception('Error');
  }
}
