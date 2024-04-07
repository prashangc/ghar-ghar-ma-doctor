import 'dart:io';
import 'package:flutter/services.dart';
import 'package:ghargharmadoctor/constants/constants_imports.dart';
import 'package:ghargharmadoctor/models/models.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:pdf/widgets.dart' as pw;

class PdfReceipt {
  static Future<File> generatePDF(InvoiceModel invoice) async {
    final pdf = Document();
    final ByteData bytes = await rootBundle.load('assets/logo.png');
    final Uint8List imageBytes = bytes.buffer.asUint8List();
    final primaryColor = PdfColor.fromHex('#135AA7');
    pdf.addPage(MultiPage(
      build: (context) => [
        statusCard(context, primaryColor),
        buildHeader(context, imageBytes, invoice),
        SizedBox(height: 3 * PdfPageFormat.cm),
        buildInvoice(context, primaryColor, invoice),
        Divider(),
        buildTotal(context),
      ],
      footer: (context) => buildFooter(context),
    ));
    return FileApi.saveDocument(name: '${invoice.fileName}.pdf', pdf: pdf);
  }

  static Widget statusCard(context, color) => Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            color: color,
            padding:
                const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
            child: Text('UNPAID',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: PdfColors.white,
                    fontSize: 25.0)),
          ),
        ],
      );
  static Widget buildHeader(context, image, InvoiceModel invoice) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 1 * PdfPageFormat.cm),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                  height: 80,
                  width: 80,
                  child: pw.Image(pw.MemoryImage(image))),
              buildSupplierAddress(context),
            ],
          ),
          SizedBox(height: 1 * PdfPageFormat.cm),
          Container(
              color: PdfColors.grey100,
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              width: PdfPageFormat.a4.width - 2 * PdfPageFormat.cm,
              child: buildInvoiceInfo(context, invoice)),
        ],
      );

  static Widget buildInvoiceInfo(context, InvoiceModel invoice) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('Invoice To :',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0)),
      SizedBox(height: 1 * PdfPageFormat.mm),
      buildSimpleText(title: 'Invoice no :', value: '#50vn7lit'),
      SizedBox(height: 1 * PdfPageFormat.mm),
      buildSimpleText(title: 'Order Date :', value: invoice.date.toString()),
      SizedBox(height: 1 * PdfPageFormat.mm),
      buildSimpleText(title: 'Email :', value: invoice.email.toString()),
      SizedBox(height: 1 * PdfPageFormat.mm),
      buildSimpleText(title: 'ATTN :', value: invoice.name.toString()),
      SizedBox(height: 1 * PdfPageFormat.mm),
      buildSimpleText(title: 'Address :', value: invoice.address.toString()),
    ]);
  }

  static Widget buildSupplierAddress(context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('GharGharMaDoctor Pvt.Ltd.',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          SizedBox(height: 1 * PdfPageFormat.mm),
          Text('VAT No : 606601586'),
          SizedBox(height: 1 * PdfPageFormat.mm),
          Text('Phone : 01-5917322'),
          SizedBox(height: 1 * PdfPageFormat.mm),
          Text('Email : ghargharmadoctor@gmail.com'),
          SizedBox(height: 1 * PdfPageFormat.mm),
          Text('Web : www.ghargharmadoctor.com'),
        ],
      );

  static Widget buildInvoice(context, primaryColor, invoice) {
    List<String>? headers = [];
    List<List<dynamic>> data = [];
    if (invoice.invoiceType == 'Order') {
      headers = ['S.N.', 'Product Name', 'Quantity', 'Unit Price', 'Total'];

      data = invoice.items!.map((item) {
        double unitPriceTest = double.parse(item.totalPrice.toString()) /
            double.parse(item.quantity.toString());
        String unitPrice = unitPriceTest.round().toString();
        return [
          '1',
          item.itemName,
          item.quantity,
          unitPrice,
          item.totalPrice,
        ];
      }).toList();
    } else {
      if (invoice.invoiceType == 'Lab') {
        headers = ['S.N.', 'Name', 'Reporting Date', 'Lab Charge', 'Total'];
      } else if (invoice.invoiceType == 'Package') {
        headers = ['S.N.', 'Name', 'Booked Date', 'Monthly Fee', 'Total'];
      } else {
        headers = [
          'S.N.',
          'Name',
          'Apointment Date',
          'Consultant Fee',
          'Total'
        ];
      }

      data = invoice.items!.map((item) {
        return [
          '1',
          item.consultantName,
          item.appointmentDate,
          item.consultationFee,
          item.totalPrice,
        ];
      }).toList();
    }
    return Table.fromTextArray(
      headers: headers,
      data: data,
      border: null,
      headerStyle:
          TextStyle(fontWeight: FontWeight.bold, color: PdfColors.white),
      headerDecoration: BoxDecoration(color: primaryColor),
      cellHeight: 30,
      cellAlignments: {
        0: Alignment.centerLeft,
        1: Alignment.centerRight,
        2: Alignment.centerRight,
        3: Alignment.centerRight,
        4: Alignment.centerRight,
      },
    );
  }

  static Widget buildTotal(context) {
    return Container(
      alignment: Alignment.centerRight,
      child: Row(
        children: [
          Spacer(flex: 6),
          Expanded(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildText(
                  title: 'Sub Total',
                  value: 'Rs. 1200', //Utils.formatPrice(vat),
                  unite: true,
                ),
                buildText(
                  title: 'VAT (13%)',
                  value: 'Rs. 1356',
                  unite: true,
                ),
                buildText(
                  title: 'Discount Amount',
                  value: 'Rs. 200',
                  unite: true,
                ),
                buildText(
                  title: 'Shipping Charge',
                  value: 'Rs. 200',
                  unite: true,
                ),
                Divider(),
                buildText(
                  title: 'Total',
                  titleStyle: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  value: 'Rs. 2756',
                  unite: true,
                ),
                SizedBox(height: 2 * PdfPageFormat.mm),
                Container(height: 1, color: PdfColors.grey400),
                SizedBox(height: 0.5 * PdfPageFormat.mm),
                Container(height: 1, color: PdfColors.grey400),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Widget buildFooter(context) => Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Divider(),
          SizedBox(height: 2 * PdfPageFormat.mm),
          Text('Thank you for your business !'),
        ],
      );

  static buildSimpleText({
    required String title,
    required String value,
  }) {
    final style = TextStyle(fontWeight: FontWeight.bold);

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: pw.CrossAxisAlignment.end,
      children: [
        Text(title, style: style),
        SizedBox(width: 2 * PdfPageFormat.mm),
        Text(value),
      ],
    );
  }

  static buildText({
    required String title,
    required String value,
    double width = double.infinity,
    TextStyle? titleStyle,
    bool unite = false,
  }) {
    final style = titleStyle ?? TextStyle(fontWeight: FontWeight.bold);

    return Container(
      width: width,
      child: Row(
        children: [
          Expanded(child: Text(title, style: style)),
          Text(value, style: unite ? style : null),
        ],
      ),
    );
  }
}
