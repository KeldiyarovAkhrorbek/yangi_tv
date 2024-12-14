class MerchantData {
  final int serviceId;
  final int merchantId;

  MerchantData({required this.serviceId, required this.merchantId});

  factory MerchantData.fromJson(Map<String, dynamic> json) {
    return MerchantData(
      serviceId: json['service_id'],
      merchantId: json['merchant_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'service_id': serviceId,
      'merchant_id': merchantId,
    };
  }
}
