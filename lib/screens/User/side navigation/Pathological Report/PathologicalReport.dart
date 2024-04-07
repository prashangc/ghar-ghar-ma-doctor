// import 'package:flutter/material.dart';
// import 'package:ghargharmadoctor/api/api_imports.dart';
// import 'package:ghargharmadoctor/constants/constants_imports.dart';
// import 'package:ghargharmadoctor/widgets/widgets_import.dart';

// class PathologicalReport extends StatefulWidget {
//   const PathologicalReport({Key? key}) : super(key: key);

//   @override
//   State<PathologicalReport> createState() => _PathologicalReportState();
// }

// class _PathologicalReportState extends State<PathologicalReport> {
//   ApiHandlerBloc? medicalServicesBloc;
//   List<GetMedicalServicesModel> getMedicalServicesModel = [];
//   @override
//   void initState() {
//     super.initState();
//     medicalServicesBloc = ApiHandlerBloc();
//     medicalServicesBloc!.fetchAPIList(endpoints.getMedicalServicesEndpoint);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         myfocusRemover(context);
//       },
//       child: Scaffold(
//         backgroundColor: backgroundColor,
//         appBar: myCustomAppBar(
//           title: 'Pathological Reports',
//           color: backgroundColor,
//           borderRadius: 12.0,
//         ),
//         body: Container(
//           margin: const EdgeInsets.only(top: 10.0),
//           width: maxWidth(context),
//           height: maxHeight(context),
//           padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
//           decoration: BoxDecoration(
//             color: myColor.dialogBackgroundColor,
//             borderRadius: const BorderRadius.only(
//               topRight: Radius.circular(25),
//               topLeft: Radius.circular(25),
//             ),
//           ),
//           child: SingleChildScrollView(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   'Enter Details ',
//                   style: kStyleNormal.copyWith(
//                       fontWeight: FontWeight.bold,
//                       fontSize: 17.0,
//                       color: myColor.primaryColorDark),
//                 ),
//                 StreamBuilder<ApiResponse<dynamic>>(
//                   stream: medicalServicesBloc!.apiListStream,
//                   builder: ((context, snapshot) {
//                     if (snapshot.hasData) {
//                       switch (snapshot.data!.status) {
//                         case Status.LOADING:
//                           return Container(
//                             width: maxWidth(context),
//                             height: maxHeight(context) - 180,
//                             margin: const EdgeInsets.symmetric(vertical: 10.0),
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(12),
//                             ),
//                             child: const AnimatedLoading(),
//                           );
//                         case Status.COMPLETED:
//                           if (snapshot.data!.data.isEmpty) {
//                             return Container(
//                                 height: 140,
//                                 margin:
//                                     const EdgeInsets.symmetric(vertical: 10.0),
//                                 decoration: BoxDecoration(
//                                   borderRadius: BorderRadius.circular(12),
//                                 ),
//                                 child: const Center(
//                                     child: Text(
//                                         'No medical services avaialable')));
//                           }
//                           getMedicalServicesModel =
//                               List<GetMedicalServicesModel>.from(
//                                   snapshot.data!.data.map((i) =>
//                                       GetMedicalServicesModel.fromJson(i)));

//                           return ListView.builder(
//                             itemBuilder: (ctx, i) {
//                               return myExpansionCard(
//                                   context, getMedicalServicesModel[i]);
//                             },
//                             shrinkWrap: true,
//                             itemCount: getMedicalServicesModel.length,
//                           );
//                         case Status.ERROR:
//                           return Container(
//                             width: maxWidth(context),
//                             height: maxHeight(context),
//                             margin: const EdgeInsets.symmetric(vertical: 10.0),
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(12),
//                             ),
//                             child: const Center(
//                               child: Text('Server Error'),
//                             ),
//                           );
//                       }
//                     }
//                     return SizedBox(
//                       width: maxWidth(context),
//                       height: 200,
//                     );
//                   }),
//                 ),
//                 SizedBox(
//                     height: 55.0,
//                     width: maxWidth(context),
//                     child: myCustomButton(
//                         context,
//                         myColor.primaryColorDark,
//                         'Save',
//                         kStyleNormal.copyWith(
//                             fontSize: 18.0, color: Colors.white),
//                         () {})),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// Widget myExpansionCard(
//     BuildContext context, GetMedicalServicesModel getMedicalServicesModel) {
//   String? hb;
//   ApiHandlerBloc? testNameBloc;
//   testNameBloc = ApiHandlerBloc();
//   GetTestDetailsModel getTestDetailsModel;

