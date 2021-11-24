//
//  ViewControllerCofigPerfil.swift
//  ProyectoTEC
//
//  Created by Daniel Riojas on 14/10/21.
//
import FirebaseAuth
import FirebaseFirestore
import Firebase
import UIKit

class ViewControllerCofigPerfil: UIViewController {

    @IBOutlet weak var nombre: UITextField!
    @IBOutlet weak var apellidoPat: UITextField!
    @IBOutlet weak var apellidoMat: UITextField!
    @IBOutlet weak var fechaNac: UITextField!
    @IBOutlet weak var email: UITextField!
    
    let db = Firestore.firestore()
    var correo = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        getData()
    // Tap Gesture
    let tap = UITapGestureRecognizer(target: self, action: #selector(quitaTeclado))
    view.addGestureRecognizer(tap)
}

// MARK: - Eliminate Keyboard
@IBAction func quitaTeclado() {
    view.endEditing(true)
}
    
    //MARK: -info correspondiente tf
    func getData() {
        
        let docRef = db.collection("Login").document(correo)

        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let data = document.data()
                self.nombre.text = data?["nombre"] as! String
                self.apellidoPat.text = data?["apellidoPat"] as! String
                self.apellidoMat.text = data?["apellidoMat"] as! String
                self.fechaNac.text = data?["fechaNac"] as! String
                self.email.text = data?["email"] as! String

            } else {
                print("Document does not exist")
            }
        
        }
       
    }
    
    // MARK: - Prep segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vistaCambiarContrasena = segue.destination as! ViewControllerCambiarContrasena
        vistaCambiarContrasena.correo = email.text!
        vistaCambiarContrasena.vista = 1
     }
    
    
    //MARK: -info correspondiente tf
    func updateData() {
        let docRef = db.document("Login/" + correo)
        docRef.getDocument { snapshot, error in
            guard let data = snapshot?.data(), error == nil else {
                 return
            }
            print(data)
        }
        docRef.updateData(["nombre": nombre.text!])
        docRef.updateData(["apellidoPat": apellidoPat.text!])
        docRef.updateData(["apellidoMat": apellidoMat.text!])
        docRef.updateData(["fechaNac": fechaNac.text!])
        docRef.updateData(["email": email.text!])
    
}
    
    
    @IBAction func guardarPressed(_ sender: UIButton) {
        self.updateData()
        print("Success!")
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
