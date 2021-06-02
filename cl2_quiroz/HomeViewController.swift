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
        
        llenaDatos(emailA: email)
        
    }
   
    func deleteUserDefaults (){
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: "email")
        defaults.synchronize()
    }
    
    func addUserDefaults (email: String){
        self.email = email
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: "email")
        defaults.set(email, forKey: "email")
        defaults.synchronize()
        
    }
    
    func llenaDatos(emailA : String){
        
        db.collection("user").document(emailA).getDocument { (documentSnapshot, error) in
            if let document = documentSnapshot, error == nil {
                
                self.emailHomeTextField.text = emailA
                
                if let name = document.get("name") as? String {
                    self.nameHomeTextField.text = name
                } else { self.nameHomeTextField.text = "" }
                if let phone = document.get("phone") as? String {
                    self.phoneHomeTextField.text = phone
                }else { self.phoneHomeTextField.text = "" }
                if let address = document.get("address") as? String {
                    self.addressHomeTextField.text = address
                }else { self.addressHomeTextField.text = "" }
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
        llenaDatos(emailA: email)
    }
    
    @IBAction func updateHomeButtonAction(_ sender: Any) {
        view.endEditing(true)
        updateHomeButton.saltoAnimacion()
        let emailCaja = emailHomeTextField.text
        let emailGuardado = self.email
        
        if emailCaja != emailGuardado
        {
            Auth.auth().currentUser?.updateEmail(to: emailCaja!, completion: { (error) in
                self.mostrarAlerta(title: "Error", message: "No se pudo actualizar el email \(emailGuardado), intentelo mas adelante", nameButton: "Aceptar")
            })
            db.collection("user").document(emailGuardado).delete()
            deleteUserDefaults()
            addUserDefaults(email: emailCaja!)
            guardaDatos(email: emailCaja!)
            
        }else {
            
            guardaDatos(email: emailGuardado)
            
    }
}
    
    
    @IBAction func deleteHomeButtonAction(_ sender: Any) {
        
        view.endEditing(true)
        deleteHomeButton.saltoAnimacion()
        
        db.collection("user").document(email).delete()
        
    }
    
    func mostrarAlerta(title : String,message : String, nameButton : String){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: nameButton, style: .default))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func guardaDatos (email: String){
        if let name = nameHomeTextField.text,let phone = phoneHomeTextField.text, let address = addressHomeTextField.text{
        db.collection("user").document(email).setData([
            "name" : name,
            "phone" : phone,
            "address":address
        ])
        mostrarAlerta(title: "Actualización Exitosa", message: "Se han actualizado los datos de \(name)", nameButton: "Aceptar")
        } else {
            mostrarAlerta(title: "Campos Incompletos", message: "Para actualizar debe ingresar todos los datos", nameButton: "Aceptar")
        }
    }
    
}
