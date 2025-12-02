class PaymentInformationModel {
  final String orderType;
  final double amount;
  final String orderDescription;
  final String name;

  PaymentInformationModel({
    required this.orderType,
    required this.amount,
    required this.orderDescription,
    required this.name,
  });

  Map<String, dynamic> toJson() {
    return {
      'orderType': orderType,
      'amount': amount,
      'orderDescription': orderDescription,
      'name': name,
    };
  }
}