//
//  TableViewControllerDetallesPaciente.swift
//  ProyectoTEC
//
//  Created by user191778 on 11/8/21.
//
import FirebaseAuth
import FirebaseFirestore
import Firebase
import UIKit

class TableViewControllerDetallesPaciente: UITableViewController {

    @IBOutlet weak var lbl_nombrePaciente: UILabel!
    @IBOutlet weak var lbl_nombre: UILabel!
    @IBOutlet weak var lbl_apellidoPaterno: UILabel!
    @IBOutlet weak var lbl_apellidoMaterno: UILabel!
    @IBOutlet weak var lbl_fechaNacimiento: UILabel!
    
    let db = Firestore.firestore()
    var correo = ""
    
    @IBOutlet weak var img_fotoPaciente: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
    }

    //MARK: -info correspondiente tf
    func getData() {
        
        let docRef = db.collection("Login").document(correo)

        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let data = document.data()
                self.lbl_nombrePaciente.text = data?["nombre"] as! String
                self.lbl_nombre.text = data?["nombre"] as! String
                self.lbl_apellidoPaterno.text = data?["apellidoPat"] as! String
                self.lbl_apellidoMaterno.text = data?["apellidoMat"] as! String
                self.lbl_fechaNacimiento.text = data?["fechaNac"] as! String
                

            } else {
                print("Document does not exist")
            }
        
        }
       
    }
    // MARK: - Table view data source

    

}
