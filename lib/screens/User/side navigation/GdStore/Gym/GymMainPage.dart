import 'package:flutter/material.dart';
import 'package:ghargharmadoctor/api/api_imports.dart';
import 'package:ghargharmadoctor/constants/constants_imports.dart';
import 'package:ghargharmadoctor/models/AllListOfVendorsModel.dart';
import 'package:ghargharmadoctor/models/models.dart';
import 'package:ghargharmadoctor/screens/User/main/mainHomeScreen.dart';
import 'package:ghargharmadoctor/screens/User/side%20navigation/GdStore/StoreUtils/allProductListWidget.dart';
import 'package:ghargharmadoctor/screens/User/side%20navigation/GdStore/StoreUtils/latestProductWidget.dart';
import 'package:ghargharmadoctor/screens/User/side%20navigation/GdStore/StoreUtils/subCategoryWidget.dart';
import 'package:ghargharmadoctor/screens/User/side%20navigation/GdStore/StoreUtils/titleRow.dart';
import 'package:ghargharmadoctor/screens/User/side%20navigation/GdStore/StoreUtils/vendorsListWidget.dart';
import 'package:ghargharmadoctor/widgets/widgets_import.dart';

class GymMainPage extends StatefulWidget {
  final int? vendorTypeID;
  final List<SubCategory>? allCategoryModel;
  const GymMainPage({Key? key, this.vendorTypeID, this.allCategoryModel})
      : super(key: key);

  @override
  State<GymMainPage> createState() => _GymMainPageState();
}

class _GymMainPageState extends State<GymMainPage> {
  List<GymPackagesModel> servicesModel = [];
  ScrollController? _scrollController;
  ApiHandlerBloc? servicesBloc, productBloc;
  List<String> testList = [];
  @override
  void initState() {
    print('widget.vendorTypeID ${widget.vendorTypeID}');
    super.initState();
    servicesBloc = ApiHandlerBloc();
    _scrollController = ScrollController()..addListener(loadMore);
    servicesBloc!.fetchAPIList(endpoints.getGymPackagesEndpoint);
  }

