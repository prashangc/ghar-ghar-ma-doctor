import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ghargharmadoctor/api/api_imports.dart';
import 'package:ghargharmadoctor/constants/constants_imports.dart';
import 'package:ghargharmadoctor/models/models.dart';
import 'package:ghargharmadoctor/screens/User/home/ChatBot/MappingChat.dart';
import 'package:ghargharmadoctor/screens/User/home/LabServices/LabServices.dart';
import 'package:ghargharmadoctor/screens/User/home/OurServices/IndividualServicePage.dart';
import 'package:ghargharmadoctor/screens/User/home/TopDoctors/FilterAllDoctor.dart';
import 'package:ghargharmadoctor/screens/User/side%20navigation/FAQ/Faq.dart';
import 'package:ghargharmadoctor/widgets/widgets_import.dart';

class Chatbot extends StatefulWidget {
  const Chatbot({super.key});

  @override
  State<Chatbot> createState() => _ChatbotState();
}

class _ChatbotState extends State<Chatbot> {
  ProfileModel? profileModel;
  StateHandlerBloc chatStateBloc = StateHandlerBloc();
  StateHandlerBloc addValueToListBloc = StateHandlerBloc();
  StateHandlerBloc hideListBloc = StateHandlerBloc();
  int backCount = 2;
  List<ChatbotModel> testList = [];
  List<int> listToShowUserChat = [];
  List<String> listToAddUserText = [];
  StateHandlerBloc mainListBloc = StateHandlerBloc();
  StateHandlerBloc selectedSympListBloc = StateHandlerBloc();
  List<String> selectedId = [];
  List<String> listOfSelectedSymptoms = [];
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    testList.clear();
    testList.add(ChatbotModel(loading: false));
    Future.delayed(const Duration(seconds: 1), () {
      testList.removeAt(0);
      addDataToList("init");
    });
    listToShowUserChat.clear();
    listToAddUserText.clear();
    var test = sharedPrefs.getFromDevice("userProfile");
    profileModel = ProfileModel.fromJson(json.decode(test));
    // _scrollController.addListener(() {
    //   print(';asd');
    //   if (_scrollController.position.pixels ==
    //       _scrollController.position.maxScrollExtent) {

