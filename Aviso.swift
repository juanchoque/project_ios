//
//  File.swift
//  InmoviliariaVirtual
//
//  Created by Juan on 11/22/17.
//  Copyright © 2017 Juan. All rights reserved.
//

import Foundation
import UIKit //libreria grafica de ios

class Aviso{
    var id: Int?
    var titulo: String?
    var descripcion:String?
    var precio:Float?
    var telefono:String?
    var latitud:Double?
    var longitud:Double?
    var estado:String?
    var publicado:Int?
    var imagen:UIImage?
    var direccion:String?
    var fecha:String?
    
    init(id:Int, titulo:String,descripcion:String,precio:Float,telefono:String,latitud:Double,longitud:Double,estado:String,publicado:Int) {
        self.id = id
        self.titulo = titulo
        self.descripcion = descripcion
        self.precio = precio
        self.telefono = telefono
        self.latitud = latitud
        self.longitud = longitud
        self.estado = estado
        self.publicado = publicado
    }
    init(id:Int, titulo:String,descripcion:String,precio:Float,telefono:String,latitud:Double,longitud:Double,estado:String,publicado:Int,imagen:UIImage?) {
        self.id = id
        self.titulo = titulo
        self.descripcion = descripcion
        self.precio = precio
        self.telefono = telefono
        self.latitud = latitud
        self.longitud = longitud
        self.estado = estado
        self.publicado = publicado
        self.imagen = imagen
    }
    init(id:Int, titulo:String,descripcion:String,precio:Float,telefono:String,latitud:Double,longitud:Double,estado:String,publicado:Int,imagen:UIImage?,direccion:String) {
        self.id = id
        self.titulo = titulo
        self.descripcion = descripcion
        self.precio = precio
        self.telefono = telefono
        self.latitud = latitud
        self.longitud = longitud
        self.estado = estado
        self.publicado = publicado
        self.imagen = imagen
        self.direccion = direccion
    }
    init(id:Int, titulo:String,descripcion:String,precio:Float,telefono:String,latitud:Double,longitud:Double,estado:String,publicado:Int,imagen:UIImage?,direccion:String, fecha:String) {
        self.id = id
        self.titulo = titulo
        self.descripcion = descripcion
        self.precio = precio
        self.telefono = telefono
        self.latitud = latitud
        self.longitud = longitud
        self.estado = estado
        self.publicado = publicado
        self.imagen = imagen
        self.direccion = direccion
        self.fecha = fecha
    }
}
