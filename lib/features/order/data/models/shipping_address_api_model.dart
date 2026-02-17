import 'package:hamro_deal/features/order/domain/entities/shipping_address_entity.dart';

class ShippingAddressApiModel {
  final String fullName;
  final String phone;
  final String address;
  final String city;
  final String? state;
  final String zipCode;
  final String country;

  ShippingAddressApiModel({
    required this.fullName,
    required this.phone,
    required this.address,
    required this.city,
    this.state,
    required this.zipCode,
    required this.country,
  });

  factory ShippingAddressApiModel.fromJson(Map<String, dynamic> json) {
    return ShippingAddressApiModel(
      fullName: json['fullName'] as String,
      phone: json['phone'] as String,
      address: json['address'] as String,
      city: json['city'] as String,
      state: json['state'] as String,
      zipCode: json['zipCode'] as String,
      country: json['country'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'phone': phone,
      'address': address,
      'city': city,
      'state': state,
      'zipCode': zipCode,
      'country': country,
    };
  }

  ShippingAddressEntity toEntity() {
    return ShippingAddressEntity(
      fullName: fullName,
      phone: phone,
      address: address,
      city: city,
      zipCode: zipCode,
      country: country,
    );
  }

  factory ShippingAddressApiModel.fromEntity(ShippingAddressEntity entity) {
    return ShippingAddressApiModel(
      fullName: entity.fullName,
      phone: entity.phone,
      address: entity.address,
      city: entity.city,
      state: entity.state,
      zipCode: entity.zipCode,
      country: entity.country,
    );
  }
}
