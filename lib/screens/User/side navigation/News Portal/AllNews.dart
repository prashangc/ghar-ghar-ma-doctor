import 'package:flutter/material.dart';
import 'package:ghargharmadoctor/api/api_imports.dart';
import 'package:ghargharmadoctor/constants/constants_imports.dart';
import 'package:ghargharmadoctor/models/models.dart';
import 'package:ghargharmadoctor/screens/User/side%20navigation/News%20Portal/SearchNewsPage.dart';
import 'package:ghargharmadoctor/screens/User/side%20navigation/News%20Portal/latestNewsHomepageCard.dart';
import 'package:ghargharmadoctor/widgets/widgets_import.dart';
import 'package:google_fonts/google_fonts.dart';

class AllNews extends StatefulWidget {
  const AllNews({Key? key}) : super(key: key);

  @override
  State<AllNews> createState() => _AllNewsState();
}

class _AllNewsState extends State<AllNews> with TickerProviderStateMixin {
  ApiHandlerBloc? menuBloc, newsBloc;
  StateHandlerBloc? tabBarViewBloc;
  List<NewsMenuModel> menuModel = [];
  List<Tab> tabs = <Tab>[];
  List<Widget> tabBarView = <Widget>[];
  NewsModel? newsModel;
  int lengthOfAPI = 0;
  TabController? _tabController;
  StateHandlerBloc? navigateToSearchPageBloc;

