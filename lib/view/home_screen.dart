import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:news_headlie/models/news_channel_headlines_model.dart';
import 'package:news_headlie/view/categories_screen.dart';
import 'package:news_headlie/view_model/news_view_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

enum FilterList {bbcNews, aryNews, independent, reuters, cnn, alJazeera}

class _HomeScreenState extends State<HomeScreen> {
  NewsViewModel newsViewModel = NewsViewModel();

  FilterList? selectedMenu;
  
  final format = DateFormat('MMMM dd, yyyy');

  String channelName = 'bbc-news';
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width*1;
    final height = MediaQuery.sizeOf(context).height*1;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=> CategoriesScreen()));
          },
          icon: Image.asset('images/category_icon.png',
          height: 30,
            width: 30
          ),
        ),
        title: Text('HeadLines',style: GoogleFonts.poppins(fontSize: 24,fontWeight: FontWeight.w700),),
        centerTitle: true,
        actions: [
          PopupMenuButton<FilterList>(
            initialValue: selectedMenu,
              icon: Icon(Icons.more_vert,color: Colors.black,),
              onSelected: (FilterList item){
              if(FilterList.bbcNews.name == item.name){
                channelName = 'bbc-news';
              }
              if(FilterList.aryNews.name == item.name){
                channelName = 'ary-news';
              }
              if(FilterList.alJazeera.name == item.name){
                channelName = 'al-jazeera-English';
              }
              setState(() {
                selectedMenu = item;
              });
              },
              itemBuilder: (context) => <PopupMenuEntry<FilterList>> [
                PopupMenuItem<FilterList>(
                  value: FilterList.bbcNews,
                  child: Text('BBC News'),
                ),
                PopupMenuItem<FilterList>(
                  value: FilterList.aryNews,
                  child: Text('ARY News'),
                ),
                PopupMenuItem<FilterList>(
                  value: FilterList.alJazeera,
                  child: Text('alJazeera News'),
                )
              ]
          )
        ],
      ),
      body:ListView(
        children: [
          Container(
            height: height*0.55,
            width: width,
            child: FutureBuilder<NewsChannelHeadlinesModel>(
              future: newsViewModel.fetchnewschannelhlapi(channelName),
              builder: (BuildContext context, snapshot){
                if(snapshot.connectionState == ConnectionState.waiting){
                  return Center(
                    child: SpinKitCircle(
                      size: 50,
                      color: Colors.blue,
                    ),
                  );
                } else{
                  return ListView.builder(
                    itemCount: snapshot.data!.articles!.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context,index){
                      DateTime datetime = DateTime.parse(snapshot.data!.articles![index].publishedAt.toString());
                      return SizedBox(
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                          height: height*0.6,
                          width: width*0.9,
                          padding: EdgeInsets.symmetric(
                              horizontal: height*0.02),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: CachedNetworkImage(
                                  imageUrl: snapshot.data!.articles![index].urlToImage.toString(),
                                  fit: BoxFit.cover,
                                  placeholder: (context,url)=> Container(child: spinkit2,),
                                  errorWidget: (context,url,error)=>Icon(Icons.error_outline,color: Colors.red,),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 20,
                              child: Card(
                                elevation: 5,
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Container(
                                  alignment: Alignment.bottomCenter,
                                  padding: EdgeInsets.all(
                                    15
                                  ),
                                  height: height*0.22,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: width*0.7,
                                        child: Text(snapshot.data!.articles![index].title.toString(),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.poppins(fontWeight: FontWeight.w700,fontSize: 17),
                                        ),
                                      ),
                                      Spacer(),
                                      Container(
                                        width: width*0.7,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(snapshot.data!.articles![index].source!.name.toString(),
                                             // maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: GoogleFonts.poppins(fontWeight: FontWeight.w600,fontSize: 13),
                                            ),
                                            Text(format.format(datetime),
                                             // maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: GoogleFonts.poppins(fontWeight: FontWeight.w500,fontSize: 10),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      );
                    },
                    
                  );
                }
              },
            ),
          )
        ],
      ),
    );
  }

}
const spinkit2 = SpinKitFadingCircle(
  color: Colors.amber,
  size: 50,
);
