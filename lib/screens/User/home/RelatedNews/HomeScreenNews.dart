import 'package:flutter/material.dart';
import 'package:ghargharmadoctor/models/models.dart';
import 'package:ghargharmadoctor/screens/User/side%20navigation/News%20Portal/latestNewsHomepageCard.dart';

class HomeScreenNews extends StatefulWidget {
  final List<NewsData> newsModel;

  const HomeScreenNews({Key? key, required this.newsModel}) : super(key: key);

  @override
  State<HomeScreenNews> createState() => _HomeScreenNewsState();
}

class _HomeScreenNewsState extends State<HomeScreenNews> {
  int popCount = 0;
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.newsModel.length,
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (ctx, i) {
        return latestNewsHomepageCard(
            context, widget.newsModel[i], widget.newsModel);
      },
    );
  }
}
