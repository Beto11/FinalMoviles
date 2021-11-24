//
//  ViewControllerRegistrate.swift
//  ProyectoTEC
//
//  Created by user197925 on 10/7/21.
//

import FirebaseAuth
import Firebase
import UIKit

class ViewControllerRegistrate: UIViewController {
    
    @IBOutlet weak var registrate: UIButton! // Button
    
    @IBOutlet weak var tf_correo: UITextField! // Textfield
    @IBOutlet weak var tf_contrasena: UITextField!
    @IBOutlet weak var tf_repiteContrasena: UITextField!
    @IBOutlet weak var tf_nombre: UITextField!
    @IBOutlet weak var tf_apellidoPaterno: UITextField!
    @IBOutlet weak var tf_apellidoMaterno: UITextField!
    @IBOutlet weak var tf_fechaNacimiento: UITextField!
    
    let db = Firestore.firestore()
    var emailIsValid = false
    var datePicker: UIDatePicker?
    var pickerToolbar: UIToolbar?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
     
        
        // Textfield with date
        dateTextfield()
        
        // Button Configuration
        registrate.layer.cornerRadius = 25
        //registrate.addTarget(self, action: #selector(signInGoogle(_:)), for: .touchUpInside)
        
        // TextField Configuration
        tf_contrasena.isSecureTextEntry = true
        tf_repiteContrasena.isSecureTextEntry = true
        
        // Tap Gesture
        let tap = UITapGestureRecognizer(target: self, action: #selector(quitaTeclado))
        view.addGestureRecognizer(tap)

    }
    
    // MARK: - Eliminate Keyboard
    @IBAction func quitaTeclado() {
        view.endEditing(true)
    }
    
    // MARK: - Textfield with date
    func dateTextfield() {
        pickerToolbar = UIToolbar()
        pickerToolbar?.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneBtnClicked(_:)))
        pickerToolbar?.setItems([doneButton], animated: true)
        tf_fechaNacimiento.inputAccessoryView = pickerToolbar
        
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .date
        datePicker?.frame = CGRect(x: 10, y: 50, width: self.view.frame.width, height: 100)
        tf_fechaNacimiento.inputView = datePicker
    }
        
    @objc func doneBtnClicked(_ button: UIBarButtonItem?) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        tf_fechaNacimiento.text = dateFormatter.string(from: datePicker!.date)
        view.endEditing(true)
        }

    
    // MARK: - Email validation
    func isValidEmail(emailID:String) -> Bool {
       let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
       let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
       return emailTest.evaluate(with: emailID)
   }
    
    
    // MARK: - Prepare for segue
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if tf_correo.text! == "" || tf_contrasena.text! == "" || tf_repiteContrasena.text! == "" || tf_nombre.text! == "" || tf_apellidoPaterno.text! == "" || tf_apellidoMaterno.text! == "" || tf_fechaNacimiento.text! == "" {
            let alerta = UIAlertController(title: "Error", message: "Coloca datos en todos los campos", preferredStyle: .alert)
            let accion = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alerta.addAction(accion)
            present(alerta, animated: true, completion: nil)
            return false
        }
        else if (isValidEmail(emailID: tf_correo.text!) == false ) {
            let alerta = UIAlertController(title: "Error", message: "Correo electrónico no es valido", preferredStyle: .alert)
            let accion = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alerta.addAction(accion)
            present(alerta, animated: true, completion: nil)
            return false
        }
        else if (tf_contrasena.text! != tf_repiteContrasena.text!) {
            let alerta = UIAlertController(title: "Error", message: "Las contraseñas no coinciden", preferredStyle: .alert)
            let accion = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alerta.addAction(accion)
            present(alerta, animated: true, completion: nil)
            return false
        }
        else {
            return true
        }
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (sender as! UIButton) == registrate {
            let vistaIni = segue.destination as! ViewController
            vistaIni.correoEletronico = tf_correo.text!
            vistaIni.contrasena = tf_contrasena.text!
        }
    }
    
    //MARK: - add data

    func writeData() {
        let docRef = db.document("Login/" + tf_correo.text!)
        docRef.getDocument { snapshot, error in
            guard let data = snapshot?.data(), error == nil else {
                 return
            }
            print(data)
        }
        docRef.setData(["email": tf_correo.text, "password": tf_contrasena.text, "nombre": tf_nombre.text, "apellidoPat":tf_apellidoPaterno.text, "apellidoMat": tf_apellidoMaterno.text, "fechaNac": tf_fechaNacimiento.text])
    }

    
    //MARK:- database
    @IBAction func registerPressed(_ sender: AnyObject) {
        Auth.auth().createUser(withEmail: tf_correo.text!, password: tf_contrasena.text!) {
            (user, error) in
            
            if error != nil {
                print(error!)
            }
            else {
                self.writeData()
                print("registration successful")
                
            }
        }
    }
    
}
