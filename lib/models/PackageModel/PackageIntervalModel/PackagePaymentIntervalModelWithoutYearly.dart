class PackagePaymentIntervalModel {
  final int id;
  final String name;
  final int month;
  final double discount;

  PackagePaymentIntervalModel(
      {required this.id,
      required this.name,
      required this.month,
      required this.discount});
}

List<PackagePaymentIntervalModel> packagepaymentIntervalListWithoutYearly = [
  PackagePaymentIntervalModel(
    id: 1,
    name: 'Half Yearly',
    month: 6,
    discount: 0.02,
  ),
  PackagePaymentIntervalModel(
    id: 2,
    name: 'Quaterly',
    month: 3,
    discount: 0.01,
  ),
  PackagePaymentIntervalModel(
    id: 3,
    name: 'Monthly',
    month: 1,
    discount: 1,
  ),
];
