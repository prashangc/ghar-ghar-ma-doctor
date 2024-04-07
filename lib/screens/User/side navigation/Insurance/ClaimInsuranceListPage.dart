import 'package:flutter/material.dart';
import 'package:ghargharmadoctor/api/api_imports.dart';
import 'package:ghargharmadoctor/constants/constants_imports.dart';
import 'package:ghargharmadoctor/models/models.dart';
import 'package:ghargharmadoctor/screens/User/side%20navigation/Insurance/ClaimInsuranceDetailsPage.dart';
import 'package:ghargharmadoctor/widgets/widgets_import.dart';
import 'package:google_fonts/google_fonts.dart';

class ClaimInsuranceListPage extends StatefulWidget {
  const ClaimInsuranceListPage({Key? key}) : super(key: key);

  @override
  State<ClaimInsuranceListPage> createState() => _ClaimInsuranceListPageState();
}

class _ClaimInsuranceListPageState extends State<ClaimInsuranceListPage>
    with TickerProviderStateMixin {
  ApiHandlerBloc? insuranceListBloc;
  TabController? _tabController;
  GetClaimInsuranceListModel? insuranceModel;
  @override
  void initState() {
    super.initState();
    insuranceListBloc = ApiHandlerBloc();
    insuranceListBloc!.fetchAPIList(endpoints.getClaimInsuranceDetailsEndpoint);
    _tabController = TabController(length: 2, initialIndex: 0, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        myfocusRemover(context);
      },
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: myCustomAppBar(
          title: 'Insurance',
          color: backgroundColor,
          borderRadius: 12.0,
        ),
        body: Container(
          margin: const EdgeInsets.only(top: 10.0),
          width: maxWidth(context),
          height: maxHeight(context),
          padding: const EdgeInsets.fromLTRB(12.0, 18.0, 12.0, 0.0),
          decoration: BoxDecoration(
            color: myColor.dialogBackgroundColor,
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(25),
              topLeft: Radius.circular(25),
            ),
          ),
          child: Column(
            children: [
              Container(
                width: maxWidth(context),
                decoration: BoxDecoration(
                  color: backgroundColor.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: TabBar(
                    labelColor: kWhite,
                    unselectedLabelColor: kBlack,
                    controller: _tabController,
                    indicator: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: myColor.primaryColorDark,
                    ),
                    onTap: (i) {
                      setState(() {
                        _tabController!.index = i;
                      });
                    },
                    tabs: [
                      Tab(
                        child: Text(
                          'Normal Insurance',
                          style: GoogleFonts.sourceSansPro(
                            fontSize: 12,
                          ),
                        ),
                      ),
                      Tab(
                        child: Text(
                          'Death Insurance',
                          style: GoogleFonts.sourceSansPro(
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox12(),
              SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: StreamBuilder<ApiResponse<dynamic>>(
                  stream: insuranceListBloc!.apiListStream,
                  builder: ((context, snapshot) {
                    if (snapshot.hasData) {
                      switch (snapshot.data!.status) {
                        case Status.LOADING:
                          return SizedBox(
                            width: maxWidth(context),
                            height: maxHeight(context) / 1.4,
                            child: const AnimatedLoading(),
                          );
                        case Status.COMPLETED:
                          if (snapshot.data!.data.isEmpty) {
                            return emptyPage(
                                context,
                                'No any Insurance',
                                'You haven\'t made any claim insurance request',
                                '',
                                () {},
                                testColor: kWhite.withOpacity(0.4));
                          }

                          insuranceModel = GetClaimInsuranceListModel.fromJson(
                              snapshot.data!.data);
                          List<Claims> normalClaims = [];
                          List<Claims> deathClaims = [];
                          normalClaims = insuranceModel!.claims!
                              .where((element) => element.claim == null)
                              .toList();
                          deathClaims = insuranceModel!.claims!
                              .where((element) => element.claim != null)
                              .toList();
                          return ListView.builder(
                              itemCount: _tabController!.index == 0
                                  ? normalClaims.length
                                  : deathClaims.length,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              padding: EdgeInsets.zero,
                              itemBuilder: (ctx, i) {
                                return GestureDetector(
                                    onTap: () {
                                      // if (insuranceModel[i].insuranceStatus ==
                                      //     'Approved') {
                                      goThere(
                                          context,
                                          ClaimInsuranceDetailsPage(
                                              claimedBy:
                                                  _tabController!.index == 0
                                                      ? null
                                                      : deathClaims[i]
                                                          .user!
                                                          .name
                                                          .toString(),
                                              company: insuranceModel!,
                                              getClaimInsuranceListModel:
                                                  _tabController!.index == 0
                                                      ? normalClaims[i]
                                                      : deathClaims[i]));
                                      // }
                                    },
                                    child: insuranceCard(
                                        _tabController!.index == 0
                                            ? normalClaims[i]
                                            : deathClaims[i]));
                              });

                        case Status.ERROR:
                          return Container(
                            width: maxWidth(context),
                            height: 135.0,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Center(
                              child: Text('Server Error'),
                            ),
                          );
                      }
                    }
                    return const SizedBox();
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget insuranceCard(Claims insurance) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
      decoration: BoxDecoration(
        color: kWhite.withOpacity(0.4),
        borderRadius: const BorderRadius.all(
          Radius.circular(12.0),
        ),
      ),
      margin: const EdgeInsets.only(bottom: 12.0),
      width: maxWidth(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    insurance.insuranceStatus == 'Approved'
                        ? 'Approval Date:  '
                        : 'Requested Date:  ',
                    style: kStyleNormal.copyWith(
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    insurance.createdAt.toString().substring(0, 10),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: kStyleNormal.copyWith(
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              insurance.insuranceStatus != 'Approved'
                  ? Icon(Icons.error_outline_outlined, color: kRed, size: 16.0)
                  : Icon(Icons.visibility,
                      color: myColor.primaryColorDark, size: 16.0),
            ],
          ),
          const SizedBox2(),
          const SizedBox2(),
          Divider(
            color: myColor.dialogBackgroundColor,
          ),
          const SizedBox2(),
          const SizedBox2(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              myCachedNetworkImage(
                60.0,
                60.0,
                'myProducts.imagePath.toString(),',
                const BorderRadius.all(
                  Radius.circular(8.0),
                ),
                BoxFit.cover,
              ),
              const SizedBox(width: 12.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      insurance.insurance!.insurancetype!.type.toString(),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: kStyleNormal.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 14.0,
                      ),
                    ),
                    const SizedBox2(),
                    const SizedBox2(),
                    Text(
                      insuranceModel!.companyName.toString().capitalize(),
                      style: kStyleNormal.copyWith(
                        // fontWeight: FontWeight.bold,
                        fontSize: 11.0,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox2(),
                  ],
                ),
              ),
              const SizedBox(width: 12.0),
            ],
          ),
          const SizedBox2(),
          Divider(color: myColor.dialogBackgroundColor),
          const SizedBox2(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    'Amount:  ',
                    style: kStyleNormal.copyWith(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Rs ${insurance.claimAmount.toString()}',
                    overflow: TextOverflow.ellipsis,
                    style: kStyleNormal.copyWith(
                      fontSize: 16.0,
                      color: myColor.primaryColorDark,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                decoration: BoxDecoration(
                  color: insurance.insuranceStatus != 'Approved'
                      ? Colors.red.withOpacity(0.9)
                      : kGreen,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(5.0),
                  ),
                ),
                child: Text(
                  insurance.insuranceStatus.toString(),
                  textAlign: TextAlign.center,
                  style: kStyleNormal.copyWith(
                    fontSize: 10.0,
                    color: myColor.scaffoldBackgroundColor,
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
    // Container(
    //   padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
    //   margin: const EdgeInsets.only(bottom: 8.0),
    //   decoration: BoxDecoration(
    //     color: kWhite,
    //     borderRadius: const BorderRadius.all(
    //       Radius.circular(
    //         12.0,
    //       ),
    //     ),
    //   ),
    //   child: Column(
    //     crossAxisAlignment: CrossAxisAlignment.start,
    //     children: [
    //       Row(
    //         children: [
    //           Text(
    //             insurance.insurance!.criteriaType!.type.toString(),
    //             style: kStyleNormal.copyWith(
    //               fontSize: 14.0,
    //               fontWeight: FontWeight.bold,
    //             ),
    //           ),
    //         ],
    //       ),
    //     SizedBox2(),
    //     SizedBox2(),
    //       const Divider(),

    //     SizedBox2(),
    //     SizedBox2(),

    //     ],
    //   ),
    // );
  }
}
