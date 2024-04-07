import 'package:flutter/material.dart';
import 'package:ghargharmadoctor/api/api_imports.dart';
import 'package:ghargharmadoctor/constants/constants_imports.dart';
import 'package:ghargharmadoctor/models/DropDownModel/GetIDName.dart';
import 'package:ghargharmadoctor/models/models.dart';
import 'package:ghargharmadoctor/screens/User/side%20navigation/News%20Portal/IndividualNewsDetails.dart';
import 'package:ghargharmadoctor/widgets/widgets_import.dart';

class SearchNewsPage extends StatefulWidget {
  final List<NewsMenuModel> menuModel;
  const SearchNewsPage({super.key, required this.menuModel});

  @override
  State<SearchNewsPage> createState() => _SearchNewsPageState();
}

class _SearchNewsPageState extends State<SearchNewsPage> {
  StateHandlerBloc? selectedBloc, refreshBloc;
  ApiHandlerBloc? newsBloc;
  NewsModel? newsModel;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  GetIDNameModel? getIDNameModel;
  @override
  void initState() {
    super.initState();
    newsBloc = ApiHandlerBloc();
    newsBloc!.fetchAPIList('news');
    selectedBloc = StateHandlerBloc();
    refreshBloc = StateHandlerBloc();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        myfocusRemover(context);
      },
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: backgroundColor,
        endDrawer: filterDrawer(),
        appBar: AppBar(
          title: const Text(''),
          toolbarHeight: 0.0,
          automaticallyImplyLeading: false,
          backgroundColor: backgroundColor,
          elevation: 0.0,
        ),
        body: Column(
          children: [
            myAppBarCard(),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: _newsWidget(context),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget myAppBarCard() {
    return Container(
      width: maxWidth(context),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: const BorderRadius.only(
          bottomRight: Radius.circular(20),
          bottomLeft: Radius.circular(20),
        ),
      ),
      child: Padding(
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
                    child: searchField(context, 'Search blogs', '_search',
                        onValueChanged: (v) {
                  setState(() {
                    newsBloc!.fetchAPIList('news?search=$v');
                  });
                })),
                const SizedBox(width: 8.0),
                SizedBox(
                  width: 45,
                  height: 45,
                  child: GestureDetector(
                    onTap: () {
                      _scaffoldKey.currentState!.openEndDrawer();
                    },
                    child: Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: myColor.primaryColorDark,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.sort,
                        color: myColor.scaffoldBackgroundColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
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

  Widget _newsWidget(context) {
    return StreamBuilder<dynamic>(
        initialData: false,
        stream: refreshBloc!.stateStream,
        builder: (context, snapshot) {
          if (snapshot.data != false) {}
          return StreamBuilder<ApiResponse<dynamic>>(
            stream: newsBloc!.apiListStream,
            builder: ((context, snapshot) {
              if (snapshot.hasData) {
                switch (snapshot.data!.status) {
                  case Status.LOADING:
                    return Container(
                      width: maxWidth(context),
                      height: maxHeight(context) / 2,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const AnimatedLoading(),
                    );
                  case Status.COMPLETED:
                    newsModel = NewsModel.fromJson(snapshot.data!.data);
                    if (newsModel!.data!.isEmpty) {
                      return Container(
                          height: 140,
                          margin: const EdgeInsets.symmetric(vertical: 10.0),
                          decoration: BoxDecoration(
                            color: kWhite,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Center(child: Text('No news added')));
                    }
                    return Padding(
                        padding: const EdgeInsets.only(top: 15.0),
                        child: ListView.builder(
                            shrinkWrap: true,
                            padding: EdgeInsets.zero,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: newsModel!.data!.length,
                            itemBuilder: (ctx, i) {
                              return newsCard(newsModel!.data![i]);
                            }));

                  case Status.ERROR:
                    return Container(
                      margin: const EdgeInsets.only(top: 20.0),
                      width: maxWidth(context),
                      height: 135.0,
                      decoration: BoxDecoration(
                          color: kWhite,
                          borderRadius: BorderRadius.circular(12.0)),
                      child: const Center(
                        child: Text('Server Error'),
                      ),
                    );
                }
              }
              return const SizedBox();
            }),
          );
        });
  }

  Widget newsCard(NewsData data) {
    return GestureDetector(
      onTap: () {
        goThere(
            context,
            IndividualNewsDetails(
              popCount: 1,
              news: data,
              newsList: newsModel!.data!,
            ));
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12.0),
        width: maxWidth(context),
        height: 200.0,
        decoration: BoxDecoration(
          color: kWhite,
          borderRadius: const BorderRadius.all(
            Radius.circular(12.0),
          ),
        ),
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                color: kWhite,
                borderRadius: const BorderRadius.all(
                  Radius.circular(12.0),
                ),
              ),
              child: myCachedNetworkImage(
                maxWidth(context),
                maxHeight(context),
                data.imagePath.toString(),
                const BorderRadius.all(
                  Radius.circular(12.0),
                ),
                BoxFit.cover,
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(
                    vertical: 12.0, horizontal: 12.0),
                decoration: BoxDecoration(
                    color: myColor.dialogBackgroundColor.withOpacity(0.6),
                    // color: kBlack.withOpacity(0.8),
                    borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(12.0),
                        bottomRight: Radius.circular(12.0))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data.titleEn.toString(),
                      style: kStyleNormal.copyWith(
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox2(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.visibility, size: 14.0),
                            const SizedBox(width: 8.0),
                            Text(
                              data.views.toString(),
                              style: kStyleNormal.copyWith(
                                fontSize: 12.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              'View Blog',
                              style: kStyleNormal.copyWith(
                                fontSize: 12.0,
                                color: myColor.primaryColorDark,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 5.0),
                            Icon(Icons.keyboard_arrow_right_outlined,
                                color: myColor.primaryColorDark, size: 14.0),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget filterDrawer() {
    return GestureDetector(
      onTap: () {
        myfocusRemover(context);
      },
      child: Container(
        color: myColor.dialogBackgroundColor,
        width: maxWidth(context) / 1.3,
        height: maxHeight(context),
        child: StatefulBuilder(builder: (context, s) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Column(
              children: [
                Container(
                  color: myColor.dialogBackgroundColor,
                  width: maxWidth(context),
                  height: 130.0,
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text.rich(
                        TextSpan(
                          text: 'Filter\n',
                          style: kStyleNormal.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0,
                          ),
                          children: <InlineSpan>[
                            TextSpan(
                              text: 'Blogs',
                              style: kStyleNormal.copyWith(
                                fontSize: 22.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      CircleAvatar(
                        backgroundColor: kWhite.withOpacity(0.4),
                        radius: 14.0,
                        child: Icon(Icons.sort,
                            size: 15.0, color: myColor.primaryColorDark),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      StreamBuilder<dynamic>(
                          initialData: getIDNameModel,
                          stream: selectedBloc!.stateStream,
                          builder: (context, snapshot) {
                            if (snapshot.data == null) {
                              return ListView.builder(
                                  shrinkWrap: true,
                                  padding: EdgeInsets.zero,
                                  itemCount: widget.menuModel.length,
                                  itemBuilder: (myContext, myIndex) {
                                    return myExpansionTile(
                                        widget.menuModel[myIndex], myIndex);
                                  });
                            } else {
                              return Container(
                                width: maxWidth(context),
                                decoration: BoxDecoration(
                                  color: kWhite.withOpacity(0.4),
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(8.0),
                                  ),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0, vertical: 20.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget
                                          .menuModel[int.parse(
                                              snapshot.data.id.toString())]
                                          .titleEn
                                          .toString(),
                                      style: kStyleNormal.copyWith(
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox12(),
                                    GestureDetector(
                                      onTap: () {
                                        selectedBloc!.storeData(null);
                                      },
                                      child: Stack(
                                        clipBehavior: Clip.none,
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(6.0),
                                              border: Border.all(
                                                color: myColor
                                                    .dialogBackgroundColor,
                                              ),
                                              color: kWhite.withOpacity(0.4),
                                            ),
                                            padding: const EdgeInsets.fromLTRB(
                                                12.0, 8.0, 25.0, 8.0),
                                            child: Text(
                                              snapshot.data.name.toString(),
                                              style: kStyleNormal.copyWith(
                                                fontSize: 12.0,
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            top: 10,
                                            right: 8.0,
                                            child: Icon(
                                              Icons.close,
                                              size: 14.0,
                                              color: myColor.primaryColorDark
                                                  .withOpacity(0.4),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }
                          }),
                    ],
                  ),
                ),
                const SizedBox12(),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget myExpansionTile(NewsMenuModel data, i) {
    return Column(
      children: [
        Theme(
          data: Theme.of(context).copyWith(
            unselectedWidgetColor: Colors.black,
            primaryColor: Colors.black,
            dividerColor: Colors.transparent,
          ),
          child: Container(
            margin: const EdgeInsets.only(bottom: 12.0),
            decoration: BoxDecoration(
              color: kWhite.withOpacity(0.4),
              borderRadius: const BorderRadius.all(
                Radius.circular(8.0),
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: ExpansionTile(
                maintainState: true,
                iconColor: myColor.primaryColorDark,
                childrenPadding: EdgeInsets.zero,
                tilePadding: EdgeInsets.zero,
                title: Text(
                  data.titleEn.toString(),
                  style: kStyleNormal.copyWith(
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                children: [
                  data.children!.isEmpty
                      ? Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Text(
                            'No sub category',
                            style: kStyleNormal.copyWith(
                              fontSize: 12.0,
                            ),
                          ),
                        )
                      : StreamBuilder<dynamic>(
                          initialData: getIDNameModel,
                          stream: selectedBloc!.stateStream,
                          builder: (context, snapshot) {
                            if (snapshot.data == null) {
                              return Container(
                                width: maxWidth(context),
                                padding: const EdgeInsets.only(bottom: 12.0),
                                child: Wrap(
                                  direction: Axis.horizontal,
                                  alignment: WrapAlignment.start,
                                  spacing: 10.0,
                                  runSpacing: 10.0,
                                  children: List.generate(
                                      data.children!.length,
                                      (index) => GestureDetector(
                                            onTap: () {
                                              newsBloc!.fetchAPIList(
                                                  'news?menu_id=${data.children![index].menuId}');
                                              refreshBloc!.storeData(true);
                                              selectedBloc!
                                                  .storeData(GetIDNameModel(
                                                id: i.toString(),
                                                name: data
                                                    .children![index].titleEn
                                                    .toString(),
                                              ));
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(6.0),
                                                color: kWhite.withOpacity(0.4),
                                              ),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 12.0,
                                                      vertical: 8.0),
                                              child: Text(
                                                data.children![index].titleEn
                                                    .toString(),
                                                style: kStyleNormal.copyWith(
                                                  fontSize: 12.0,
                                                ),
                                              ),
                                            ),
                                          )),
                                ),
                              );
                            } else {
                              return Align(
                                alignment: Alignment.centerLeft,
                                child: GestureDetector(
                                  onTap: () {
                                    newsBloc!.fetchAPIList('news');
                                    refreshBloc!.storeData(true);
                                    selectedBloc!.storeData(null);
                                  },
                                  child: Stack(
                                    clipBehavior: Clip.none,
                                    children: [
                                      Container(
                                        margin:
                                            const EdgeInsets.only(bottom: 12.0),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(6.0),
                                          border: Border.all(
                                            color:
                                                myColor.dialogBackgroundColor,
                                          ),
                                          color: kWhite.withOpacity(0.4),
                                        ),
                                        padding: const EdgeInsets.fromLTRB(
                                            12.0, 8.0, 25.0, 8.0),
                                        child: Text(
                                          snapshot.data.name.toString(),
                                          style: kStyleNormal.copyWith(
                                            fontSize: 12.0,
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        top: 10,
                                        right: 8.0,
                                        child: Icon(
                                          Icons.close,
                                          size: 14.0,
                                          color: myColor.primaryColorDark
                                              .withOpacity(0.4),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }
                          }),
                ]),
          ),
        ),
      ],
    );
  }
}
