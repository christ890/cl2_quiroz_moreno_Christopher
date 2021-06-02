//
//  HomeViewController.swift
//  cl2_quiroz
//
//  Created by DARK NOISE on 31/05/21.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class HomeViewController: UIViewController {
    
    private var email : String
    private let db = Firestore.firestore()
    
    init(email: String) {
        self.email = email
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    
    @IBOutlet weak var nameHomeTextField: UITextField!
    @IBOutlet weak var phoneHomeTextField: UITextField!
    @IBOutlet weak var addressHomeTextField: UITextField!
    @IBOutlet weak var emailHomeTextField: UITextField!
    @IBOutlet weak var updateHomeButton: UIButton!
    @IBOutlet weak var deleteHomeButton: UIButton!
    @IBOutlet weak var refreshHomeButton: UIButton!
    @IBOutlet weak var logoutHomeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Inicio"
        
        updateHomeButton.redondeado()
        deleteHomeButton.redondeado()
        refreshHomeButton.redondeado()
        logoutHomeButton.redondeado()
        
        navigationItem.setHidesBackButton(true, animated: false)
        
        llenaDatos()
        
    }
   
    func deleteUserDefaults (){
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: "email")
        defaults.synchronize()
    }
    
    func addUserDefaults (email: String){
        
        let userDefaults = UserDefaults.standard
        userDefaults.set(email, forKey: "email")
        userDefaults.synchronize()
        
    }
    
    func llenaDatos(){
        
        db.collection("user").document(email).getDocument { (documentSnapshot, error) in
            if let document = documentSnapshot, error == nil {
                
                self.emailHomeTextField.text = self.email
                
                if let name = document.get("name") as? String {
                    self.nameHomeTextField.text = name
                }
                if let phone = document.get("phone") as? String {
                    self.phoneHomeTextField.text = phone
                }
                if let address = document.get("address") as? String {
                    self.addressHomeTextField.text = address
                }
            }
        }
        
    }
    

    @IBAction func logoutHomeButtonAction(_ sender: Any) {
        
        logoutHomeButton.saltoAnimacion()
        
        deleteUserDefaults()
        
        do {
                    try Auth.auth().signOut()
                    navigationController?.popViewController(animated: true)
                } catch {
                    // Se ha producido un error
                    let alertController = UIAlertController(title: "Error", message: "Se ha producido un error al cerrar su sesión, vuelva a intentarlo en unos momentos", preferredStyle: .alert)
                    
                    alertController.addAction(UIAlertAction(title: "Aceptar", style: .default))
                    
                    self.present(alertController, animated: true, completion: nil)                }
    }
    
    
    @IBAction func refreshHomeButtonAction(_ sender: Any) {
        llenaDatos()
    }
    
    @IBAction func updateHomeButtonAction(_ sender: Any) {
        view.endEditing(true)
        updateHomeButton.saltoAnimacion()
        
        if emailHomeTextField.text != email
        {
            let antiguoEmail = self.email
            let nuevoEmail = emailHomeTextField.text
            Auth.auth().currentUser?.updateEmail(to: nuevoEmail!, completion: { (error) in
                let alertController = UIAlertController(title: "Error", message: "No se pudo actualizar el email \(antiguoEmail), intentelo mas adelante", preferredStyle: .alert)
                
                alertController.addAction(UIAlertAction(title: "Aceptar", style: .default))
                
                self.present(alertController, animated: true, completion: nil)
            })
            db.collection("user").document(antiguoEmail).delete()
            deleteUserDefaults()
            addUserDefaults(email: nuevoEmail!)
            if let name = nameHomeTextField.text,let phone = phoneHomeTextField.text, let address = addressHomeTextField.text{
                db.collection("user").document(nuevoEmail!).setData([
                "name" : name,
                "phone" : phone,
                "address":address
            ])
                let alertController = UIAlertController(title: "Actualización Exitosa", message: "Se han actualizado los datos de \(name)", preferredStyle: .alert)
                
                alertController.addAction(UIAlertAction(title: "Aceptar", style: .default))
                
                self.present(alertController, animated: true, completion: nil)
            } else {
                let alertController = UIAlertController(title: "Campos Incompletos", message: "Para actualizar debe ingresar todos los datos", preferredStyle: .alert)
                
                alertController.addAction(UIAlertAction(title: "Aceptar", style: .default))
                
                self.present(alertController, animated: true, completion: nil)
            }
            
            
        }else {
            if let name = nameHomeTextField.text,let phone = phoneHomeTextField.text, let address = addressHomeTextField.text{
            db.collection("user").document(email).setData([
                "name" : name,
                "phone" : phone,
                "address":address
            ])
                let alertController = UIAlertController(title: "Actualización Exitosa", message: "Se han actualizado los datos de \(name)", preferredStyle: .alert)
                
                alertController.addAction(UIAlertAction(title: "Aceptar", style: .default))
                
                self.present(alertController, animated: true, completion: nil)
            } else {
                let alertController = UIAlertController(title: "Campos Incompletos", message: "Para actualizar debe ingresar todos los datos", preferredStyle: .alert)
                
                alertController.addAction(UIAlertAction(title: "Aceptar", style: .default))
                
                self.present(alertController, animated: true, completion: nil)
            }
    }
}
    
    
    @IBAction func deleteHomeButtonAction(_ sender: Any) {
        
        view.endEditing(true)
        deleteHomeButton.saltoAnimacion()
        
        db.collection("user").document(email).delete()
        
    }
    
}
