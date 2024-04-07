import 'dart:convert';

import 'package:ghargharmadoctor/api/api_imports.dart';
import 'package:ghargharmadoctor/constants/constants_imports.dart';
import 'package:ghargharmadoctor/models/PackageModel/IndividualPackagesListModel.dart';
import 'package:ghargharmadoctor/models/models.dart';
import 'package:ghargharmadoctor/screens/User/home/LabServices/LabServices.dart';
import 'package:ghargharmadoctor/screens/User/home/OurServices/IndividualServicePage.dart';
import 'package:ghargharmadoctor/screens/User/main/mainHomeScreen.dart';
import 'package:ghargharmadoctor/screens/User/side%20navigation/FAQ/Faq.dart';
import 'package:ghargharmadoctor/screens/User/side%20navigation/Packages/PackageDescriptionPage.dart';

chatMap(context, value, {refresh}) {
  var test = sharedPrefs.getFromDevice("userProfile");
  ProfileModel profileModel = ProfileModel.fromJson(json.decode(test));
  Map<String, List<ChatbotModel>> mapChatName = {
    'init': [
      ChatbotModel(
        isFirst: true,
        title: refresh != true
            ? 'Do you have any more queries?'
            : 'Hi ${profileModel.member!.firstName}! I\'m Doctor Saab. If you have any queries, please select from options below.',
        data: [
          MyData(
            service: "Primary Packages",
          ),
          MyData(
            apiFunc: () async {
              List<OurServicesModel> ourServicesModel = [];
              var resp = await API()
                  .getData(context, endpoints.getOurServicesEndpoint);
              if (resp != null) {
                ourServicesModel = List<OurServicesModel>.from(
                    resp.map((i) => OurServicesModel.fromJson(i)));
                List<MyData> list = [];

                for (var element in ourServicesModel) {
                  list.add(MyData(
                    screen: IndividualServicePage(ourServiceModel: element),
                    id: element.id,
                    service: element.serviceTitle.toString(),
                  ));
                }
                list.add(MyData(
                  screen: const LabServices(),
                  id: null,
                  service: 'Lab Services',
                ));
                return list;
              }
            },
            service: "Other Services",
          ),
          MyData(
            service: "Clinical Queries",
          ),
          MyData(
            apiFunc: () async {
              List<GetFaqModel> getFaqModel = [];
              var resp = await API().getData(context, endpoints.getFaqEndpoint);
              if (resp != null) {
                getFaqModel = List<GetFaqModel>.from(
                    resp.map((i) => GetFaqModel.fromJson(i)));

                List<MyData> list = [];
                for (var element in getFaqModel) {
                  list.add(
                    MyData(
                      service: element.question.toString(),
                      answer: element.answer.toString(),
                      screen: Faq(getFaqModel: getFaqModel),
                    ),
                  );
                }
                return list;
              }
            },
            service: "Technical Queries",
          ),
          refresh != true
              ? MyData(
                  service: "No queries",
                )
              : MyData(),
        ],
      ),
    ],
    "No queries": [
      ChatbotModel(
        isFirst: true,
        title: 'Thank you, please remember me if you need any more assistance.',
        data: [],
      ),
    ],
    'Primary Packages': [
      ChatbotModel(
        title: 'Here are our primary packages: ',
        data: [
          MyData(
            apiFunc: () async {
              IndividualPackagesListModel? individualPackagesListModel;
              String token = sharedPrefs.getFromDevice('token') ?? 'empty';
              if (token != 'empty') {
                var resp = await API()
                    .getData(context, endpoints.getIndividualPackageEndpoint);
                if (resp != null) {
                  individualPackagesListModel =
                      IndividualPackagesListModel.fromJson(resp);
                  var respo = await API().getData(context, 'package');
                  if (respo != null) {
                    List<PackagesModel> packagesModel =
                        List<PackagesModel>.from(
                            respo.map((i) => PackagesModel.fromJson(i)));
                    List<MyData> list = [];
                    for (var element in packagesModel) {
                      list.add(MyData(
                        service: element.packageType.toString(),
                        screen: individualPackagesListModel.myPackage != null
                            ? const MainHomePage(index: 2, tabIndex: 0)
                            : PackageDescriptionPage(
                                packagesModel: element,
                                showCalculator:
                                    element.type == 3 || element.type == 4
                                        ? true
                                        : false,
                                isCorporate:
                                    element.type == 3 || element.type == 4
                                        ? true
                                        : false),
                      ));
                    }
                    return list;
                  }
                }
              } else {
                var respo = await API().getData(context, 'package');
                if (respo != null) {
                  List<PackagesModel> packagesModel = List<PackagesModel>.from(
                      respo.map((i) => PackagesModel.fromJson(i)));
                  List<MyData> list = [];
                  for (var element in packagesModel) {
                    list.add(MyData(
                      service: element.packageType.toString(),
                      screen: PackageDescriptionPage(
                          packagesModel: element,
                          showCalculator: element.type == 3 || element.type == 4
                              ? true
                              : false,
                          isCorporate: element.type == 3 || element.type == 4
                              ? true
                              : false),
                    ));
                  }
                  return list;
                }
              }
            },
            service: "Family Package",
          ),
          MyData(
            apiFunc: () async {
              IndividualPackagesListModel? individualPackagesListModel;
              String token = sharedPrefs.getFromDevice('token') ?? 'empty';
              if (token != 'empty') {
                var resp = await API()
                    .getData(context, endpoints.getIndividualPackageEndpoint);
                if (resp != null) {
                  individualPackagesListModel =
                      IndividualPackagesListModel.fromJson(resp);
                  var respo = await API().getData(context, 'package');
                  if (respo != null) {
                    List<PackagesModel> packagesModel =
                        List<PackagesModel>.from(
                            respo.map((i) => PackagesModel.fromJson(i)));
                    List<MyData> list = [];
                    for (var element in packagesModel) {
                      list.add(MyData(
                        service: element.packageType.toString(),
                        screen: individualPackagesListModel.myPackage != null
                            ? const MainHomePage(index: 2, tabIndex: 0)
                            : PackageDescriptionPage(
                                packagesModel: element,
                                showCalculator:
                                    element.type == 3 || element.type == 4
                                        ? true
                                        : false,
                                isCorporate:
                                    element.type == 3 || element.type == 4
                                        ? true
                                        : false),
                      ));
                    }
                    return list;
                  }
                }
              } else {
                var respo = await API().getData(context, 'package');
                if (respo != null) {
                  List<PackagesModel> packagesModel = List<PackagesModel>.from(
                      respo.map((i) => PackagesModel.fromJson(i)));
                  List<MyData> list = [];
                  for (var element in packagesModel) {
                    list.add(MyData(
                      service: element.packageType.toString(),
                      screen: PackageDescriptionPage(
                          packagesModel: element,
                          showCalculator: element.type == 3 || element.type == 4
                              ? true
                              : false,
                          isCorporate: element.type == 3 || element.type == 4
                              ? true
                              : false),
                    ));
                  }
                  return list;
                }
              }
            },
            service: "Corporate Package",
          ),
          MyData(
            apiFunc: () async {
              IndividualPackagesListModel? individualPackagesListModel;
              String token = sharedPrefs.getFromDevice('token') ?? 'empty';
              if (token != 'empty') {
                var resp = await API()
                    .getData(context, endpoints.getIndividualPackageEndpoint);
                if (resp != null) {
                  individualPackagesListModel =
                      IndividualPackagesListModel.fromJson(resp);
                  var respo = await API().getData(context, 'package');
                  if (respo != null) {
                    List<PackagesModel> packagesModel =
                        List<PackagesModel>.from(
                            respo.map((i) => PackagesModel.fromJson(i)));
                    List<MyData> list = [];
                    for (var element in packagesModel) {
                      list.add(MyData(
                        service: element.packageType.toString(),
                        screen: individualPackagesListModel.myPackage != null
                            ? const MainHomePage(index: 2, tabIndex: 0)
                            : PackageDescriptionPage(
                                packagesModel: element,
                                showCalculator:
                                    element.type == 3 || element.type == 4
                                        ? true
                                        : false,
                                isCorporate:
                                    element.type == 3 || element.type == 4
                                        ? true
                                        : false),
                      ));
                    }
                    return list;
                  }
                }
              } else {
                var respo = await API().getData(context, 'package');
                if (respo != null) {
                  List<PackagesModel> packagesModel = List<PackagesModel>.from(
                      respo.map((i) => PackagesModel.fromJson(i)));
                  List<MyData> list = [];
                  for (var element in packagesModel) {
                    list.add(MyData(
                      service: element.packageType.toString(),
                      screen: PackageDescriptionPage(
                          packagesModel: element,
                          showCalculator: element.type == 3 || element.type == 4
                              ? true
                              : false,
                          isCorporate: element.type == 3 || element.type == 4
                              ? true
                              : false),
                    ));
                  }
                  return list;
                }
              }
            },
            service: "School Package",
          ),
        ],
      ),
    ],
    "Clinical Queries": [
      ChatbotModel(
        title: "Here are the results on Clinical Queries",
        data: [
          MyData(
            apiFunc: () async {
              List<GetSymptomsModel> getSymptomsModel = [];
              var resp =
                  await API().getData(context, endpoints.getSymptomsEndpoint);
              if (resp != null) {
                getSymptomsModel = List<GetSymptomsModel>.from(
                    resp.map((i) => GetSymptomsModel.fromJson(i)));

                List<MyData> list = [];
                for (var element in getSymptomsModel) {
                  list.add(MyData(
                    id: element.id,
                    service: element.name.toString(),
                  ));
                }
                return list;
              }
            },
            service: "Find Doctors by symptoms",
          ),
        ],
      ),
    ],
    // "Lab services": [
    //   ChatbotModel(
    //     title: 'Do you want to navigate to Lab Services screen?',
    //     data: [
    //       MyData(
    //         screen: const LabServices(),
    //         service: "View Details",
    //       ),
    //     ],
    //   ),
    // ]
  };
  List<ChatbotModel> list = mapChatName[value]!;
  return list;
}

chatApiMap(context, value, apiFunc) async {
  List<MyData> list = await apiFunc();
  Map<String, List<ChatbotModel>> mapChatName = {
    'Family Package': [
      ChatbotModel(
        data: list,
        title: "Here are the results on $value.",
      )
    ],
    'Corporate Package': [
      ChatbotModel(
        data: list,
        title: "Here are the results on $value.",
      )
    ],
    'School Package': [
      ChatbotModel(
        data: list,
        title: "Here are the results on $value.",
      )
    ],
    "Find Doctors by symptoms": [
      ChatbotModel(
        data: list,
        isSelectable: true,
        title: "Choose any 5 symptoms from below: ",
      )
    ],
    "Other Services": [
      ChatbotModel(
        title: 'Here are our Other Services.',
        data: list,
      ),
    ],
    "Technical Queries": [
      ChatbotModel(
        title: 'View frequently asked question',
        data: list,
      ),
    ],
  };
  List<ChatbotModel> myList = mapChatName[value]!;
  return myList;
}
