import 'dart:io';
import 'package:ghargharmadoctor/constants/constants_imports.dart';
import 'package:ghargharmadoctor/models/InvoiceModel/InvoiceModel.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:pdf/widgets.dart' as pw;

class PdfInvoiceApi {
  static Future<File> generate(InvoiceModel invoice) async {
    final pdf = Document();

    pdf.addPage(MultiPage(
      build: (context) => [
        buildHeader(invoice),
        SizedBox(height: 3 * PdfPageFormat.cm),
        buildTitle(),
        buildInvoice(invoice),
        Divider(),
        buildTotal(),
      ],
      footer: (context) => buildFooter(),
    ));

    return FileApi.saveDocument(name: '${invoice.fileName}.pdf', pdf: pdf);
  }

  static Widget buildHeader(InvoiceModel invoice) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 1 * PdfPageFormat.cm),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildSupplierAddress(),
              Container(
                height: 50,
                width: 50,
                child: BarcodeWidget(
                  barcode: Barcode.qrCode(),
                  data: 'hello barcode',
                ),
              ),
            ],
          ),
          Divider(),
          SizedBox(height: 1 * PdfPageFormat.cm),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildCustomerAddress(invoice),
              buildInvoiceInfo(invoice),
            ],
          ),
        ],
      );

  static Widget buildCustomerAddress(InvoiceModel invoice) => Expanded(
      flex: 1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Name: ${invoice.name}',
              style: TextStyle(fontWeight: FontWeight.bold)),
          Text('Phone: ${invoice.phone}'),
          invoice.invoiceType != 'Order'
              ? Container()
              : Text('Address: ${invoice.address}',
                  overflow: TextOverflow.clip),
        ],
      ));

  static Widget buildInvoiceInfo(InvoiceModel invoice) {
    final titles = <String>['Invoice Number:', 'Emailed To:', 'Invoice Date:'];

    return Expanded(
      flex: 1,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Invoice Number: #123423452',
            style: TextStyle(fontWeight: FontWeight.bold)),
        Text('Emailed to: ${invoice.email.toString()}'),
        Text('Invoice Date: ${invoice.date.toString()}'),
      ]),
    );
  }

  static Widget buildSupplierAddress() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('GharGharMaDoctor Pvt.Ltd.',
              style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 1 * PdfPageFormat.mm),
          Text('Email: ghargharmadoctor@gmail.com'),
          SizedBox(height: 1 * PdfPageFormat.mm),
          Text('VAT No:606601586'),
        ],
      );

  static Widget buildTitle() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'INVOICE',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 0.8 * PdfPageFormat.cm),
          Text('Invoice details are given below:'),
          SizedBox(height: 0.8 * PdfPageFormat.cm),
        ],
      );

  static Widget buildInvoice(InvoiceModel invoice) {
    List<String>? headers = [];
    List<List<dynamic>> data = [];
    if (invoice.invoiceType == 'Order') {
      headers = [
        'S.N.',
        'Product Name',
        'Quantity',
        'Unit Price',
        'VAT',
        'Total'
      ];

      data = invoice.items!.map((item) {
        double unitPriceTest = double.parse(item.totalPrice.toString()) /
            double.parse(item.quantity.toString());
        String unitPrice = unitPriceTest.round().toString();
        return [
          '1',
          item.itemName,
          item.quantity,
          unitPrice,
          item.vat,
          item.totalPrice,
        ];
      }).toList();
    } else {
      if (invoice.invoiceType == 'Lab') {
        headers = [
          'S.N.',
          'Name',
          'Reporting Date',
          'Lab Charge',
          'VAT',
          'Total'
        ];
      } else if (invoice.invoiceType == 'Package') {
        headers = [
          'S.N.',
          'Name',
          'Booked Date',
          'Monthly Fee',
          'VAT',
          'Total'
        ];
      } else {
        headers = [
          'S.N.',
          'Name',
          'Apointment Date',
          'Consultant Fee',
          'VAT',
          'Total'
        ];
      }

      data = invoice.items!.map((item) {
        return [
          '1',
          item.consultantName,
          item.appointmentDate,
          item.consultationFee,
          item.vat,
          item.totalPrice,
        ];
      }).toList();
    }

    return Table.fromTextArray(
      headers: headers,
      data: data,
      border: null,
      headerStyle: TextStyle(fontWeight: FontWeight.bold),
      headerDecoration: const BoxDecoration(color: PdfColors.grey300),
      cellHeight: 30,
      cellAlignments: {
        0: Alignment.centerLeft,
        1: Alignment.centerRight,
        2: Alignment.centerRight,
        3: Alignment.centerRight,
        4: Alignment.centerRight,
        5: Alignment.centerRight,
      },
    );
  }

  static Widget buildTotal() {
    // final netTotal = invoice.items
    //     .map((item) => item.estimatedBudget * item.quantity)
    //     .reduce((item1, item2) => item1 + item2);
    // final vatPercent = invoice.items.first.vat;
    // final vat = netTotal * vatPercent;
    // final total = netTotal + vat;

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
                  title: 'Net total',
                  value: 'as', //Utils.formatPrice(vat),
                  unite: true,
                ),
                buildText(
                  title: 'Vat  * 100 %',
                  value: 'as', //Utils.formatPrice(vat),
                  unite: true,
                ),
                Divider(),
                buildText(
                  title: 'Total amount due',
                  titleStyle: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  value: 'as', //Utils.formatPrice(vat),
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

  static Widget buildFooter() => Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Divider(),
          SizedBox(height: 2 * PdfPageFormat.mm),
          buildSimpleText(
              title: 'Address:', value: 'New Baneshworr, Kathmandu, Nepal'),
          SizedBox(height: 1 * PdfPageFormat.mm),
          buildSimpleText(title: 'Website:', value: 'www.ghargharmadoctor.com'),
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
