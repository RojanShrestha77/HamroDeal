import 'package:equatable/equatable.dart';

class ShippingAddressEntity extends Equatable {
  final String fullName;
  final String phone;
  final String address;
  final String city;
  final String? state;
  final String zipCode;
  final String country;

  const ShippingAddressEntity({
    required this.fullName,
    required this.phone,
    required this.address,
    required this.city,
    this.state,
    required this.zipCode,
    required this.country,
  });

  @override
  List<Object?> get props => [
    fullName,
    phone,
    address,
    city,
    state,
    zipCode,
    country,
  ];
}