  void loadMore() async {
    if (_scrollController!.offset >=
            _scrollController!.position.maxScrollExtent &&
        !_scrollController!.position.outOfRange) {
      // stateBloc!.storeData(_scrollController!.position.extentAfter);
      loadingBloc!.storeData(1);
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      controller: _scrollController,
      child: StreamBuilder<dynamic>(
          initialData: null,
          stream: scrollingBloc.stateStream,
          builder: (c, s) {
            if (s.data == 1) {
              _scrollController!.animateTo(0,
                  curve: Curves.easeInOut,
                  duration: const Duration(milliseconds: 500));
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox12(),
                subCategoryWidget(context, widget.vendorTypeID),
                const SizedBox12(),
                // titleCard('Our Services', 'See All', () {}),
                servicesWidget(),
                titleCard('Fitness Centers', 'See All', () {}),
                vendorListWidget(context, widget.vendorTypeID),
                titleCard('Latest Products', 'See all', () {}),
                latestProductWidget(context, widget.vendorTypeID, '', setState),
                titleCard('All Products', 'See all', () {}),
                allProductListWidget(context, widget.vendorTypeID, ''),
              ],
            );
          }),
    );
  }

  Widget servicesWidget() {
    return Padding(
      padding: const EdgeInsets.only(left: 12.0),
      child: StreamBuilder<ApiResponse<dynamic>>(
        stream: servicesBloc!.apiListStream,
        builder: ((context, snapshot) {
          if (snapshot.hasData) {
            switch (snapshot.data!.status) {
              case Status.LOADING:
                return const Center(child: AnimatedLoading());
              case Status.COMPLETED:
                if (snapshot.data!.data.isEmpty) {
                  return Container(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      width: maxWidth(context),
                      decoration: BoxDecoration(
                        color: kWhite,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                          child: Text('No any gym category',
                              style: kStyleNormal.copyWith(fontSize: 12.0))));
                }

                servicesModel = List<GymPackagesModel>.from(snapshot.data!.data
                    .map((i) => GymPackagesModel.fromJson(i)));
                testList.clear();
                for (int i = 0; i < servicesModel.length; i++) {
                  if (!testList
                      .contains(servicesModel[i].fitnesstype!.fitnessName!)) {
                    testList.add(servicesModel[i].fitnesstype!.fitnessName!);
                  }
                }
                return
                    // SingleChildScrollView(
                    //   scrollDirection: Axis.horizontal,
                    //   physics: const BouncingScrollPhysics(),
                    //   child: SizedBox(
                    //     width: maxWidth(context),
                    //     child: Row(
                    //       children: [
                    //         SizedBox(
                    //           height: 25.0,
                    //           child: ListView.builder(
                    //               shrinkWrap: true,
                    //               padding: EdgeInsets.zero,
                    //               itemCount: testList.length,
                    //               physics: const BouncingScrollPhysics(),
                    //               scrollDirection: Axis.horizontal,
                    //               itemBuilder: (ctx, i) {
                    //                 return Container(
                    //                   margin: EdgeInsets.only(
                    //                       right:
                    //                           i == testList.length - 1 ? 0.0 : 8.0),
                    //                   padding: const EdgeInsets.symmetric(
                    //                       horizontal: 12.0, vertical: 4.0),
                    //                   decoration: BoxDecoration(
                    //                       color: kWhite.withOpacity(0.5),
                    //                       borderRadius: const BorderRadius.all(
                    //                         Radius.circular(5.0),
                    //                       ),
                    //                       boxShadow: [
                    //                         BoxShadow(
                    //                           blurRadius: 0.4,
                    //                           color: backgroundColor,
                    //                         )
                    //                       ]),
                    //                   child: Text(
                    //                     testList[i].toString(),
                    //                     style:
                    //                         kStyleNormal.copyWith(fontSize: 12.0),
                    //                   ),
                    //                 );
                    //               }),
                    //         ),
                    //         const SizedBox(width: 8.0),
                    //         const SizedBox(width: 12.0),
                    //       ],
                    //     ),
                    //   ),
                    // );

                    SizedBox(
                  width: maxWidth(context),
                  height: 200.0,
                  child: ListView.builder(
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      itemCount: servicesModel.length,
                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (ctx, i) {
                        return servicesCard(servicesModel[i]);
                      }),
                );

              case Status.ERROR:
                return Container(
                  margin: const EdgeInsets.only(top: 20.0),
                  width: maxWidth(context),
                  height: 135.0,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.0)),
                  child: const Center(
                    child: Text('Server Error'),
                  ),
                );
            }
          }
          return SizedBox(
            width: maxWidth(context),
          );
        }),
      ),
    );
  }

  Widget servicesCard(GymPackagesModel data) {
    return GestureDetector(
        onTap: () {},
        child: Container(
          width: 160.0,
          margin: const EdgeInsets.only(right: 10.0),
          decoration: BoxDecoration(
            color: kWhite,
            borderRadius: const BorderRadius.all(
              Radius.circular(12.0),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: kWhite,
                    borderRadius: const BorderRadius.all(
                      Radius.circular(12.0),
                    ),
                    // image: DecorationImage(
                    //   image: NetworkImage(
                    //       'https://www.najmc.com/wp-content/uploads/2020/08/ecommerce-marketing.jpg'),
                    //   fit: BoxFit.fill,
                    // ),
                  ),
                  child: myCachedNetworkImage(
                    160.0,
                    80.0,
                    'productModelData.imagePath.toString()',
                    const BorderRadius.all(
                      Radius.circular(12.0),
                    ),
                    BoxFit.cover,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox2(),
                    const SizedBox2(),
                    Text(
                      data.fitnesstype!.fitnessName.toString(),
                      overflow: TextOverflow.ellipsis,
                      style: kStyleNormal.copyWith(
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Per month',
                      overflow: TextOverflow.ellipsis,
                      style: kStyleNormal.copyWith(
                        fontSize: 10.0,
                      ),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                'Rs',
                                overflow: TextOverflow.ellipsis,
                                style: kStyleNormal.copyWith(
                                  color: myColor.primaryColorDark,
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 6.0),
                              Text(
                                data.oneMonth.toString(),
                                overflow: TextOverflow.ellipsis,
                                style: kStyleNormal.copyWith(
                                  color: myColor.primaryColorDark,
                                  fontSize: 17.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {},
                          child: Container(
                            height: 35.0,
                            width: 35.0,
                            decoration: BoxDecoration(
                              color: myColor.primaryColorDark,
                              borderRadius: const BorderRadius.all(
                                Radius.circular(8.0),
                              ),
                            ),
                            child: const Icon(
                              Icons.shopping_bag_outlined,
                              size: 16.0,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox8(),
            ],
          ),
        ));
  }
}
