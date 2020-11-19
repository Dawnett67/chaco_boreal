import 'dart:typed_data';

class Figuras {
  String _id, _nombre, _descripcion;
  Uint8List _imagen;

  Figuras(this._id, this._descripcion, this._nombre, this._imagen);

  String get id =>_id;

  String get nombre => _nombre;

  String get descripcion => this._descripcion;

  Uint8List get imagen => this._imagen;

  // Convert a Note object into a Map object
  Map<String, dynamic> toMap() {

    var map = Map<String, dynamic>();
    if (id != null) {
      map['id'] = _id;
    }

    map['nombre'] = _nombre;
    map['descripcion'] = _descripcion;
    map['imagen'] = _imagen;

    return map;
  }

  // Extract a Note object from a Map object
  Figuras.fromMapObject(Map<String, dynamic> map) {

    this._id = map['id'];
    this._nombre = map['nombre'];
    this._descripcion = map['descripcion'];
    this._imagen = map['imagen'];

  }

}