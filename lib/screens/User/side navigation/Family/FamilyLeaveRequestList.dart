import 'package:flutter/material.dart';
import 'package:ghargharmadoctor/api/api_imports.dart';
import 'package:ghargharmadoctor/constants/constants_imports.dart';
import 'package:ghargharmadoctor/models/FamilyTypeModel/ListOfLeaveRequestModel.dart';
import 'package:ghargharmadoctor/screens/User/side%20navigation/Family/familyCard.dart';
import 'package:ghargharmadoctor/widgets/widgets_import.dart';

StateHandlerBloc refreshLeaveList = StateHandlerBloc();

class FamilyLeaveRequestList extends StatefulWidget {
  const FamilyLeaveRequestList({super.key});

  @override
  State<FamilyLeaveRequestList> createState() => _FamilyLeaveRequestListState();
}

class _FamilyLeaveRequestListState extends State<FamilyLeaveRequestList> {
  ApiHandlerBloc? familyListBloc;

  @override
  void initState() {
    super.initState();
    familyListBloc = ApiHandlerBloc();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<dynamic>(
        stream: refreshLeaveList.stateStream,
        builder: ((ctx, snapshot) {
          familyListBloc!
              .fetchAPIList(endpoints.getAllFamilyLeaveRequestListEndpoint);
          return StreamBuilder<ApiResponse<dynamic>>(
            stream: familyListBloc!.apiListStream,
            builder: ((c, snapshot) {
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
                          child: const Center(child: Text('No Leave request')));
                    }
                    List<ListOfLeaveRequestModel> listOfLeaveRequestModel =
                        List<ListOfLeaveRequestModel>.from(snapshot.data!.data
                            .map((i) => ListOfLeaveRequestModel.fromJson(i)));
                    return ListView.builder(
                        reverse: true,
                        itemCount: listOfLeaveRequestModel.length,
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (ctx, i) {
                          return familyLeaveCard(
                            context,
                            listOfLeaveRequestModel[i],
                          );
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
