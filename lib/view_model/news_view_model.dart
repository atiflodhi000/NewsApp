
import 'package:news_headlie/models/catagpries_news_model.dart';
import 'package:news_headlie/models/news_channel_headlines_model.dart';
import 'package:news_headlie/repositry/news_repositry.dart';

class NewsViewModel {
  final _rep = NewsRepository();
  Future<NewsChannelHeadlinesModel> fetchnewschannelhlapi(String channelName ) async{
    final response = await _rep.fetchnewschannelhlapi(channelName);
    return response;
  }
  Future<CatagpriesNewsModel> fetchCatagoriesNewsapi(String catgory ) async{
    final response = await _rep.fetchCatagoriesNewsapi(catgory);
    return response;
  }
}