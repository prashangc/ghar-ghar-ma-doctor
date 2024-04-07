import 'package:flutter/material.dart';
import 'package:ghargharmadoctor/constants/constants_imports.dart';
import 'package:ghargharmadoctor/models/AmbulanceModel/AllAmbulanceLatLng.dart';
import 'package:ghargharmadoctor/models/AmbulanceModel/GetAllAmbulanceListModel.dart';
import 'package:ghargharmadoctor/screens/User/home/Ambulance/GoogleMapAmbulanceUserSide.dart';

class HomeScreenAmbulances extends StatefulWidget {
  List<GetAllAmbulanceListModel> getAllAmbulanceListModel;

  HomeScreenAmbulances({Key? key, required this.getAllAmbulanceListModel})
      : super(key: key);

  @override
  State<HomeScreenAmbulances> createState() => _HomeScreenAmbulancesState();
}

class _HomeScreenAmbulancesState extends State<HomeScreenAmbulances> {
  List<AllAmbulanceListModel> myAllAmbulanceList = [];
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox16(),
          GridView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: maxWidth(context) / 400,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10),
              itemCount: widget.getAllAmbulanceListModel.length < 4
                  ? widget.getAllAmbulanceListModel.length
                  : 4,
              itemBuilder: (BuildContext ctx, index) {
                return GestureDetector(
                  onTap: () {
                    myAllAmbulanceList.clear();
                    myAllAmbulanceList.add(AllAmbulanceListModel(
                        lat: double.parse(widget
                            .getAllAmbulanceListModel[index].latitude
                            .toString()),
                        lng: double.parse(widget
                            .getAllAmbulanceListModel[index].longitude
                            .toString())));
                    goThere(
                      context,
                      GoogleMapAmbulanceUserSide(
                        getAllAmbulanceListModel: myAllAmbulanceList,
                        driverID: widget.getAllAmbulanceListModel[index].id,
                      ),
                    );
                    // goThere(
                    //     context,
                    //     MyGoogleMap(
                    //       type: 'showAllAmbulance',
                    //       getAllAmbulanceListModel: myAllAmbulanceList,
                    //       driverID:
                    //           widget.getAllAmbulanceListModel[index].driverId,
                    //     ),);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(5.0),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Container(
                            width: maxWidth(context),
                            height: 80,
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 238, 238, 238),
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            child: myCachedNetworkImage(
                                maxWidth(context),
                                maxHeight(context),
                                widget.getAllAmbulanceListModel[index].imagePath
                                    .toString(),
                                const BorderRadius.all(
                                  Radius.circular(12.0),
                                ),
                                BoxFit.contain),
                          ),
                        ),
                        const SizedBox(height: 5.0),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.getAllAmbulanceListModel[index].driver!
                                    .name
                                    .toString(),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: kStyleNormal.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                widget.getAllAmbulanceListModel[index].address
                                    .toString(),
                                overflow: TextOverflow.ellipsis,
                                style: kStyleNormal.copyWith(
                                  color: myColor.primaryColorDark,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox2(),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.call_outlined,
                                    size: 12.0,
                                  ),
                                  const SizedBox(
                                    width: 5.0,
                                  ),
                                  Flexible(
                                    child: Text(
                                      widget.getAllAmbulanceListModel[index]
                                          .driver!.phone
                                          .toString(),
                                      overflow: TextOverflow.ellipsis,
                                      style: kStyleNormal.copyWith(
                                        fontSize: 10.0,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
          const SizedBox12(),
        ],
      ),
    );
  }
}
