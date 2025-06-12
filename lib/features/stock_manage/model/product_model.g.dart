// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProductModelAdapter extends TypeAdapter<ProductModel> {
  @override
  final int typeId = 2;

  @override
  ProductModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProductModel(
      id: fields[0] as String,
      productName: fields[1] as String,
      productCategory: fields[2] as String,
      productBrand: fields[3] as String,
      productQuantity: fields[4] as int,
      productCode: fields[5] as String,
      purchaseRate: fields[6] as double,
      salePrice: fields[7] as double,
      description: fields[8] as String,
      image1: fields[9] as String?,
      image2: fields[10] as String?,
      image3: fields[11] as String?,
      createdDate: fields[12] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, ProductModel obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.productName)
      ..writeByte(2)
      ..write(obj.productCategory)
      ..writeByte(3)
      ..write(obj.productBrand)
      ..writeByte(4)
      ..write(obj.productQuantity)
      ..writeByte(5)
      ..write(obj.productCode)
      ..writeByte(6)
      ..write(obj.purchaseRate)
      ..writeByte(7)
      ..write(obj.salePrice)
      ..writeByte(8)
      ..write(obj.description)
      ..writeByte(9)
      ..write(obj.image1)
      ..writeByte(10)
      ..write(obj.image2)
      ..writeByte(11)
      ..write(obj.image3)
      ..writeByte(12)
      ..write(obj.createdDate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
