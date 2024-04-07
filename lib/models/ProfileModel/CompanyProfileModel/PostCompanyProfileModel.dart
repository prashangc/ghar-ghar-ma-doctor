class PostCompanyProfileModel {
  String? ownerName;
  String? companyName;
  String? companyAddress;
  String? companyStartDate;
  String? description;
  String? panNumber;
  String? contactNumber;
  String? companyImage;
  String? companyImagePath;
  String? paperWorkPdf;
  String? paperWorkPdfPath;

  PostCompanyProfileModel(
      {this.ownerName,
      this.companyName,
      this.companyAddress,
      this.companyStartDate,
      this.description,
      this.panNumber,
      this.contactNumber,
      this.companyImage,
      this.companyImagePath,
      this.paperWorkPdf,
      this.paperWorkPdfPath});

  PostCompanyProfileModel.fromJson(Map<String, dynamic> json) {
    ownerName = json['owner_name'];
    companyName = json['company_name'];
    companyAddress = json['company_address'];
    companyStartDate = json['company_start_date'];
    description = json['description'];
    panNumber = json['pan_number'];
    contactNumber = json['contact_number'];
    companyImage = json['company_image'];
    companyImagePath = json['company_image_path'];
    paperWorkPdf = json['paper_work_pdf'];
    paperWorkPdfPath = json['paper_work_pdf_path'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['owner_name'] = ownerName;
    data['company_name'] = companyName;
    data['company_address'] = companyAddress;
    data['company_start_date'] = companyStartDate;
    data['description'] = description;
    data['pan_number'] = panNumber;
    data['contact_number'] = contactNumber;
    data['company_image'] = companyImage;
    data['company_image_path'] = companyImagePath;
    data['paper_work_pdf'] = paperWorkPdf;
    data['paper_work_pdf_path'] = paperWorkPdfPath;
    return data;
  }
}
