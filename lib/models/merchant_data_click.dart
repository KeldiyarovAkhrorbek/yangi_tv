class MerchantDataClick {
  final int serviceId;
  final int merchantId;

  MerchantDataClick({required this.serviceId, required this.merchantId});

  factory MerchantDataClick.fromJson(Map<String, dynamic> json) {
    return MerchantDataClick(
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
