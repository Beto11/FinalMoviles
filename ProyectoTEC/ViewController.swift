//
//  ViewController.swift
//  ProyectoTEC
//
//  Created by user197925 on 10/4/21.
//

import FirebaseAuth
import Firebase
import FirebaseFirestore
import UIKit
import GoogleSignIn
import AuthenticationServices

class ViewController: UIViewController {
    
    @IBOutlet weak var googleSignIn: UIButton! // Button
    @IBOutlet weak var appleSignIn: UIButton!
    @IBOutlet weak var login: UIButton!
    @IBOutlet weak var olvidasteContrasena: UIButton!
    @IBOutlet weak var registrate: UIButton!
    
    @IBOutlet weak var tf_correoElectronico: UITextField! // Textfield
    @IBOutlet weak var tf_contrasena: UITextField!
    
    var correoEletronico = ""
    var contrasena = ""
    var emailIsValid = false
    
    // MARK:- Button action

    @objc func signInGoogle(_ sender: UIButton) {
        GIDSignIn.sharedInstance()?.signIn()
        // Update screen after user successfully signed in
        updateScreen()
    }

    @objc func signOutGoogle(_ sender: UIButton) {
        GIDSignIn.sharedInstance()?.signOut()
        // Update screen after user successfully signed out
        updateScreen()
    }
    
    @objc func signInApple(_ sender: UIButton) {
        let provider = ASAuthorizationAppleIDProvider()
        let request = provider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.presentationContextProvider = self
        controller.performRequests()
    }
    
   
    
    // MARK:- Unwind
    
    @IBAction func unwindRegistrate (segue: UIStoryboardSegue) {
        tf_correoElectronico.text = correoEletronico
        tf_contrasena.text = contrasena
    }
    
    @IBAction func unwindCambiarContrasena (segue: UIStoryboardSegue) {
        tf_correoElectronico.text = correoEletronico
        tf_contrasena.text = contrasena
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        
        if identifier == "login"{
        return false
        }else {
            return true
        }
    }
    //ERROR: manda el segue de olvida contrasena a menu
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "login" {
            let vistaPaciente = segue.destination as! ViewControllerMenu
            vistaPaciente.correo = tf_correoElectronico.text!
                }
        else if segue.identifier == "drlogin"{
                let vistaDr = segue.destination as! ViewControllerDoctorVistaGeneral
                vistaDr.correo = tf_correoElectronico.text!
                }
    }
        
        
        
        
       
     


    
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Button Configuration
        googleSignIn.layer.cornerRadius = 25
        googleSignIn.addTarget(self, action: #selector(signInGoogle(_:)), for: .touchUpInside)
        
        appleSignIn.layer.cornerRadius = 25
        appleSignIn.addTarget(self, action: #selector(signInApple(_:)), for: .touchUpInside)
        
        login.layer.cornerRadius = 25
        
        // TextField Configuration
        tf_contrasena.isSecureTextEntry = true
        
        
        // Let GIDSignIn know that this view controller is presenter of the sign-in sheet
        GIDSignIn.sharedInstance()?.presentingViewController = self
        
        // Register notification to update screen after user successfully signed in
        NotificationCenter.default.addObserver(self, selector: #selector(userDidSignInGoogle(_:)), name: .signInGoogleCompleted, object: nil)
                
        // Update screen base on sign-in/sign-out status (when screen is shown)
        updateScreen()
        
        // Tap Gesture
        let tap = UITapGestureRecognizer(target: self, action: #selector(quitaTeclado))
        view.addGestureRecognizer(tap)
        }
            
        private func updateScreen() {
            if let user = GIDSignIn.sharedInstance()?.currentUser { // User signed in
                print("User signed in")
            }
            else { // User signed out
                print("User signed out")
            }
        }
    
    // MARK: - Eliminate Keyboard
    @IBAction func quitaTeclado() {
        view.endEditing(true)
    }
    
    // MARK: - Notification
        @objc private func userDidSignInGoogle(_ notification: Notification) {
            // Update screen after user successfully signed in
            updateScreen()
        }
    
    //MARK: - Login database
    
    @IBAction func logInPressed(_ sender: Any) {
        //TODO: Log in the user
        Auth.auth().signIn(withEmail: tf_correoElectronico.text!, password: tf_contrasena.text!) {
            (user, error) in
            
            if error != nil {
                print(error!)
            }
            else {
                print("login successfull")
                if self.tf_correoElectronico.text == "dremail@gmail.com"{
                    self.performSegue(withIdentifier: "drlogin", sender: self)
                }else{
                self.performSegue(withIdentifier: "login", sender: self)
                }
            }
        }
    }
    
    
    @IBAction func olvidarPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "contrasena", sender: self)
    }
    
    
    @IBAction func registerPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "registrate", sender: self)
    }
    
}


extension ViewController: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("Failed!")
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
        case let credentials as ASAuthorizationAppleIDCredential:
            let fullName = credentials.fullName?.givenName
            let email = credentials.email!
            let userID = credentials.user
            print("Full name: \(fullName) - UserID: \(userID) - Email: \(email)")
            break
        case let credentials as ASPasswordCredential:
            let password = credentials.password
            print("Password: \(password)")
        
        default:
            break
        }
    }
}

extension ViewController: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return view.window!
    }
}
