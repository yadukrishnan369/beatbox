// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sales_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SalesModelAdapter extends TypeAdapter<SalesModel> {
  @override
  final int typeId = 4;

  @override
  SalesModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SalesModel(
      customerName: fields[0] as String,
      customerPhone: fields[1] as String,
      customerEmail: fields[2] as String,
      invoiceNumber: fields[3] as String,
      billingDate: fields[4] as DateTime,
      cartItems: (fields[5] as List).cast<CartItemModel>(),
      subtotal: fields[6] as double,
      gst: fields[7] as double,
      discount: fields[8] as double,
      grandTotal: fields[9] as double,
    );
  }

  @override
  void write(BinaryWriter writer, SalesModel obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.customerName)
      ..writeByte(1)
      ..write(obj.customerPhone)
      ..writeByte(2)
      ..write(obj.customerEmail)
      ..writeByte(3)
      ..write(obj.invoiceNumber)
      ..writeByte(4)
      ..write(obj.billingDate)
      ..writeByte(5)
      ..write(obj.cartItems)
      ..writeByte(6)
      ..write(obj.subtotal)
      ..writeByte(7)
      ..write(obj.gst)
      ..writeByte(8)
      ..write(obj.discount)
      ..writeByte(9)
      ..write(obj.grandTotal);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SalesModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
