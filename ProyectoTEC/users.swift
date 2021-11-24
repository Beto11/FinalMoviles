//
//  users.swift
//  ProyectoTEC
//
//  Created by user198113 on 11/21/21.
//

import Foundation
import Firebase

class users: ObservableObject{
    
    @Published var listaLogin = [LogIn]()
 
    func updateData(unLogIn: LogIn){
        let db = Firestore.firestore()
        if let docID = unLogIn.ident{
            do {
                try db.collection ("login").document(docID).setData(["nombre": unLogIn.nombre])
                try db.collection ("login").document(docID).setData(["apellidoPat": unLogIn.apellidoPat])
                try db.collection ("login").document(docID).setData(["apellidoMat": unLogIn.apellidoMat])
                try db.collection ("login").document(docID).setData(["fechaNac": unLogIn.fechaNac])
                try db.collection ("login").document(docID).setData(["email": unLogIn.email])
                try db.collection ("login").document(docID).setData(["password": unLogIn.password])
                print("Success")
            }
            catch {
                print ("Error while trying to update \(error.localizedDescription)")
            }
        }
            else {
            print ("Error while trying to update, no id is avaliable")
        }
    }
}

    
    func getData(){
        let db = Firestore.firestore()
        db.collection("Login").order(by: "nombre").getDocuments(){ (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            }else {
                guard let _ = querySnapshot else { return }
                
                self.listaLogin.removeAll()
                
                for document in querySnapshot!.documents{
                    let data = document.data()
                    let nombre = data["nombre"] as! String
                    let apellidoPat = data["apellidoPaterno"] as! String
                    let apellidoMat = data["apellidoMaterno"] as! String
                    let fechaNac = data["fechaNacimiento"] as! String
                    let email = data["email"] as! String
                    let password = data["password"] as! String
                    let ident = document.documentID
                    
                    var nuevoLogin = LogIn()
                    nuevoLogin.apellidoPat=apellidoPat
                    nuevoLogin.apellidoMat=apellidoMat
                    nuevoLogin.nombre=nombre
                    nuevoLogin.fechaNac=fechaNac
                    nuevoLogin.email=email
                    nuevoLogin.password=password
                    
                    //self.listaLogin.append(nuevoLogin)
                    print("Success")
                }
                   //self.tableView.reloadData()
            }
        }
    }
    
}
