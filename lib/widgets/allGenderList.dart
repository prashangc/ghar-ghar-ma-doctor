import 'package:flutter/material.dart';
import 'package:ghargharmadoctor/api/api_imports.dart';
import 'package:ghargharmadoctor/constants/constants_imports.dart';
import 'package:ghargharmadoctor/models/models.dart';
import 'package:ghargharmadoctor/screens/User/Loading/GenderLoadingShimmer.dart';

class AllGenderList extends StatefulWidget {
  final GenderModel genderModel;
  final onTap;
  final isSelected;
  const AllGenderList(this.genderModel, this.onTap, this.isSelected, {super.key});

  @override
  State<AllGenderList> createState() => _AllGenderListState();
}

class _AllGenderListState extends State<AllGenderList> {
  ApiHandlerBloc? profileBloc;

  @override
  void initState() {
    super.initState();
    profileBloc = ApiHandlerBloc();
    profileBloc!.fetchAPIList('admin/user-profile');
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ApiResponse<dynamic>>(
      stream: profileBloc!.apiListStream,
      builder: ((context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data!.status) {
            case Status.LOADING:
              return const GenderLoadingShimmer();
            case Status.COMPLETED:
              ProfileModel profileModel =
                  ProfileModel.fromJson(snapshot.data!.data);
              return GestureDetector(
                onTap: widget.onTap,
                child: Container(
                  margin: const EdgeInsets.only(right: 10),
                  padding: const EdgeInsets.symmetric(
                      vertical: 20.0, horizontal: 10.0),
                  width: 100,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color:
                            //  profileModel.gender ==
                            //         widget.genderModel.genderName.toString()
                            //     ? Colors.green
                            //     :
                            widget.isSelected ? Colors.green : Colors.white,
                      )),
                  child: Column(
                    children: [
                      Container(
                        child: widget.genderModel.genderIcon,
                      ),
                      const SizedBox8(),
                      Text(
                        widget.genderModel.genderName.toString(),
                      ),
                    ],
                  ),
                ),
              );
            case Status.ERROR:
              return Center(
                child: Text(
                  "error..",
                  style: kStyleTitle,
                ),
              );
          }
        }
        return SizedBox(
          width: maxWidth(context),
          height: 200,
        );
      }),
    );
  }
}
