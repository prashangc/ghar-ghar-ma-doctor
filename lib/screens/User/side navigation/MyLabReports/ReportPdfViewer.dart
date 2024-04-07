import 'package:flutter/material.dart';
import 'package:ghargharmadoctor/api/api_imports.dart';
import 'package:ghargharmadoctor/constants/constants_imports.dart';
import 'package:ghargharmadoctor/widgets/widgets_import.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class ReportPdfViewer extends StatefulWidget {
  final String url;
  final String type;
  final String? appBar;
  final String? fileName;

  const ReportPdfViewer(
      {Key? key,
      required this.url,
      required this.type,
      this.fileName,
      this.appBar})
      : super(key: key);

  @override
  _ReportPdfViewerState createState() => _ReportPdfViewerState();
}

class _ReportPdfViewerState extends State<ReportPdfViewer> {
  StateHandlerBloc invoiceLoadingBloc = StateHandlerBloc();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: myCustomAppBar(
        title: widget.appBar ?? 'Your Report',
        color: backgroundColor,
        borderRadius: 12.0,
        showHomeIcon: widget.fileName == null
            ? Container()
            : GestureDetector(
                onTap: () {},
                child: StreamBuilder<dynamic>(
                    stream: invoiceLoadingBloc.stateStream,
                    initialData: 0,
                    builder: (c, s) {
                      if (s.data == 0) {
                        return GestureDetector(
                          onTap: () async {
                            invoiceLoadingBloc.storeData(2);
                            if (await checkStoragePermission(
                                Permission.storage)) {
                              final file = await API().downloadFile(
                                  widget.url.toString(),
                                  widget.fileName.toString());
                            }
                            invoiceLoadingBloc.storeData(1);
                          },
                          child: Container(
                            padding: const EdgeInsets.only(left: 12.0),
                            height: 50.0,
                            child: Icon(
                              Icons.download,
                              size: 25.0,
                              color: myColor.primaryColorDark,
                            ),
                          ),
                        );
                      } else if (s.data == 1) {
                        return Container();
                      } else {
                        return Container(
                            margin:
                                const EdgeInsets.only(left: 12.0, bottom: 12.0),
                            width: 20.0,
                            height: 20.0,
                            child: CircularProgressIndicator(
                              color: myColor.primaryColorDark,
                              backgroundColor: myColor.dialogBackgroundColor,
                              strokeWidth: 1.0,
                            ));
                      }
                    }),
              ),
      ),
      body: Stack(
        children: [
          AnimatedPositioned(
            duration: const Duration(milliseconds: 333),
            curve: Curves.fastOutSlowIn,
            top: 0,
            bottom: 0,
            left: 0,
            right: 0,
            child: InteractiveViewer(
              panEnabled: true,
              minScale: 0.5,
              maxScale: 4,
              child: widget.type == 'pdf'
                  ? SafeArea(
                      child: SfPdfViewer.network(
                        widget.url,
                      ),
                    )
                  : Center(
                      child: Hero(
                        tag: 'imageHero',
                        child: myCachedNetworkImage(
                          maxWidth(context) / 1.1,
                          maxHeight(context) / 2,
                          widget.url,
                          const BorderRadius.all(
                            Radius.circular(8.0),
                          ),
                          BoxFit.cover,
                        ),
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
