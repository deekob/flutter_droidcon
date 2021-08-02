/*
* Copyright 2021 Amazon.com, Inc. or its affiliates. All Rights Reserved.
*
* Licensed under the Apache License, Version 2.0 (the "License").
* You may not use this file except in compliance with the License.
* A copy of the License is located at
*
*  http://aws.amazon.com/apache2.0
*
* or in the "license" file accompanying this file. This file is distributed
* on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either
* express or implied. See the License for the specific language governing
* permissions and limitations under the License.
*/

// ignore_for_file: public_member_api_docs

import 'package:amplify_datastore_plugin_interface/amplify_datastore_plugin_interface.dart';
import 'package:flutter/foundation.dart';

/** This is an auto generated class representing the UserProfile type in your schema. */
@immutable
class UserProfile extends Model {
  static const classType = const _UserProfileModelType();
  final String id;
  final String? _userName;
  final String? _email;
  final String? _imageKey;
  final String? _description;

  @override
  getInstanceType() => classType;

  @override
  String getId() {
    return id;
  }

  String get userName {
    try {
      return _userName!;
    } catch (e) {
      throw new DataStoreException(
          DataStoreExceptionMessages
              .codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion: DataStoreExceptionMessages
              .codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString());
    }
  }

  String? get email {
    return _email;
  }

  String? get imageKey {
    return _imageKey;
  }

  String? get description {
    return _description;
  }

  const UserProfile._internal(
      {required this.id, required userName, email, imageKey, description})
      : _userName = userName,
        _email = email,
        _imageKey = imageKey,
        _description = description;

  factory UserProfile(
      {String? id,
      required String userName,
      String? email,
      String? imageKey,
      String? description}) {
    return UserProfile._internal(
        id: id == null ? UUID.getUUID() : id,
        userName: userName,
        email: email,
        imageKey: imageKey,
        description: description);
  }

  bool equals(Object other) {
    return this == other;
  }

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UserProfile &&
        id == other.id &&
        _userName == other._userName &&
        _email == other._email &&
        _imageKey == other._imageKey &&
        _description == other._description;
  }

  @override
  int get hashCode => toString().hashCode;

  @override
  String toString() {
    var buffer = new StringBuffer();

    buffer.write("UserProfile {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("userName=" + "$_userName" + ", ");
    buffer.write("email=" + "$_email" + ", ");
    buffer.write("imageKey=" + "$_imageKey" + ", ");
    buffer.write("description=" + "$_description");
    buffer.write("}");

    return buffer.toString();
  }

  UserProfile copyWith(
      {String? id,
      String? userName,
      String? email,
      String? imageKey,
      String? description}) {
    return UserProfile(
        id: id ?? this.id,
        userName: userName ?? this.userName,
        email: email ?? this.email,
        imageKey: imageKey ?? this.imageKey,
        description: description ?? this.description);
  }

  UserProfile.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        _userName = json['userName'],
        _email = json['email'],
        _imageKey = json['imageKey'],
        _description = json['description'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'userName': _userName,
        'email': _email,
        'imageKey': _imageKey,
        'description': _description
      };

  static final QueryField ID = QueryField(fieldName: "userProfile.id");
  static final QueryField USERNAME = QueryField(fieldName: "userName");
  static final QueryField EMAIL = QueryField(fieldName: "email");
  static final QueryField IMAGEKEY = QueryField(fieldName: "imageKey");
  static final QueryField DESCRIPTION = QueryField(fieldName: "description");
  static var schema =
      Model.defineSchema(define: (ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "UserProfile";
    modelSchemaDefinition.pluralName = "UserProfiles";

    modelSchemaDefinition.authRules = [
      AuthRule(authStrategy: AuthStrategy.PUBLIC, operations: [
        ModelOperation.CREATE,
        ModelOperation.UPDATE,
        ModelOperation.DELETE,
        ModelOperation.READ
      ])
    ];

    modelSchemaDefinition.addField(ModelFieldDefinition.id());

    modelSchemaDefinition.addField(ModelFieldDefinition.field(
        key: UserProfile.USERNAME,
        isRequired: true,
        ofType: ModelFieldType(ModelFieldTypeEnum.string)));

    modelSchemaDefinition.addField(ModelFieldDefinition.field(
        key: UserProfile.EMAIL,
        isRequired: false,
        ofType: ModelFieldType(ModelFieldTypeEnum.string)));

    modelSchemaDefinition.addField(ModelFieldDefinition.field(
        key: UserProfile.IMAGEKEY,
        isRequired: false,
        ofType: ModelFieldType(ModelFieldTypeEnum.string)));

    modelSchemaDefinition.addField(ModelFieldDefinition.field(
        key: UserProfile.DESCRIPTION,
        isRequired: false,
        ofType: ModelFieldType(ModelFieldTypeEnum.string)));
  });
}

class _UserProfileModelType extends ModelType<UserProfile> {
  const _UserProfileModelType();

  @override
  UserProfile fromJson(Map<String, dynamic> jsonData) {
    return UserProfile.fromJson(jsonData);
  }
}