  @override
  void initState() {
    super.initState();
    menuBloc = ApiHandlerBloc();
    menuBloc!.fetchAPIList(endpoints.getNewsMenuEndpoint);
    tabBarViewBloc = StateHandlerBloc();
    newsBloc = ApiHandlerBloc();
    navigateToSearchPageBloc = StateHandlerBloc();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text(''),
        toolbarHeight: 0.0,
        automaticallyImplyLeading: false,
        backgroundColor: backgroundColor,
        elevation: 0.0,
      ),
      body: SafeArea(
          child: Column(children: [
        myAppBarCard(),
        Expanded(
          child: Container(
            width: maxWidth(context),
            decoration: BoxDecoration(
              color: myColor.dialogBackgroundColor,
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(25),
                topLeft: Radius.circular(25),
              ),
            ),
            child: StreamBuilder<ApiResponse<dynamic>>(
                stream: menuBloc!.apiListStream,
                builder: (c, snapshot) {
                  if (snapshot.hasData) {
                    switch (snapshot.data!.status) {
                      case Status.LOADING:
                        return SizedBox(
                            width: maxWidth(context),
                            height: maxHeight(context) / 3,
                            child: const AnimatedLoading());
                      case Status.COMPLETED:
                        if (snapshot.data!.data.isEmpty) {
                          return Container(
                              height: 140,
                              margin: const EdgeInsets.all(12.0),
                              decoration: BoxDecoration(
                                color: kWhite,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Center(child: Text('No any news')));
                        } else {
                          _tabController = TabController(
                              length: snapshot.data!.data.length,
                              vsync: this,
                              initialIndex: 0);
                          menuModel = List<NewsMenuModel>.from(snapshot
                              .data!.data
                              .map((i) => NewsMenuModel.fromJson(i)));
                          lengthOfAPI = snapshot.data!.data.length;
                          newsBloc!.fetchAPIList(
                              'news?menu_id=${menuModel[0].id.toString()}');
                          tabs.clear();
                          for (int i = 0; i < snapshot.data!.data.length; i++) {
                            tabs.add(
                              Tab(
                                child: Text(
                                  menuModel[i].titleEn.toString(),
                                  style: GoogleFonts.sourceSansPro(
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            );
                          }
                          return DefaultTabController(
                            length: snapshot.data!.data.length,
                            child: Builder(builder: (context) {
                              _tabController!.addListener(() {
                                tabBarViewBloc!
                                    .storeData(_tabController!.index);
                              });
                              return Column(
                                children: [
                                  Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 12.0, vertical: 12.0),
                                    width: maxWidth(context),
                                    decoration: BoxDecoration(
                                      color: backgroundColor.withOpacity(0.8),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: TabBar(
                                          physics:
                                              const BouncingScrollPhysics(),
                                          isScrollable:
                                              snapshot.data!.data.length <= 3
                                                  ? false
                                                  : true,
                                          labelColor: kWhite,
                                          unselectedLabelColor: kBlack,
                                          controller: _tabController,
                                          indicator: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            color: myColor.primaryColorDark,
                                          ),
                                          onTap: (index) {
                                            tabBarViewBloc!.storeData(index);
                                          },
                                          tabs: tabs),
                                    ),
                                  ),
                                  StreamBuilder<dynamic>(
                                      initialData: 0,
                                      stream: tabBarViewBloc!.stateStream,
                                      builder: (ctx, s) {
                                        newsBloc!.fetchAPIList(
                                            'news?menu_id=${menuModel[s.data].id}');
                                        navigateToSearchPageBloc!
                                            .storeData(true);
                                        return StreamBuilder<
                                            ApiResponse<dynamic>>(
                                          stream: newsBloc!.apiListStream,
                                          builder: ((context, snapshot) {
                                            if (snapshot.hasData) {
                                              switch (snapshot.data!.status) {
                                                case Status.LOADING:
                                                  return SizedBox(
                                                      width: maxWidth(context),
                                                      height:
                                                          maxHeight(context) /
                                                              3,
                                                      child:
                                                          const AnimatedLoading());
                                                case Status.COMPLETED:
                                                  if (snapshot
                                                      .data!.data.isEmpty) {
                                                    return Container(
                                                        height: 140,
                                                        margin: const EdgeInsets
                                                                .symmetric(
                                                            vertical: 10.0),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: kWhite,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(12),
                                                        ),
                                                        child: const Center(
                                                            child: Text(
                                                                'No news added')));
                                                  }
                                                  newsModel =
                                                      NewsModel.fromJson(
                                                          snapshot.data!.data);
                                                  tabBarView.clear();
                                                  for (int i = 0;
                                                      i < lengthOfAPI;
                                                      i++) {
                                                    tabBarView.add(
                                                        myTabView(newsModel!));
                                                  }
                                                  return Expanded(
                                                      child: TabBarView(
                                                          physics:
                                                              const BouncingScrollPhysics(),
                                                          controller:
                                                              _tabController,
                                                          children:
                                                              tabBarView));

                                                case Status.ERROR:
                                                  return Container(
                                                    width: maxWidth(context),
                                                    height: 135.0,
                                                    margin: const EdgeInsets
                                                            .symmetric(
                                                        vertical: 10.0),
                                                    decoration: BoxDecoration(
                                                      color: kWhite,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12),
                                                    ),
                                                    child: const Center(
                                                      child:
                                                          Text('Server Error'),
                                                    ),
                                                  );
                                              }
                                            }
                                            return const SizedBox();
                                          }),
                                        );
                                      }),
                                ],
                              );
                            }),
                          );
                        }

                      case Status.ERROR:
                        return Container();
                    }
                  }
                  return const SizedBox();
                }),
          ),
        ),
      ])),
    );
  }

  Widget myAppBarCard() {
    return Container(
      width: maxWidth(context),
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox12(),
          Row(
            children: [
              Container(
                width: 45,
                height: 45,
                decoration: BoxDecoration(
                  color: myColor.scaffoldBackgroundColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(
                    Icons.keyboard_arrow_left_outlined,
                    size: 28.0,
                    color: Colors.grey[400],
                  ),
                ),
              ),
              const SizedBox(width: 8.0),
              Expanded(
                child: StreamBuilder<dynamic>(
                    initialData: false,
                    stream: navigateToSearchPageBloc!.stateStream,
                    builder: (context, mySnapshot) {
                      return GestureDetector(
                        onTap: () {
                          if (mySnapshot.data == true) {
                            goThere(
                                context, SearchNewsPage(menuModel: menuModel));
                          }
                        },
                        child: Container(
                            width: maxWidth(context),
                            decoration: BoxDecoration(
                              color: kWhite,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            height: 45.0,
                            child: Row(
                              children: [
                                const SizedBox(width: 10.0),
                                Icon(
                                  Icons.search,
                                  size: 18,
                                  color: Colors.grey[400],
                                ),
                                const SizedBox(width: 12.0),
                                Expanded(
                                  child: Text(
                                    'Search blogs',
                                    style: kStyleNormal.copyWith(
                                        fontSize: 14.0,
                                        color: Colors.grey[400]),
                                  ),
                                ),
                              ],
                            )),
                      );
                    }),
              ),
              const SizedBox(width: 8.0),
              SizedBox(
                width: 45,
                height: 45,
                child: Image.asset('assets/logo.png'),
              ),
            ],
          ),
          const SizedBox12(),
        ],
      ),
    );
  }

  Widget searchField(context, hintText, textValue,
      {required ValueChanged<String>? onValueChanged}) {
    return SizedBox(
      height: 45,
      child: TextFormField(
        // controller: _myController,
        cursorColor: myColor.primaryColorDark,
        textCapitalization: TextCapitalization.words,
        style: kStyleNormal.copyWith(fontSize: 12.0, color: Colors.grey[400]),
        onChanged: (String value) {
          onValueChanged!(value);
        },
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(horizontal: 8.0),
          filled: true,
          fillColor: kWhite,
          prefixIcon: Icon(
            Icons.search,
            size: 17,
            color: Colors.grey[400],
          ),
          suffixIcon: GestureDetector(
              onTap: () {
                // _myController.clear();
                // setState(() {
                //   _search = '';
                // });
              },
              child: Icon(
                Icons.close,
                size: 18,
                color: Colors.grey[400],
              )),
          enabledBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(
              Radius.circular(8.0),
            ),
            borderSide: BorderSide(color: kWhite, width: 0.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(
              Radius.circular(8.0),
            ),
            borderSide: BorderSide(color: myColor.primaryColorDark, width: 1.5),
          ),
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(8.0),
            ),
          ),
          hintText: hintText,
          hintStyle:
              kStyleNormal.copyWith(fontSize: 12.0, color: Colors.grey[400]),
        ),
        onSaved: (v) {
          textValue = v;
        },
      ),
    );
  }

  Widget filterMenuSheet() {
    return StatefulBuilder(builder: (context, setState) {
      return Container();
    });
  }

  Widget myTabView(NewsModel newsModel) {
    return ListView.builder(
        shrinkWrap: true,
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        // padding: EdgeInsets.zero,
        physics: const BouncingScrollPhysics(),
        itemCount: newsModel.data!.length,
        itemBuilder: (ctx, i) {
          return latestNewsHomepageCard(
              context, newsModel.data![i], newsModel.data!);
        });
  }
}
