import 'package:flutter/material.dart';
import 'package:ghargharmadoctor/constants/constants_imports.dart';
import 'package:ghargharmadoctor/models/OurServicesModel.dart';
import 'package:ghargharmadoctor/screens/User/home/OurServices/IndividualServicePage.dart';
import 'package:ghargharmadoctor/widgets/widgets_import.dart';

class AllServices extends StatefulWidget {
  List<OurServicesModel> ourServicesModel;
  AllServices({Key? key, required this.ourServicesModel}) : super(key: key);

  @override
  State<AllServices> createState() => _AllServicesState();
}

class _AllServicesState extends State<AllServices> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: myCustomAppBar(
        title: 'All Services',
        color: backgroundColor,
        borderRadius: 12.0,
      ),
      body: widget.ourServicesModel.isEmpty
          ? SizedBox(
              height: maxHeight(context) - 100,
              child: const Center(child: Text('No services added')))
          : SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 15.0),
                margin: const EdgeInsets.only(top: 20),
                decoration: BoxDecoration(
                  color: myColor.dialogBackgroundColor,
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(25),
                    topLeft: Radius.circular(25),
                  ),
                ),
                width: maxWidth(context),
                height: maxHeight(context),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'All Services',
                      style: kStyleNormal.copyWith(
                        fontSize: 17.0,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox16(),
                    GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 2.4 / 3,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 0.1),
                        itemCount: widget.ourServicesModel.length,
                        itemBuilder: (BuildContext ctx, index) {
                          return GestureDetector(
                            onTap: () {
                              goThere(
                                  context,
                                  IndividualServicePage(
                                      ourServiceModel:
                                          widget.ourServicesModel[index]));
                            },
                            child: Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5.0),
                              alignment: Alignment.center,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: maxWidth(context),
                                    height: 140.0,
                                    decoration: BoxDecoration(
                                      image: widget.ourServicesModel[index]
                                                  .imagePath
                                                  .toString() ==
                                              ''
                                          ? const DecorationImage(
                                              image:
                                                  AssetImage('assets/logo.png'),
                                              fit: BoxFit.cover,
                                            )
                                          : DecorationImage(
                                              image: NetworkImage(
                                                widget.ourServicesModel[index]
                                                    .imagePath
                                                    .toString(),
                                              ),
                                              fit: BoxFit.fill,
                                            ),
                                      color: Colors.transparent,
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(4.0)),
                                    ),
                                  ),
                                  const SizedBox8(),
                                  SizedBox(
                                    width: maxWidth(context),
                                    height: 18,
                                    child: Center(
                                      child: Text(
                                        widget.ourServicesModel[index]
                                            .serviceTitle
                                            .toString(),
                                        overflow: TextOverflow.ellipsis,
                                        style: kStyleNormal.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                    const SizedBox24(),
                  ],
                ),
              ),
            ),
    );
  }
}