//   testNameBloc.fetchAPIList(
//       'admin/medical-report/services/${getMedicalServicesModel.id}');

//   return SizedBox(
//     width: maxWidth(context),
//     child: ExpansionPanelList.radio(
//       elevation: 0.0,
//       animationDuration: const Duration(milliseconds: 400),
//       children: [
//         ExpansionPanelRadio(
//           value: Null,
//           backgroundColor: Colors.transparent,
//           canTapOnHeader: true,
//           headerBuilder: (context, isExpanded) {
//             return Row(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 Container(
//                   color: Colors.transparent,
//                   child: Text(
//                     getMedicalServicesModel.serviceName.toString(),
//                     textAlign: TextAlign.start,
//                     overflow: TextOverflow.clip,
//                     style: kStyleNormal.copyWith(
//                         fontWeight: FontWeight.bold,
//                         color: myColor.primaryColorDark),
//                   ),
//                 ),
//               ],
//             );
//           },
//           body: StreamBuilder<ApiResponse<dynamic>>(
//             stream: testNameBloc.apiListStream,
//             builder: ((context, snapshot) {
//               if (snapshot.hasData) {
//                 switch (snapshot.data!.status) {
//                   case Status.LOADING:
//                     return Container(
//                       width: maxWidth(context),
//                       height: 180,
//                       margin: const EdgeInsets.symmetric(vertical: 10.0),
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       child: const AnimatedLoading(),
//                     );
//                   case Status.COMPLETED:
//                     if (snapshot.data!.data.isEmpty) {
//                       return Container(
//                           height: 140,
//                           margin: const EdgeInsets.symmetric(vertical: 10.0),
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                           child: const Center(
//                               child: Text('No medical services avaialable')));
//                     }
//                     getTestDetailsModel =
//                         GetTestDetailsModel.fromJson(snapshot.data!.data);

//                     return ListView.builder(
//                       itemBuilder: (ctx, i) {
//                         return Container(
//                           color: Colors.transparent,
//                           width: maxWidth(context),
//                           child: GridView.builder(
//                               shrinkWrap: true,
//                               physics: const NeverScrollableScrollPhysics(),
//                               gridDelegate:
//                                   const SliverGridDelegateWithFixedCrossAxisCount(
//                                       crossAxisCount: 3,
//                                       // childAspectRatio: 2.4 / 3,
//                                       crossAxisSpacing: 15,
//                                       mainAxisSpacing: 0),
//                               itemCount: 10,
//                               itemBuilder: (BuildContext ctx, index) {
//                                 return mytextFormField(
//                                   context,
//                                   'HB',
//                                   '',
//                                   '',
//                                   hb,
//                                   onValueChanged: (value) {
//                                     hb = value;
//                                   },
//                                 );
//                               }),
//                         );
//                       },
//                       shrinkWrap: true,
//                       itemCount: getTestDetailsModel.allTest!.length,
//                     );
//                   case Status.ERROR:
//                     return Container(
//                       width: maxWidth(context),
//                       height: 180,
//                       margin: const EdgeInsets.symmetric(vertical: 10.0),
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       child: const Center(
//                         child: Text('Server Error'),
//                       ),
//                     );
//                 }
//               }
//               return SizedBox(
//                 width: maxWidth(context),
//                 height: 200,
//               );
//             }),
//           ),
//         ),
//       ],
//     ),
//   );
// }
