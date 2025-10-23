// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LoginDataAdapter extends TypeAdapter<LoginData> {
  @override
  final int typeId = 0;

  @override
  LoginData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LoginData(
      email: fields[0] as String,
      password: fields[1] as String,
      rememberMe: fields[2] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, LoginData obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.email)
      ..writeByte(1)
      ..write(obj.password)
      ..writeByte(2)
      ..write(obj.rememberMe);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LoginDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
