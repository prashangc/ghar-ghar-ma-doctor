import 'dart:io';

import 'package:ghargharmadoctor/constants/constants_imports.dart';
import 'package:ghargharmadoctor/widgets/myLoadingScreen.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart';

class FileApi {
  static Future<File> saveDocument({
    required String name,
    required Document pdf,
  }) async {
    try {
      final bytes = await pdf.save();
      Directory? directory = await getExternalStorageDirectory();
      String newPath = '/storage/emulated/0/Download/GD/';
      directory = Directory(newPath);
      File? file;
      if (await directory.exists()) {
        file = File('${directory.path}$name');
        await file.writeAsBytes(bytes);
      } else {
        await directory.create(recursive: true);
      }

      invoiceBtnBloc.storeData(2);
      myToast.toast('File Downloaded');
      return file!;
    } catch (error) {
      print('pdf downloading error = $error');
      myToast.toast('Download Failure');
      invoiceBtnBloc.storeData(0);
      return File('');
    }
  }

  static Future openFile(File file) async {
    final url = file.path;

    await OpenFile.open(url);
  }
}
            