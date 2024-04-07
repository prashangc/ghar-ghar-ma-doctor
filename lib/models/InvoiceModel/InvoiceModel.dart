class InvoiceModel {
  final String? fileName;
  final String? date;
  final String? address;
  final String? name;
  final String? phone;
  final String? email;
  final String? invoiceType;
  final List<InvoiceDetails>? items;

  InvoiceModel({
    this.fileName,
    this.date,
    this.address,
    this.name,
    this.phone,
    this.email,
    this.items,
    this.invoiceType,
  });
}

class InvoiceDetails {
  final String? itemName;
  final String? unitPrice;
  final String? vat;
  final String? quantity;
  final String? discount;
  final String? deliveryCharge;
  final String? totalPrice;
  final String? consultantName;
  final String? appointmentDate;
  final String? consultationFee;

  const InvoiceDetails({
    this.itemName,
    this.unitPrice,
    this.vat,
    this.quantity,
    this.totalPrice,
    this.discount,
    this.deliveryCharge,
    this.consultantName,
    this.appointmentDate,
    this.consultationFee,
  });
}
