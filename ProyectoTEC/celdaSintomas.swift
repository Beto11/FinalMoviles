//
//  celdaSintomas.swift
//  ProyectoTEC
//
//  Created by Daniel Riojas on 03/11/21.
//prueba beto xcode
//prueba manuel xcode 2

import UIKit

class celdaSintomas: NSObject {
    var nombre : String
    let respuesta = UISegmentedControl(items: ["Sí", "No "])
    
    init(nombre : String) {
        self.nombre = nombre
    }

}