    //   }
    // });
  }

  addDataToList(value, {remove}) async {
    if (value != 'init' && remove == null) {
      await Future.delayed(const Duration(seconds: 1), () {
        testList.removeLast();
      });
    }
    if (value == 'init' && remove != null) {
      testList.addAll(chatMap(context, value));
    } else {
      testList.addAll(chatMap(context, value, refresh: true));
      // testList[testList.length - 1].data!.add(MyData(service: 'No queries'));
    }
    mainListBloc.storeData('refresh');
  }

  showloading() {
    testList.add(ChatbotModel(loading: false));
    mainListBloc.storeData('refresh');
  }

  addApiDataToList(context, value, apiFunc) async {
    await Future.delayed(const Duration(seconds: 1), () {
      testList.removeLast();
    });
    testList.addAll(await chatApiMap(context, value, apiFunc));
    mainListBloc.storeData('refresh');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: myCustomAppBar(
        title: 'Customer Service',
        color: backgroundColor,
        borderRadius: 12.0,
        showHomeIcon: Container(),
      ),
      body: Container(
        width: maxWidth(context),
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        decoration: BoxDecoration(
          color: myColor.dialogBackgroundColor,
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(25),
            topLeft: Radius.circular(25),
          ),
        ),
        child: StreamBuilder<dynamic>(
            initialData: 0,
            stream: chatStateBloc.stateStream,
            builder: (c, s) {
              return s.data == 0
                  ? chatHomeScreen(context)
                  : chatListScreen(context);
            }),
      ),
    );
  }

  Widget chatHomeScreen(context) {
    return Column(
      children: [
        Expanded(child: chatbotCard(context)),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox12(),
            socialMediaCard(context),
            const SizedBox12(),
            Text(
              'Support',
              style: kStyleNormal.copyWith(
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox12(),
            supportCard(context),
            const SizedBox16(),
          ],
        ),
      ],
    );
  }

  Widget chatListScreen(context) {
    return Column(
      children: [
        const SizedBox16(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text.rich(
              TextSpan(
                text: 'I\'m your\n',
                style: kStyleNormal.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                ),
                children: <InlineSpan>[
                  TextSpan(
                    text: 'Digital Assistance',
                    style: kStyleNormal.copyWith(
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                StreamBuilder<dynamic>(
                    stream: mainListBloc.stateStream,
                    builder: (c, s) {
                      return testList.length > 1
                          ? GestureDetector(
                              onTap: () {
                                mySnackbar.mySnackBarCustomized(
                                    context, 'Start from beginning ?', 'Ok',
                                    () {
                                  // hideListBloc.storeData(null);
                                  // testList.clear();
                                  // listOfSelectedSymptoms.clear();
                                  // listToShowUserChat.clear();
                                  // listToAddUserText.clear();
                                  // setState(() {
                                  //   backCount = backCount + 2;
                                  // });
                                  // addDataToList('init');
                                  // hideListBloc.storeData('Continue');
                                  // listToShowUserChat.add(myIndex);
                                  // listToAddUserText.add('Continue');
                                  addDataToList(
                                    'init',
                                    remove: false,
                                  );
                                  mainListBloc.storeData('refresh');
                                }, Colors.black.withOpacity(0.7));
                              },
                              child: Container(
                                padding: const EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                  color: kWhite.withOpacity(0.4),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  FontAwesomeIcons.repeat,
                                  color: myColor.primaryColorDark,
                                  size: 14.0,
                                ),
                              ),
                            )
                          : Container();
                    }),
                const SizedBox(width: 8.0),
                GestureDetector(
                  onTap: () {
                    chatStateBloc.storeData(0);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: kWhite.withOpacity(0.4),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      FontAwesomeIcons.xmark,
                      color: myColor.primaryColorDark,
                      size: 14.0,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox24(),
        Expanded(
          child: myChatListView(context),
        ),
      ],
    );
  }

  Widget myChatListView(context) {
    return StreamBuilder<dynamic>(
        initialData: '',
        stream: mainListBloc.stateStream,
        builder: (mainListBlocContext, mainListBlocSnapshot) {
          if (mainListBlocSnapshot.data != '') {
            _scrollController.animateTo(
              _scrollController.position.maxScrollExtent,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
            );
          }

          return ListView.builder(
              physics: const BouncingScrollPhysics(),
              controller: _scrollController,
              itemCount: testList.length,
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              itemBuilder: (c, i) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 16.0),
                  child: Column(
                    children: [
                      doctorMsgCard(i),
                      listToShowUserChat.contains(i)
                          ? userMsgCard(i)
                          : Container(),
                    ],
                  ),
                );
              });
        });
  }

  Widget doctorMsgCard(myIndex) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 45.0,
              height: 45.0,
              decoration: BoxDecoration(
                color: kWhite.withOpacity(0.4),
                shape: BoxShape.circle,
              ),
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Image.asset(
                  'assets/doctor.png',
                  width: 45.0,
                  height: 45.0,
                ),
              ),
            ),
            const SizedBox(width: 12.0),
            testList[myIndex].loading != null
                ? Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12.0, vertical: 14.0),
                    decoration: BoxDecoration(
                      color: kWhite.withOpacity(0.4),
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(12.0),
                        topRight: Radius.circular(12.0),
                        bottomRight: Radius.circular(12.0),
                      ),
                    ),
                    alignment: Alignment.centerLeft,
                    child: const ChatLoading())
                : Flexible(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12.0, vertical: 14.0),
                      decoration: BoxDecoration(
                        color: kWhite.withOpacity(0.4),
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(12.0),
                          topRight: Radius.circular(12.0),
                          bottomRight: Radius.circular(12.0),
                        ),
                      ),
                      child: Text(
                        testList[myIndex].title.toString(),
                        style: kStyleNormal.copyWith(
                          fontSize: 12.0,
                        ),
                      ),
                    ),
                  ),
            const SizedBox(width: 12.0),
            testList.length > 1 &&
                    (testList.length - 1) == myIndex &&
                    testList[testList.length - 1].isFirst == null
                ? testList[myIndex].loading != null
                    ? Container()
                    : GestureDetector(
                        onTap: () {
                          hideListBloc.storeData("empty");
                          listToShowUserChat.add(myIndex);
                          listToAddUserText.add('empty');
                          if ((testList.length - backCount) == 0) {
                            testList.add(
                              ChatbotModel(
                                isFirst: true,
                                title:
                                    'Want more guidance? Please select from options below.',
                                data: [
                                  MyData(
                                    service: "Primary Packages",
                                  ),
                                  MyData(
                                    apiFunc: () async {
                                      List<OurServicesModel> ourServicesModel =
                                          [];
                                      var resp = await API().getData(context,
                                          endpoints.getOurServicesEndpoint);
                                      if (resp != null) {
                                        ourServicesModel =
                                            List<OurServicesModel>.from(
                                                resp.map((i) =>
                                                    OurServicesModel.fromJson(
                                                        i)));
                                        List<MyData> list = [];

                                        for (var element in ourServicesModel) {
                                          list.add(MyData(
                                            screen: IndividualServicePage(
                                                ourServiceModel: element),
                                            id: element.id,
                                            service:
                                                element.serviceTitle.toString(),
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
                                      var resp = await API().getData(
                                          context, endpoints.getFaqEndpoint);
                                      if (resp != null) {
                                        getFaqModel = List<GetFaqModel>.from(
                                            resp.map((i) =>
                                                GetFaqModel.fromJson(i)));

                                        List<MyData> list = [];
                                        for (var element in getFaqModel) {
                                          list.add(
                                            MyData(
                                              service:
                                                  element.question.toString(),
                                              answer: element.answer.toString(),
                                              screen:
                                                  Faq(getFaqModel: getFaqModel),
                                            ),
                                          );
                                        }
                                        return list;
                                      }
                                    },
                                    service: "Technical Queries",
                                  ),
                                  MyData(
                                    service: "No queries",
                                  ),
                                ],
                              ),
                            );
                          } else {
                            testList.add(testList[testList.length - backCount]);
                          }
                          mainListBloc.storeData('refresh');
                          setState(() {
                            backCount = backCount + 2;
                          });
                        },
                        child: SizedBox(
                          width: 45.0,
                          height: 45.0,
                          child: Icon(
                            Icons.arrow_upward,
                            size: 22.0,
                            color: myColor.primaryColorDark,
                          ),
                        ),
                      )
                : const SizedBox(
                    width: 45.0,
                    height: 45.0,
                  ),
          ],
        ),
        testList[myIndex].loading != null ? Container() : const SizedBox8(),
        testList[myIndex].loading != null
            ? Container()
            : Padding(
                padding: const EdgeInsets.only(left: 45.0 + 12.0),
                child: StreamBuilder<dynamic>(
                    initialData: null,
                    stream: hideListBloc.stateStream,
                    builder: (hideListContext, hideListSnapshot) {
                      return hideListSnapshot.data == null
                          ? testList[myIndex].isSelectable != null
                              ? Column(
                                  children: [
                                    Wrap(
                                      direction: Axis.horizontal,
                                      alignment: WrapAlignment.start,
                                      spacing: 10.0,
                                      runSpacing: 10.0,
                                      children: List.generate(
                                          testList[myIndex].data!.length,
                                          (ix) => selectSymptomsCard(
                                              testList[myIndex].data![ix])),
                                    ),
                                    const SizedBox2(),
                                    StreamBuilder<dynamic>(
                                        initialData: selectedId,
                                        stream:
                                            selectedSympListBloc.stateStream,
                                        builder: (sContext, sSnapshot) {
                                          return sSnapshot.data.isEmpty
                                              ? Container()
                                              : Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    GestureDetector(
                                                      onTap: () {
                                                        symptomBtn(
                                                            myIndex, context);
                                                      },
                                                      child: CircleAvatar(
                                                        backgroundColor: myColor
                                                            .primaryColorDark,
                                                        child: Icon(
                                                          FontAwesomeIcons
                                                              .arrowRight,
                                                          size: 18.0,
                                                          color: kWhite,
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                );
                                        })
                                  ],
                                )
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    testList[myIndex].disclaimer != null
                                        ? Text(
                                            '* This is machine generated response. Please refer actual doctor for precise advice.',
                                            style: kStyleNormal.copyWith(
                                              fontSize: 12.0,
                                              color: kRed,
                                              fontWeight: FontWeight.bold,
                                            ))
                                        : Container(),
                                    testList[myIndex].disclaimer != null
                                        ? const SizedBox8()
                                        : Container(),
                                    Wrap(
                                      direction: Axis.horizontal,
                                      alignment: WrapAlignment.start,
                                      spacing: 10.0,
                                      runSpacing: 10.0,
                                      children: List.generate(
                                        testList[myIndex].data!.length,
                                        (ix) => testList[myIndex]
                                                            .data![ix]
                                                            .service !=
                                                        null &&
                                                    testList[myIndex]
                                                            .data![ix]
                                                            .service!
                                                            .length >
                                                        3 &&
                                                    testList[myIndex]
                                                            .data![ix]
                                                            .service!
                                                            .substring(0, 4) ==
                                                        'View' ||
                                                testList[myIndex]
                                                        .data![ix]
                                                        .service ==
                                                    "View All FAQ"
                                            ? Container(
                                                margin: const EdgeInsets.only(
                                                    bottom: 10.0),
                                                child: Row(
                                                  children: [
                                                    GestureDetector(
                                                      onTap: () {
                                                        var screen = testList[
                                                                testList.length -
                                                                    1]
                                                            .data![0]
                                                            .screen;
                                                        goThere(
                                                            context, screen);
                                                      },
                                                      child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      6.0),
                                                          color: myColor
                                                              .primaryColorDark,
                                                        ),
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                horizontal:
                                                                    12.0,
                                                                vertical: 8.0),
                                                        child: Row(
                                                          children: [
                                                            Text(
                                                              '${testList[myIndex].data![ix].service} Screen',
                                                              style:
                                                                  kStyleNormal
                                                                      .copyWith(
                                                                fontSize: 10.0,
                                                                color: kWhite,
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                                width: 2),
                                                            Icon(
                                                              Icons
                                                                  .keyboard_arrow_right_outlined,
                                                              size: 13.0,
                                                              color: kWhite,
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 10.0),
                                                    GestureDetector(
                                                      onTap: () {
                                                        hideListBloc.storeData(
                                                            'Continue');
                                                        listToShowUserChat
                                                            .add(myIndex);
                                                        listToAddUserText
                                                            .add('Continue');
                                                        addDataToList(
                                                          'init',
                                                          remove: false,
                                                        );
                                                      },
                                                      child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      6.0),
                                                          color: kWhite
                                                              .withOpacity(0.4),
                                                        ),
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                horizontal:
                                                                    12.0,
                                                                vertical: 8.0),
                                                        child: Text(
                                                          'Continue ?',
                                                          style: kStyleNormal
                                                              .copyWith(
                                                            fontSize: 10.0,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            : GestureDetector(
                                                onTap: () async {
                                                  if (testList[myIndex]
                                                      .data!
                                                      .isEmpty) {
                                                    hideListBloc.storeData(
                                                        "No queries");
                                                    listToShowUserChat
                                                        .add(myIndex);
                                                    listToAddUserText
                                                        .add("No queries");
                                                  } else {
                                                    hideListBloc.storeData(
                                                        testList[myIndex]
                                                            .data![ix]
                                                            .service
                                                            .toString());
                                                    listToShowUserChat
                                                        .add(myIndex);
                                                    listToAddUserText.add(
                                                        testList[myIndex]
                                                            .data![ix]
                                                            .service
                                                            .toString());
                                                  }
                                                  showloading();
                                                  if (testList[myIndex]
                                                          .data![ix]
                                                          .answer !=
                                                      null) {
                                                    hideListBloc.storeData(
                                                        testList[myIndex]
                                                            .data![ix]
                                                            .service
                                                            .toString());
                                                    await Future.delayed(
                                                        const Duration(
                                                            seconds: 1), () {
                                                      testList.removeLast();
                                                    });
                                                    testList.addAll([
                                                      ChatbotModel(
                                                        title: testList[myIndex]
                                                            .data![ix]
                                                            .answer
                                                            .toString(),
                                                        data: [
                                                          MyData(
                                                            service:
                                                                "View All FAQ",
                                                          ),
                                                        ],
                                                      ),
                                                    ]);
                                                    mainListBloc
                                                        .storeData('refresh');
                                                  } else {
                                                    if (testList[myIndex]
                                                            .data![ix]
                                                            .screen !=
                                                        null) {
                                                      await Future.delayed(
                                                          const Duration(
                                                              seconds: 1), () {
                                                        testList.removeLast();
                                                      });

                                                      testList.addAll([
                                                        ChatbotModel(
                                                          title:
                                                              'Do you want to navigate to ${testList[myIndex].data![ix].service} screen?',
                                                          data: [
                                                            MyData(
                                                              screen: testList[
                                                                      myIndex]
                                                                  .data![ix]
                                                                  .screen,
                                                              service:
                                                                  "View ${testList[myIndex].data![ix].service}",
                                                            ),
                                                          ],
                                                        ),
                                                      ]);

                                                      mainListBloc
                                                          .storeData('refresh');
                                                    } else {
                                                      if (testList[myIndex]
                                                              .data![ix]
                                                              .apiFunc !=
                                                          null) {
                                                        addApiDataToList(
                                                            context,
                                                            testList[myIndex]
                                                                .data![ix]
                                                                .service
                                                                .toString(),
                                                            testList[myIndex]
                                                                .data![ix]
                                                                .apiFunc);
                                                      } else {
                                                        addDataToList(
                                                            testList[myIndex]
                                                                .data![ix]
                                                                .service
                                                                .toString());
                                                      }
                                                    }
                                                  }
                                                },
                                                child: testList[myIndex]
                                                            .data![ix]
                                                            .service ==
                                                        null
                                                    ? Container()
                                                    : Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      6.0),
                                                          color: kWhite
                                                              .withOpacity(0.4),
                                                        ),
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                horizontal:
                                                                    12.0,
                                                                vertical: 8.0),
                                                        child: Text(
                                                          testList[myIndex]
                                                              .data![ix]
                                                              .service
                                                              .toString(),
                                                          style: kStyleNormal
                                                              .copyWith(
                                                            fontSize: 10.0,
                                                          ),
                                                        ),
                                                      ),
                                              ),
                                      ),
                                    ),
                                  ],
                                )
                          : Container();
                    }),
              ),
      ],
    );
  }

  symptomBtn(myIndex, context) async {
    showloading();
    String mySymptoms = '';
    for (int i = 0; i < listOfSelectedSymptoms.length; i++) {
      if (i == (listOfSelectedSymptoms.length - 1)) {
        mySymptoms = '$mySymptoms${listOfSelectedSymptoms[i]}.';
      } else if (listOfSelectedSymptoms.length > 2 &&
          i == (listOfSelectedSymptoms.length - 2)) {
        mySymptoms = '$mySymptoms${listOfSelectedSymptoms[i]} and ';
      } else {
        mySymptoms = '$mySymptoms${listOfSelectedSymptoms[i]}, ';
      }
    }
    hideListBloc.storeData(listOfSelectedSymptoms.length == 1
        ? 'Your selected symptoms is $mySymptoms'
        : 'Your selected symptoms are $mySymptoms');
    listToShowUserChat.add(myIndex);
    listToAddUserText.add(listOfSelectedSymptoms.length == 1
        ? 'Your selected symptoms is $mySymptoms'
        : 'Your selected symptoms are $mySymptoms');
    var resp = await API().getPostResponseData(
        context,
        PostSearchBySymptomsModel(symptoms: ['$selectedId']),
        endpoints.postSearchBySymptomsEndpoint);
    List<FilteredDepartmentModel> filteredDepartmentModel =
        List<FilteredDepartmentModel>.from(
            resp.map((e) => FilteredDepartmentModel.fromJson(e)));
    if (filteredDepartmentModel.isEmpty) {
      await Future.delayed(const Duration(seconds: 1), () {
        testList.removeLast();
      });
      testList.addAll([
        ChatbotModel(
          title: 'No any doctors found for selected symptoms.',
          data: [],
        ),
      ]);
      testList.add(testList[testList.length - 2]);
    } else {
      List<MyData> list = [];

      for (var element in filteredDepartmentModel) {
        list.add(MyData(
            id: element.id,
            service: element.department.toString(),
            screen: FilterAllDoctors(
              context: context,
              symptomID: element.id,
            )));
      }
      await Future.delayed(const Duration(seconds: 1), () {
        testList.removeLast();
      });
      testList.addAll([
        ChatbotModel(
            title: 'Select the following deparment to find doctors.',
            data: list,
            disclaimer:
                'This is machine generated suggestions, please refer doctor for precise advice.'),
      ]);
    }

    mainListBloc.storeData('refresh');
  }

  Widget selectSymptomsCard(MyData data) {
    return GestureDetector(
      onTap: () {
        if (selectedId.contains(data.id.toString())) {
          selectedId.remove(data.id.toString());
          listOfSelectedSymptoms.remove(data.service);
        } else {
          selectedId.add(data.id!.toString());
          listOfSelectedSymptoms.add(data.service!);
        }

        selectedSympListBloc.storeData(selectedId);
      },
      child: StreamBuilder<dynamic>(
          initialData: selectedId,
          stream: selectedSympListBloc.stateStream,
          builder: (sContext, sSnapshot) {
            return Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6.0),
                  color: kWhite.withOpacity(0.4),
                  border: Border.all(
                      color: sSnapshot.data.contains(data.id.toString())
                          ? myColor.primaryColorDark
                          : kTransparent,
                      width: 1.0)),
              padding:
                  const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
              child: Text(
                data.service.toString(),
                style: kStyleNormal.copyWith(
                  fontSize: 10.0,
                  color: sSnapshot.data.contains(data.id.toString())
                      ? myColor.primaryColorDark
                      : kBlack,
                ),
              ),
            );
          }),
    );
  }

  Widget userMsgCard(myIndex) {
    return SizedBox(
      width: maxWidth(context),
      child: listToAddUserText[myIndex] == 'empty'
          ? Container()
          : Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const SizedBox(width: 45.0, height: 45.0),
                  const SizedBox(width: 12.0),
                  Flexible(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12.0, vertical: 14.0),
                      decoration: BoxDecoration(
                        color: myColor.primaryColorDark,
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(12.0),
                          topLeft: Radius.circular(12.0),
                          bottomRight: Radius.circular(12.0),
                        ),
                      ),
                      child: Text(
                        listToAddUserText[myIndex].toString(),
                        overflow: TextOverflow.clip,
                        style: kStyleNormal.copyWith(
                          fontSize: 12.0,
                          color: kWhite,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12.0),
                  profileModel!.imagePath == null
                      ? Container(
                          width: 45.0,
                          height: 45.0,
                          decoration: BoxDecoration(
                            color: kWhite.withOpacity(0.4),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              profileModel!.member!.name!
                                  .substring(0, 1)
                                  .capitalize(),
                              style: kStyleNormal.copyWith(
                                color: myColor.primaryColorDark,
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        )
                      : myCachedNetworkImageCircle(
                          45.0,
                          45.0,
                          profileModel!.imagePath,
                          BoxFit.cover,
                        ),
                ],
              ),
            ),
    );
  }

  Widget chatbotCard(context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            children: [
              const SizedBox16(),
              Text(
                'Hello,',
                style: kStyleNormal.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                ),
              ),
              const SizedBox2(),
              Text(
                profileModel!.member!.name.toString().capitalize(),
                style: kStyleNormal.copyWith(
                  fontSize: 22.0,
                  color: myColor.primaryColorDark,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox24(),
              Text(
                'How can we help you today?',
                style: kStyleNormal.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                ),
              ),
              const SizedBox12(),
              Text(
                'We are at your service 24 * 7',
                style: kStyleNormal.copyWith(
                  fontSize: 12.0,
                ),
              ),
              const SizedBox12(),
              Expanded(
                child: Hero(
                  tag: 'chatbot',
                  child: Image.asset(
                    'assets/chatbot.gif',
                  ),
                ),
              ),
              const SizedBox12(),
            ],
          ),
        ),
        Column(
          children: [
            myCustomButton(
              context,
              myColor.primaryColorDark,
              'Click Here To Start Converstation',
              kStyleNormal.copyWith(color: kWhite, fontSize: 14.0),
              () {
                chatStateBloc.storeData(1);
              },
            ),
          ],
        ),
      ],
    );
  }
}
