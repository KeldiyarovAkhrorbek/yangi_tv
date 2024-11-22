class MerchantDataPayme {
  final String? serviceId;
  final String? merchantId;

  MerchantDataPayme({required this.serviceId, required this.merchantId});

  factory MerchantDataPayme.fromJson(Map<String, dynamic> json) {
    return MerchantDataPayme(
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
