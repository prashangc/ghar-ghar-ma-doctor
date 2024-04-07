import 'package:flutter/material.dart';
import 'package:ghargharmadoctor/api/api_imports.dart';
import 'package:ghargharmadoctor/constants/constants_imports.dart';
import 'package:ghargharmadoctor/models/models.dart';
import 'package:ghargharmadoctor/screens/User/side%20navigation/News%20Portal/latestNewsHomepageCard.dart';
import 'package:ghargharmadoctor/widgets/widgets_import.dart';

class IndividualNewsDetails extends StatefulWidget {
  final List<NewsData> newsList;
  final int popCount;
  final NewsData news;
  const IndividualNewsDetails(
      {Key? key,
      required this.news,
      required this.newsList,
      required this.popCount})
      : super(key: key);

  @override
  State<IndividualNewsDetails> createState() => _IndividualNewsDetailsState();
}

class _IndividualNewsDetailsState extends State<IndividualNewsDetails> {
  final List<NewsData> testList = [];
  ScrollController? _scrollController;
  StateHandlerBloc? popCountBloc, backToTopBloc, scrollProgressBloc;
  @override
  void initState() {
    super.initState();
    popCountBloc = StateHandlerBloc();
    backToTopBloc = StateHandlerBloc();
    scrollProgressBloc = StateHandlerBloc();
    // widget.newsList.removeWhere((element) => element.id == widget.news.id);
    _scrollController = ScrollController();
    _scrollController!.addListener(() {
      scrollProgressBloc!.storeData(_scrollController!.offset /
          _scrollController!.position.maxScrollExtent);
      if (_scrollController!.offset >= 600) {
        backToTopBloc!.storeData(true);
      } else {
        backToTopBloc!.storeData(false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<dynamic>(
        initialData: false,
        stream: popCountBloc!.stateStream,
        builder: (context, snapshot) {
          return Scaffold(
              backgroundColor: backgroundColor,
              floatingActionButton: StreamBuilder<dynamic>(
                  initialData: false,
                  stream: backToTopBloc!.stateStream,
                  builder: (context, snapshot) {
                    return snapshot.data == false
                        ? Container()
                        : Padding(
                            padding: const EdgeInsets.only(
                                bottom: 16.0, right: 12.0),
                            child: FloatingActionButton(
                              onPressed: () {
                                _scrollController!.animateTo(0,
                                    curve: Curves.easeInOut,
                                    duration:
                                        const Duration(milliseconds: 500));
                              },
                              backgroundColor: myColor.primaryColorDark,
                              child: const Icon(Icons.arrow_upward),
                            ),
                          );
                  }),
              appBar: myCustomAppBar(
                title: '',
                color: Colors.transparent,
                borderRadius: 12.0,
                isNews: true,
                myTap: () {
                  if (widget.popCount >= 3) {
                    if (snapshot.data == false) {
                      print('print first back');
                      popCountBloc!.storeData(true);
                      Navigator.pop(context);
                    } else {
                      print('print all back');

                      for (int i = 1; i < widget.popCount; i++) {
                        Navigator.pop(context);
                      }
                    }
                  } else {
                    print('print one by one back');

                    Navigator.pop(context);
                  }
                },
              ),
              extendBodyBehindAppBar: true,
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        child: myCachedNetworkImage(
                            maxWidth(context),
                            280.0,
                            widget.news.imagePath.toString(),
                            BorderRadius.zero,
                            BoxFit.cover),
                      ),
                      Positioned(
                        bottom: 40.0,
                        left: 10.0,
                        right: 10.0,
                        child: SizedBox(
                          width: maxWidth(context),
                          child: Text(
                            widget.news.titleEn.toString(),
                            style: kStyleNormal.copyWith(
                              fontSize: 16.0,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 10.0,
                        left: 10.0,
                        right: 10.0,
                        child: SizedBox(
                          width: maxWidth(context),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                widget.news.id.toString(),
                                textAlign: TextAlign.justify,
                                style: kStyleNormal.copyWith(
                                  fontSize: 14.0,
                                  color: kWhite,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(3.0),
                                decoration: BoxDecoration(
                                    color: kWhite,
                                    borderRadius: BorderRadius.circular(4)),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.timer,
                                      color: myColor.primaryColorDark,
                                      size: 12.0,
                                    ),
                                    const SizedBox(
                                      width: 8.0,
                                    ),
                                    Text(
                                      widget.news.createdAt
                                          .toString()
                                          .substring(0, 10),
                                      textAlign: TextAlign.justify,
                                      style: kStyleNormal.copyWith(
                                        fontSize: 12.0,
                                        color: myColor.primaryColorDark,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  StreamBuilder<dynamic>(
                      initialData: 0.0,
                      stream: scrollProgressBloc!.stateStream,
                      builder: (context, snapshot) {
                        return LinearProgressIndicator(
                          value: snapshot.data,
                          backgroundColor: myColor.dialogBackgroundColor,
                          valueColor: AlwaysStoppedAnimation<Color>(
                              myColor.primaryColorDark),
                        );
                      }),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: myColor.dialogBackgroundColor,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12.0, vertical: 12.0),
                        child: SingleChildScrollView(
                          controller: _scrollController,
                          physics: const BouncingScrollPhysics(),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Html(
                              //   onImageTap: (
                              //     img,
                              //     C,
                              //     c,
                              //     v,
                              //   ) {
                              //     goThere(
                              //         context,
                              //         ReportPdfViewer(
                              //           url: img!,
                              //           type: 'img',
                              //         ));
                              //   },
                              //   onLinkTap: (
                              //     url,
                              //     C,
                              //     c,
                              //     v,
                              //   ) {
                              //     goThere(
                              //         context,
                              //         ReportPdfViewer(
                              //           url: url!,
                              //           type: 'pdf',
                              //         ));
                              //   },
                              //   data: '${widget.news.descriptionEn}',
                              //   // customRenders: {
                              //   //   (a) {
                              //   //     return true;
                              //   //   }: CustomRender.widget(widget: (_,[])
                              //   //   => const Text('a'),
                              //   //   ),
                              //   // },
                              //   // {
                              //   // "img": (c, htmlNode) {
                              //   //   // Custom rendering logic for img tag
                              //   //   var srcAttribute =
                              //   //       htmlNode.attributes['src'];
                              //   //   return Image.network(srcAttribute);
                              //   // },
                              //   // },
                              //   style: {
                              //     "*": Style(
                              //       fontSize: FontSize(14.0),
                              //       fontFamily: 'Futura',
                              //       textAlign: TextAlign.justify,
                              //     ),
                              //   },
                              // ),

                              const SizedBox12(),
                              Text(
                                'Related News',
                                style: kStyleNormal.copyWith(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox12(),
                              Container(
                                margin: const EdgeInsets.only(top: 0),
                                child: ListView.builder(
                                  padding: EdgeInsets.zero,
                                  itemCount: widget.newsList.length,
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemBuilder: (ctx, index) {
                                    return latestNewsHomepageCard(
                                        context,
                                        widget.newsList[index],
                                        widget.newsList);
                                    // GestureDetector(
                                    //   onTap: () {
                                    //     widget.newsList.add(widget.news);
                                    //     goThere(
                                    //         context,
                                    //         IndividualNewsDetails(
                                    //           news: widget.newsList[index],
                                    //           newsList: widget.newsList,
                                    //           popCount: widget.popCount + 1,
                                    //         ));
                                    //     widget.newsList.removeAt(index);
                                    //   },
                                    //   child: Container(
                                    //     width: maxWidth(context),
                                    //     height: 100.0,
                                    //     margin:
                                    //         const EdgeInsets.only(bottom: 12.0),
                                    //     padding: const EdgeInsets.all(8.0),
                                    //     decoration: BoxDecoration(
                                    //       color: kWhite.withOpacity(0.4),
                                    //       borderRadius:
                                    //           BorderRadius.circular(12.0),
                                    //     ),
                                    //     child: Row(
                                    //       children: [
                                    //         Expanded(
                                    //           flex: 2,
                                    //           child: Container(
                                    //             decoration: const BoxDecoration(
                                    //               borderRadius:
                                    //                   BorderRadius.all(
                                    //                 Radius.circular(12.0),
                                    //               ),
                                    //             ),
                                    //             margin: const EdgeInsets.only(
                                    //                 right: 10.0),
                                    //             child: myCachedNetworkImage(
                                    //                 maxWidth(context),
                                    //                 maxHeight(context),
                                    //                 widget.newsList[index]
                                    //                     .imagePath
                                    //                     .toString(),
                                    //                 const BorderRadius.all(
                                    //                   Radius.circular(12.0),
                                    //                 ),
                                    //                 BoxFit.cover),
                                    //           ),
                                    //         ),
                                    //         Expanded(
                                    //           flex: 4,
                                    //           child: Container(
                                    //             decoration: const BoxDecoration(
                                    //               borderRadius:
                                    //                   BorderRadius.only(
                                    //                 bottomRight:
                                    //                     Radius.circular(12.0),
                                    //                 topRight:
                                    //                     Radius.circular(12.0),
                                    //               ),
                                    //             ),
                                    //             child: Column(
                                    //               children: [
                                    //                 Expanded(
                                    //                   flex: 2,
                                    //                   child: Container(
                                    //                     margin: const EdgeInsets
                                    //                         .only(right: 10.0),
                                    //                     child: Html(
                                    //                       data: widget
                                    //                           .newsList[index]
                                    //                           .descriptionEn
                                    //                           .toString(),
                                    //                       onCssParseError:
                                    //                           (css, messages) {
                                    //                         print(
                                    //                             "css that errored: $css");
                                    //                         print(
                                    //                             "error messages:");
                                    //                         for (var element
                                    //                             in messages) {
                                    //                           print(element);
                                    //                         }
                                    //                         return null;
                                    //                       },
                                    //                       style: {
                                    //                         "*": Style(
                                    //                           fontSize:
                                    //                               FontSize(
                                    //                                   14.0),
                                    //                           fontFamily:
                                    //                               'Futura',
                                    //                           textAlign:
                                    //                               TextAlign
                                    //                                   .justify,
                                    //                           lineHeight:
                                    //                               const LineHeight(
                                    //                                   1.5),
                                    //                         ),
                                    //                       },
                                    //                     ),
                                    //                   ),
                                    //                 ),
                                    //                 Expanded(
                                    //                   flex: 1,
                                    //                   child: Row(
                                    //                     crossAxisAlignment:
                                    //                         CrossAxisAlignment
                                    //                             .end,
                                    //                     mainAxisAlignment:
                                    //                         MainAxisAlignment
                                    //                             .spaceBetween,
                                    //                     children: [
                                    //                       Text(
                                    //                         widget
                                    //                             .newsList[index]
                                    //                             .user!
                                    //                             .name
                                    //                             .toString(),
                                    //                         textAlign: TextAlign
                                    //                             .justify,
                                    //                         style: kStyleNormal
                                    //                             .copyWith(
                                    //                           fontSize: 12.0,
                                    //                           color: myColor
                                    //                               .primaryColorDark,
                                    //                           fontWeight:
                                    //                               FontWeight
                                    //                                   .bold,
                                    //                         ),
                                    //                       ),
                                    //                       Container(
                                    //                         padding:
                                    //                             const EdgeInsets
                                    //                                 .all(3.0),
                                    //                         decoration: BoxDecoration(
                                    //                             color: myColor
                                    //                                 .dialogBackgroundColor
                                    //                                 .withOpacity(
                                    //                                     0.4),
                                    //                             borderRadius:
                                    //                                 BorderRadius
                                    //                                     .circular(
                                    //                                         4)),
                                    //                         margin:
                                    //                             const EdgeInsets
                                    //                                     .only(
                                    //                                 right:
                                    //                                     10.0),
                                    //                         child: Row(
                                    //                           children: [
                                    //                             Icon(
                                    //                               Icons.timer,
                                    //                               color: myColor
                                    //                                   .primaryColorDark,
                                    //                               size: 12.0,
                                    //                             ),
                                    //                             const SizedBox(
                                    //                               width: 8.0,
                                    //                             ),
                                    //                             Text(
                                    //                               widget
                                    //                                   .newsList[
                                    //                                       index]
                                    //                                   .createdAt
                                    //                                   .toString()
                                    //                                   .substring(
                                    //                                       0,
                                    //                                       10),
                                    //                               textAlign:
                                    //                                   TextAlign
                                    //                                       .justify,
                                    //                               style: kStyleNormal
                                    //                                   .copyWith(
                                    //                                 fontSize:
                                    //                                     12.0,
                                    //                                 color: myColor
                                    //                                     .primaryColorDark,
                                    //                                 fontWeight:
                                    //                                     FontWeight
                                    //                                         .bold,
                                    //                               ),
                                    //                             ),
                                    //                           ],
                                    //                         ),
                                    //                       ),
                                    //                     ],
                                    //                   ),
                                    //                 ),
                                    //               ],
                                    //             ),
                                    //           ),
                                    //         ),
                                    //       ],
                                    //     ),
                                    //   ),
                                    // );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ));
        });
  }
}
