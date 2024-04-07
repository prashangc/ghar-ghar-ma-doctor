import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ghargharmadoctor/constants/constants_imports.dart';
import 'package:ghargharmadoctor/models/models.dart';
import 'package:ghargharmadoctor/screens/User/side%20navigation/MyLabReports/ReportPdfViewer.dart';
import 'package:ghargharmadoctor/widgets/widgets_import.dart';

class CompanyDocuments extends StatefulWidget {
  final ProfileModel profileModel;
  const CompanyDocuments({super.key, required this.profileModel});

  @override
  State<CompanyDocuments> createState() => _CompanyDocumentsState();
}

class _CompanyDocumentsState extends State<CompanyDocuments>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          decoration: BoxDecoration(
              color: kWhite.withOpacity(0.4),
              borderRadius: const BorderRadius.all(Radius.circular(10.0))),
          margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
          child: Column(
            children: [
              sideNavList(
                FontAwesomeIcons.filePdf,
                'Company Registration Paper',
                14.0,
                () {
                  goThere(
                      context,
                      ReportPdfViewer(
                        url: widget.profileModel.schoolProfile!.paperWorkPdfPath
                            .toString(),
                        type: 'pdf',
                        appBar: 'Company Registration',
                        fileName: widget
                            .profileModel.schoolProfile!.paperWorkPdf
                            .toString(),
                      ));
                },
              ),
              sideNavList(
                FontAwesomeIcons.filePdf,
                'Pan Card',
                14.0,
                () {
                  goThere(
                      context,
                      ReportPdfViewer(
                        url: widget.profileModel.schoolProfile!.paperWorkPdfPath
                            .toString(),
                        type: 'pdf',
                        appBar: 'Pan Card',
                        fileName: widget
                            .profileModel.schoolProfile!.paperWorkPdf
                            .toString(),
                      ));
                },
                showDivider: false,
              ),
            ],
          ),
        ),
        Container(),
      ],
    );
  }
}
