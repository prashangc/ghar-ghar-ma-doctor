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

List<PackagePaymentIntervalModel> packagepaymentIntervalListWithoutQuaterly = [
  PackagePaymentIntervalModel(
    id: 1,
    name: 'Monthly',
    month: 1,
    discount: 1,
  ),
];
