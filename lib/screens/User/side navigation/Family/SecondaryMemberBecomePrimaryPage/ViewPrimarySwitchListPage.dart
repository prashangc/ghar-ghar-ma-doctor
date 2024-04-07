import 'package:flutter/material.dart';
import 'package:ghargharmadoctor/api/api_imports.dart';
import 'package:ghargharmadoctor/constants/constants_imports.dart';
import 'package:ghargharmadoctor/models/models.dart';
import 'package:ghargharmadoctor/screens/User/side%20navigation/MyLabReports/ReportPdfViewer.dart';
import 'package:ghargharmadoctor/widgets/widgets_import.dart';

class ViewPrimarySwitchListPage extends StatefulWidget {
  const ViewPrimarySwitchListPage({super.key});

  @override
  State<ViewPrimarySwitchListPage> createState() =>
      _ViewPrimarySwitchListPageState();
}

class _ViewPrimarySwitchListPageState extends State<ViewPrimarySwitchListPage> {
  ApiHandlerBloc? requestBloc;
  @override
  void initState() {
    super.initState();
    requestBloc = ApiHandlerBloc();
    requestBloc!
        .fetchAPIList(endpoints.getBecomeSecondaryToPrimaryMemberEndpoint);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: backgroundColor,
      appBar: myCustomAppBar(
        title: 'Request List',
        color: backgroundColor,
        borderRadius: 0.0,
      ),
      body: Container(
        margin: const EdgeInsets.only(top: 10.0),
        width: maxWidth(context),
        height: maxHeight(context),
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 15.0),
        decoration: BoxDecoration(
          color: myColor.dialogBackgroundColor,
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(25),
            topLeft: Radius.circular(25),
          ),
        ),
        child: StreamBuilder<ApiResponse<dynamic>>(
          stream: requestBloc!.apiListStream,
          builder: ((c, snapshot) {
            if (snapshot.hasData) {
              switch (snapshot.data!.status) {
                case Status.LOADING:
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20.0),
                    width: maxWidth(context),
                    height: maxHeight(context) / 4,
                    decoration: BoxDecoration(
                      color: myColor.dialogBackgroundColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const AnimatedLoading(),
                  );
                case Status.COMPLETED:
                  if (snapshot.data!.data.isEmpty) {
                    return Container(
                        height: maxHeight(context) / 4,
                        margin: const EdgeInsets.symmetric(horizontal: 16.0),
                        decoration: BoxDecoration(
                          color: kWhite,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Center(child: Text('No image added')));
                  }
                  List<SecondaryMemberGetPrimaryMemberRequestModel>
                      secondaryMemberGetPrimaryMemberRequestModel =
                      List<SecondaryMemberGetPrimaryMemberRequestModel>.from(
                          snapshot.data!.data.map((i) =>
                              SecondaryMemberGetPrimaryMemberRequestModel
                                  .fromJson(i)));
                  return ListView.builder(
                      itemCount:
                          secondaryMemberGetPrimaryMemberRequestModel.length,
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (ctx, i) {
                        return requestCard(
                          context,
                          secondaryMemberGetPrimaryMemberRequestModel[i],
                        );
                      });
                case Status.ERROR:
                  return Container(
                    width: maxWidth(context),
                    margin: const EdgeInsets.symmetric(horizontal: 16.0),
                    height: 135.0,
                    decoration: BoxDecoration(
                      color: kWhite.withOpacity(0.4),
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
      ),
    );
  }

  Widget myRow(title, value) {
    return Row(
      children: [
        Text(
          '$title : ',
          style: kStyleNormal.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 12.0,
          ),
        ),
        Text(
          value,
          overflow: TextOverflow.ellipsis,
          maxLines: 5,
          style: kStyleNormal.copyWith(
            fontSize: 12.0,
          ),
        ),
      ],
    );
  }

  Widget requestCard(
      context, SecondaryMemberGetPrimaryMemberRequestModel data) {
    return Container(
      decoration: BoxDecoration(
        color: kWhite.withOpacity(0.4),
        borderRadius: const BorderRadius.all(
          Radius.circular(12.0),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      margin: const EdgeInsets.only(bottom: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          dateDetails(data),
          changeDetails(data),
          currentPrimaryDetails(data),
          newPrimaryDetails(data),
          data.deathCase == 0 ? Container() : deathCertificateDetails(data),
          statusDetails(data),
        ],
      ),
    );
  }

  Widget dateDetails(SecondaryMemberGetPrimaryMemberRequestModel data) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Requested Date :',
              style: kStyleNormal.copyWith(
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              data.createdAt!.substring(0, 10),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              style: kStyleNormal.copyWith(
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox2(),
        const SizedBox2(),
        Divider(
          color: myColor.dialogBackgroundColor,
        ),
        const SizedBox2(),
        const SizedBox2(),
      ],
    );
  }

  Widget changeDetails(SecondaryMemberGetPrimaryMemberRequestModel data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Change Details',
          style: kStyleNormal.copyWith(
            fontSize: 14.0,
            color: myColor.primaryColorDark,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox12(),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            myCachedNetworkImage(
              60.0,
              60.0,
              data.newprimary!.imagePath,
              const BorderRadius.all(
                Radius.circular(8.0),
              ),
              BoxFit.cover,
            ),
            const SizedBox(width: 12.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  myRow('Family Name', data.familyname!.familyName.toString()),
                  const SizedBox2(),
                  const SizedBox2(),
                  myRow('Relation', data.familyRelation.toString()),
                  const SizedBox2(),
                  const SizedBox2(),
                  myRow('Change Reason', data.changeReason.toString()),
                  const SizedBox2(),
                  const SizedBox2(),
                ],
              ),
            ),
            const SizedBox(width: 12.0),
          ],
        ),
        const SizedBox2(),
        const SizedBox2(),
        Divider(color: myColor.dialogBackgroundColor),
        const SizedBox2(),
        const SizedBox2(),
      ],
    );
  }

  Widget currentPrimaryDetails(
      SecondaryMemberGetPrimaryMemberRequestModel data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Current Primary Member',
          style: kStyleNormal.copyWith(
            fontSize: 14.0,
            color: myColor.primaryColorDark,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox12(),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            myCachedNetworkImage(
              60.0,
              60.0,
              data.primary!.imagePath,
              const BorderRadius.all(
                Radius.circular(8.0),
              ),
              BoxFit.cover,
            ),
            const SizedBox(width: 12.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  // myRow('Name', data.primary!.user!.name.toString()),
                  SizedBox2(),
                  SizedBox2(),
                  // myRow('Email', data.primary!.user!.email.toString()),
                  SizedBox2(),
                  SizedBox2(),
                  // myRow('Phone', data.primary!.user!.phone.toString()),
                  SizedBox2(),
                  SizedBox2(),
                ],
              ),
            ),
            const SizedBox(width: 12.0),
          ],
        ),
        const SizedBox2(),
        const SizedBox2(),
        Divider(color: myColor.dialogBackgroundColor),
        const SizedBox2(),
        const SizedBox2(),
      ],
    );
  }

  Widget newPrimaryDetails(SecondaryMemberGetPrimaryMemberRequestModel data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'New Primary Member',
          style: kStyleNormal.copyWith(
            fontSize: 14.0,
            color: myColor.primaryColorDark,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox12(),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            myCachedNetworkImage(
              60.0,
              60.0,
              data.newprimary!.imagePath,
              const BorderRadius.all(
                Radius.circular(8.0),
              ),
              BoxFit.cover,
            ),
            const SizedBox(width: 12.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  myRow('Name', data.newprimary!.user!.name.toString()),
                  const SizedBox2(),
                  const SizedBox2(),
                  myRow('Email', data.newprimary!.user!.email.toString()),
                  const SizedBox2(),
                  const SizedBox2(),
                  myRow('Phone', data.newprimary!.user!.phone.toString()),
                  const SizedBox2(),
                  const SizedBox2(),
                ],
              ),
            ),
            const SizedBox(width: 12.0),
          ],
        ),
        const SizedBox2(),
        const SizedBox2(),
        Divider(color: myColor.dialogBackgroundColor),
        const SizedBox2(),
        const SizedBox2(),
      ],
    );
  }

  Widget deathCertificateDetails(
      SecondaryMemberGetPrimaryMemberRequestModel data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Death Certificate',
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
          style: kStyleNormal.copyWith(
            color: myColor.primaryColorDark,
            fontWeight: FontWeight.bold,
            fontSize: 14.0,
          ),
        ),
        const SizedBox12(),
        GestureDetector(
          onTap: () {
            goThere(
                context,
                ReportPdfViewer(
                  url: data.deathCertificatePath.toString(),
                  type: 'image',
                  appBar: 'Death Certificate',
                  fileName: data.deathCertificate.toString(),
                ));
          },
          child: Container(
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(
                  Radius.circular(8.0),
                ),
                border:
                    Border.all(color: myColor.dialogBackgroundColor, width: 1)),
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            margin: const EdgeInsets.only(bottom: 12.0),
            width: maxWidth(context),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Hero(
                  tag: 'imageHero',
                  child: myCachedNetworkImage(
                    30.0,
                    30.0,
                    data.deathCertificatePath,
                    const BorderRadius.all(
                      Radius.circular(2.0),
                    ),
                    BoxFit.cover,
                  ),
                ),
                Expanded(
                  child: ListTile(
                    title: Text(
                      data.deathCertificate.toString(),
                      overflow: TextOverflow.ellipsis,
                      style: kStyleNormal.copyWith(
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const Icon(
                  Icons.visibility,
                  size: 20.0,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget statusDetails(SecondaryMemberGetPrimaryMemberRequestModel data) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          'Status :',
          style: kStyleNormal.copyWith(
            fontSize: 14.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 12.0),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
          decoration: BoxDecoration(
            color: data.status == 0
                ? myColor.primaryColorDark
                : data.status == 1
                    ? kGreen
                    : kRed.withOpacity(0.9),
            borderRadius: const BorderRadius.all(
              Radius.circular(5.0),
            ),
          ),
          child: Text(
            data.status == 0
                ? 'Pending'
                : data.status == 1
                    ? 'Approved'
                    : 'Rejected',
            textAlign: TextAlign.center,
            style: kStyleNormal.copyWith(
              fontSize: 10.0,
              color: myColor.scaffoldBackgroundColor,
            ),
          ),
        )
      ],
    );
  }
}
