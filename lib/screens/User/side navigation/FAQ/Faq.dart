import 'package:flutter/material.dart';
import 'package:ghargharmadoctor/api/api_imports.dart';
import 'package:ghargharmadoctor/constants/constants_imports.dart';
import 'package:ghargharmadoctor/models/models.dart';
import 'package:ghargharmadoctor/widgets/widgets_import.dart';

class Faq extends StatefulWidget {
  final List<GetFaqModel>? getFaqModel;
  const Faq({super.key, this.getFaqModel});

  @override
  State<Faq> createState() => _FaqState();
}

class _FaqState extends State<Faq> {
  ApiHandlerBloc? faqBloc;
  @override
  void initState() {
    faqBloc = ApiHandlerBloc();
    if (widget.getFaqModel == null) {
      faqBloc!.fetchAPIList(endpoints.getFaqEndpoint);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: myCustomAppBar(
        borderRadius: 12.0,
        color: backgroundColor,
        title: 'FAQ',
      ),
      body: Container(
          margin: const EdgeInsets.only(top: 10.0),
          width: maxWidth(context),
          height: maxHeight(context),
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
          decoration: BoxDecoration(
            color: myColor.dialogBackgroundColor,
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(25),
              topLeft: Radius.circular(25),
            ),
          ),
          child: Column(
            children: [
              widget.getFaqModel != null
                  ? ListView.builder(
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      itemCount: widget.getFaqModel!.length,
                      itemBuilder: (ctx, i) {
                        return faqCard(widget.getFaqModel![i], i);
                      },
                    )
                  : StreamBuilder<ApiResponse<dynamic>>(
                      stream: faqBloc!.apiListStream,
                      builder: ((context, snapshot) {
                        if (snapshot.hasData) {
                          switch (snapshot.data!.status) {
                            case Status.LOADING:
                              return SizedBox(
                                width: maxWidth(context),
                                height: maxHeight(context) / 2,
                                child: const Center(
                                  child: AnimatedLoading(),
                                ),
                              );
                            case Status.COMPLETED:
                              if (snapshot.data!.data.isEmpty) {
                                return Container(
                                    height: 140,
                                    decoration: BoxDecoration(
                                      color: kWhite,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Center(
                                        child: Text('No any details')));
                              }
                              List<GetFaqModel> getFaqModel =
                                  List<GetFaqModel>.from(snapshot.data!.data
                                      .map((i) => GetFaqModel.fromJson(i)));
                              return ListView.builder(
                                shrinkWrap: true,
                                padding: EdgeInsets.zero,
                                itemCount: getFaqModel.length,
                                itemBuilder: (ctx, i) {
                                  return faqCard(getFaqModel[i], i);
                                },
                              );
                            case Status.ERROR:
                              return Container(
                                width: maxWidth(context),
                                height: 135.0,
                                margin: const EdgeInsets.all(12.0),
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
            ],
          )),
    );
  }

  Widget faqCard(GetFaqModel data, i) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12.0),
      decoration: BoxDecoration(
        color: kWhite.withOpacity(0.4),
        borderRadius: const BorderRadius.all(
          Radius.circular(12.0),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Theme(
        data: Theme.of(context).copyWith(
          unselectedWidgetColor: Colors.black,
          primaryColor: Colors.black,
          dividerColor: Colors.transparent,
        ),
        child: ExpansionTile(
          maintainState: true,
          iconColor: myColor.primaryColorDark,
          childrenPadding: EdgeInsets.zero,
          initiallyExpanded: i == 0 ? true : false,
          tilePadding: EdgeInsets.zero,
          title: MediaQuery.removePadding(
            context: context,
            removeTop: true,
            removeBottom: true,
            child: Text(
              data.question.toString(),
              style: kStyleNormal.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 13.0,
              ),
            ),
          ),
          children: <Widget>[
            Padding(
              padding: EdgeInsets.zero,
              child: htmlText(data.answer.toString()),
            ),
          ],
        ),
      ),
    );
  }
}
