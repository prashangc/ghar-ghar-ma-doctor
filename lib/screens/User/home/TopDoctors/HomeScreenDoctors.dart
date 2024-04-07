import 'package:flutter/material.dart';
import 'package:ghargharmadoctor/constants/constants_imports.dart';
import 'package:ghargharmadoctor/models/DoctorModel/GetAllDoctorsModel.dart';
import 'package:ghargharmadoctor/screens/User/home/TopDoctors/IndividualDoctorPage.dart';

class HomeScreenDoctors extends StatefulWidget {
  List<Doctors> doctors;

  HomeScreenDoctors({Key? key, required this.doctors}) : super(key: key);

  @override
  State<HomeScreenDoctors> createState() => _HomeScreenDoctorsState();
}

class _HomeScreenDoctorsState extends State<HomeScreenDoctors> {
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
              itemCount: widget.doctors.length < 4 ? widget.doctors.length : 4,
              itemBuilder: (BuildContext ctx, index) {
                return GestureDetector(
                  onTap: () {
                    goThere(context,
                        IndividualDoctorPage(doctors: widget.doctors[index]));
                  },
                  child: Container(
                    padding: const EdgeInsets.all(5.0),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: kWhite, borderRadius: BorderRadius.circular(15)),
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
                            child: Stack(
                              children: [
                                myCachedNetworkImage(
                                    maxWidth(context),
                                    maxHeight(context),
                                    widget.doctors[index].imagePath.toString(),
                                    const BorderRadius.all(
                                      Radius.circular(12.0),
                                    ),
                                    BoxFit.contain),
                                Positioned(
                                  top: 4.0,
                                  left: 4.0,
                                  child: Icon(
                                    Icons.circle,
                                    size: 12.0,
                                    color: widget.doctors[index].fee == null
                                        ? kGrey.withOpacity(0.9)
                                        : kGreen,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 5.0),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.doctors[index].user!.name.toString(),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: kStyleNormal.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                widget.doctors[index].specialization.toString(),
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
                                    Icons.perm_identity_outlined,
                                    size: 12.0,
                                  ),
                                  const SizedBox(
                                    width: 5.0,
                                  ),
                                  Flexible(
                                    child: Text(
                                      widget.doctors[index].address.toString(),
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
          const SizedBox16(),
        ],
      ),
    );
  }
}
