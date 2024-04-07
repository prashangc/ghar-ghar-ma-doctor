class BecomeVendorModel {
  String? address;
  String? image;
  String? file;
  String? vendorType;
  String? store;
  String? ird;
  String? tax;
  String? registrationNo;
  String? companyContact;
  String? guarantorName;
  String? guarantorAddress;
  String? guarantorContact;
  String? nominatorName;
  String? nominatorAddress;
  String? nominatorContact;
  String? membershipTimeFrame;
  int? membershipFee;
  String? paymentTimeFrame;
  String? terminationTimeFrame;
  BecomeVendorModel(
      {this.address,
      this.image,
      this.file,
      this.vendorType,
      this.store,
      this.ird,
      this.tax,
      this.registrationNo,
      this.companyContact,
      this.guarantorName,
      this.guarantorAddress,
      this.guarantorContact,
      this.nominatorName,
      this.nominatorAddress,
      this.nominatorContact,
      this.membershipTimeFrame,
      this.membershipFee,
      this.paymentTimeFrame,
      this.terminationTimeFrame});

  BecomeVendorModel.fromJson(Map<String, dynamic> json) {
    address = json['address'];
    image = json['image'];
    file = json['file'];
    vendorType = json['vendor_type'];
    store = json['store_name'];
    ird = json['ird'];
    tax = json['tax'];
    registrationNo = json['registration_no'];
    companyContact = json['company_contact'];
    guarantorName = json['guarantor_name'];
    guarantorAddress = json['guarantor_address'];
    guarantorContact = json['guarantor_contact'];
    nominatorName = json['nominator_name'];
    nominatorAddress = json['nominator_address'];
    nominatorContact = json['nominator_contact'];
    membershipTimeFrame = json['membership_time_frame'];
    membershipFee = json['membership_fee'];
    paymentTimeFrame = json['payment_time_frame'];
    terminationTimeFrame = json['termination_time_frame'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['address'] = address;
    data['image'] = image;
    data['file'] = file;
    data['vendor_type'] = vendorType;
    data['store_name'] = store;
    data['ird'] = ird;
    data['tax'] = tax;
    data['registration_no'] = registrationNo;
    data['company_contact'] = companyContact;
    data['guarantor_name'] = guarantorName;
    data['guarantor_address'] = guarantorAddress;
    data['guarantor_contact'] = guarantorContact;
    data['nominator_name'] = nominatorName;
    data['nominator_address'] = nominatorAddress;
    data['nominator_contact'] = nominatorContact;
    data['membership_time_frame'] = membershipTimeFrame;
    data['membership_fee'] = membershipFee;
    data['payment_time_frame'] = paymentTimeFrame;
    data['termination_time_frame'] = terminationTimeFrame;
    return data;
  }
}
