//
//  ViewControllerDoctorVistaGeneral.swift
//  ProyectoTEC
//
//  Created by user197925 on 10/25/21.
//

import FirebaseAuth
import FirebaseFirestore
import Firebase
import UIKit

class ViewControllerDoctorVistaGeneral: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    

    @IBOutlet weak var btn_logout: UIButton!
    
    @IBOutlet weak var usuario: UILabel!
   
    let db = Firestore.firestore()
    var correo = ""
    var nombre = ""
    
    let data = ["Alberto", "Manuel", "Leonardo", "Yolanda", "Doctor"]
    var filteredData = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        // Setup Table View
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        filteredData = data
        
        // Image View Configuration
       // imgView.layer.cornerRadius = imgView.frame.height/2
        
        // Button Configuration
        btn_logout.layer.cornerRadius = 25
        getData()
    }
 
    
    func getData() {
        
        let docRef = db.collection("Login").document(correo)

        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let data = document.data()
                self.usuario.text = (data?["nombre"] as! String)

            } else {
                print("Document does not exist")
            }
        
        }
       
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "configDr" {
        let vistaDatos = segue.destination as! ViewControllerCofigPerfil
        vistaDatos.correo = correo
        }
     }

    
@IBAction func configPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "configDr", sender: self)
    }
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - Table View
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "celda", for: indexPath)

        cell.textLabel?.text = filteredData[indexPath.row]
        
        return cell
    }
    
    // MARK: - Search Bar Configuration
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredData = []
        if searchText == "" {
            filteredData = data
        }
        else {
            for paciente in data {
                if paciente.lowercased().contains(searchText.lowercased()) {
                    filteredData.append(paciente)
                }
            }
        }
        self.tableView.reloadData()
    }
    //MARK: - logout databse
    
    @IBAction func logOutPressed(_ sender: Any) {
        //TODO: Log out the user and send them back to WelcomeViewController
        do {
            try Auth.auth().signOut()
            print("Logout successfull")
            self.dismiss(animated: true, completion: nil)
        }
        catch {
            print ("Error, there was a problem singing out")
        }
    }
    }
