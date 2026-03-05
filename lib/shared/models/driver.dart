import 'dart:convert';

import 'package:equatable/equatable.dart';

class Driver extends Equatable {
  final String? driverId;
  final String? fullName;
  final String? phoneNumber;
  final dynamic picture;
  final String? licenseExpireDate;
  final dynamic schoolId;
  final dynamic createdAt;
  final dynamic updatedAt;
  final dynamic deletedAt;
  final dynamic driverLicense;
  final dynamic insuranceDocuments;
  final dynamic school;

  const Driver({
    this.driverId,
    this.fullName,
    this.phoneNumber,
    this.picture,
    this.licenseExpireDate,
    this.schoolId,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.driverLicense,
    this.insuranceDocuments,
    this.school,
  });

  factory Driver.fromMap(Map<String, dynamic> data) => Driver(
    driverId: data['driverId'] as String?,
    fullName: data['fullName'] as String?,
    phoneNumber: data['phoneNumber'] as String?,
    picture: data['picture'] as dynamic,
    licenseExpireDate: data['licenseExpireDate'] as String?,
    schoolId: data['schoolId'] as dynamic,
    createdAt: data['createdAt'] as dynamic,
    updatedAt: data['updatedAt'] as dynamic,
    deletedAt: data['deletedAt'] as dynamic,
    driverLicense: data['driverLicense'] as dynamic,
    insuranceDocuments: data['insuranceDocuments'] as dynamic,
    school: data['school'] as dynamic,
  );

  Map<String, dynamic> toMap() => {
    'driverId': driverId,
    'fullName': fullName,
    'phoneNumber': phoneNumber,
    'picture': picture,
    'licenseExpireDate': licenseExpireDate,
    'schoolId': schoolId,
    'createdAt': createdAt,
    'updatedAt': updatedAt,
    'deletedAt': deletedAt,
    'driverLicense': driverLicense,
    'insuranceDocuments': insuranceDocuments,
    'school': school,
  };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Driver].
  factory Driver.fromJson(String data) {
    return Driver.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Driver] to a JSON string.
  String toJson() => json.encode(toMap());

  Driver copyWith({
    String? driverId,
    String? fullName,
    String? phoneNumber,
    dynamic picture,
    String? licenseExpireDate,
    dynamic schoolId,
    dynamic createdAt,
    dynamic updatedAt,
    dynamic deletedAt,
    dynamic driverLicense,
    dynamic insuranceDocuments,
    dynamic school,
  }) {
    return Driver(
      driverId: driverId ?? this.driverId,
      fullName: fullName ?? this.fullName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      picture: picture ?? this.picture,
      licenseExpireDate: licenseExpireDate ?? this.licenseExpireDate,
      schoolId: schoolId ?? this.schoolId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      driverLicense: driverLicense ?? this.driverLicense,
      insuranceDocuments: insuranceDocuments ?? this.insuranceDocuments,
      school: school ?? this.school,
    );
  }

  @override
  List<Object?> get props {
    return [
      driverId,
      fullName,
      phoneNumber,
      picture,
      licenseExpireDate,
      schoolId,
      createdAt,
      updatedAt,
      deletedAt,
      driverLicense,
      insuranceDocuments,
      school,
    ];
  }
}
