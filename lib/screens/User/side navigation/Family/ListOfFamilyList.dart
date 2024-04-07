import 'package:flutter/material.dart';
import 'package:ghargharmadoctor/api/api_imports.dart';
import 'package:ghargharmadoctor/constants/constants_imports.dart';
import 'package:ghargharmadoctor/models/FamilyTypeModel/ListOfFamilyModel.dart';
import 'package:ghargharmadoctor/screens/User/side%20navigation/Family/familyCard.dart';
import 'package:ghargharmadoctor/widgets/widgets_import.dart';

StateHandlerBloc refreshFamilyList = StateHandlerBloc();

class ListOfFamily extends StatefulWidget {
  const ListOfFamily({super.key});

  @override
  State<ListOfFamily> createState() => _ListOfFamilyState();
}

class _ListOfFamilyState extends State<ListOfFamily> {
  ApiHandlerBloc? familyListBloc;

  @override
  void initState() {
    super.initState();
    familyListBloc = ApiHandlerBloc();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<dynamic>(
        stream: refreshFamilyList.stateStream,
        builder: ((context, snapshot) {
          familyListBloc!.fetchAPIList(endpoints.familyListEndpoint);
          return StreamBuilder<ApiResponse<dynamic>>(
            stream: familyListBloc!.apiListStream,
            builder: ((context, snapshot) {
              if (snapshot.hasData) {
                switch (snapshot.data!.status) {
                  case Status.LOADING:
                    return SizedBox(
                      width: maxWidth(context),
                      height: maxHeight(context) / 3,
                      child: const Center(
                        child: AnimatedLoading(),
                      ),
                    );
                  case Status.COMPLETED:
                    if (snapshot.data!.data.isEmpty) {
                      return Container(
                          height: 140,
                          margin: const EdgeInsets.all(12.0),
                          decoration: BoxDecoration(
                            color: kWhite,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child:
                              const Center(child: Text('No family members')));
                    }
                    List<ListOfFamilyModel> listOfFamilyModel =
                        List<ListOfFamilyModel>.from(snapshot.data!.data
                            .map((i) => ListOfFamilyModel.fromJson(i)));
                    listOfFamilyModel = listOfFamilyModel
                        .where((element) => element.approved == 1)
                        .toList();
                    List<int> listOfID = [];
                    return StreamBuilder<dynamic>(
                        initialData: listOfID,
                        stream: listOfIDBloc.stateStream,
                        builder: (listC, listSnap) {
                          if (listSnap.data.isEmpty) {
                            payBloc.storeData(0);
                          }
                          return StreamBuilder<dynamic>(
                              initialData: 0,
                              stream: payBloc.stateStream,
                              builder: (c, s) {
                                return ListView.builder(
                                    itemCount: listOfFamilyModel.length,
                                    shrinkWrap: true,
                                    padding:
                                        const EdgeInsets.only(bottom: 70.0),
                                    physics: const BouncingScrollPhysics(),
                                    itemBuilder: (ctx, i) {
                                      return familyCard(context, 'empty',
                                          listOfFamilyModel[i], 'familyList',
                                          stateStatus: listOfFamilyModel[i]
                                                      .paymentStatus ==
                                                  0
                                              ? s.data
                                              : null,
                                          listOfID: listSnap.data);
                                    });
                              });
                        });

                  case Status.ERROR:
                    return Container(
                      width: maxWidth(context),
                      margin: const EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                        color: kWhite,
                        borderRadius: BorderRadius.circular(12),
                      ),
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
          );
        }));
  }
}
