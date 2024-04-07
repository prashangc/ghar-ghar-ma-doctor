class PaymentMethods {
  String? imageUrl;
  String? name;

  PaymentMethods({this.imageUrl, this.name});
}

List<PaymentMethods> paymentMethods = [
  PaymentMethods(
    imageUrl: 'assets/esewa.png',
    name: 'esewa',
  ),
  PaymentMethods(
    imageUrl: 'assets/khalti.png',
    name: 'khalti',
  ),
  PaymentMethods(
    imageUrl: 'assets/fonePay.png',
    name: 'fonepay',
  ),
  PaymentMethods(
    imageUrl: 'assets/imePay.png',
    name: 'ime',
  ),
  PaymentMethods(
    imageUrl: 'assets/connectIPS.png',
    name: 'connectIPS',
  ),
  PaymentMethods(
    imageUrl: 'assets/prabhuPay.png',
    name: 'prabhu',
  ),
];
