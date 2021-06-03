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
    @IBOutlet weak var changePassHomeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Inicio"
        
        updateHomeButton.redondeado()
        deleteHomeButton.redondeado()
        refreshHomeButton.redondeado()
        logoutHomeButton.redondeado()
        navigationController?.setNavigationBarHidden(false, animated: true)
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
            navigationController?.popViewController(animated: true)?.navigationController?.setNavigationBarHidden(true, animated: false)
                } catch {
                    // Se ha producido un error
                    let alertController = UIAlertController(title: "Error", message: "Se ha producido un error al cerrar su sesión, vuelva a intentarlo en unos momentos", preferredStyle: .alert)
                    
                    alertController.addAction(UIAlertAction(title: "Aceptar", style: .default))
                    
                    self.present(alertController, animated: true, completion: nil)                }
    }
    
    
    @IBAction func refreshHomeButtonAction(_ sender: Any) {
        refreshHomeButton.saltoAnimacion()
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
        
        let alert = UIAlertController(title: "Atención", message: "Esta seguro de eliminar su usuario? Se eliminaran sus datos como su acceso a la aplicación.", preferredStyle: .alert)
        
        
        let deleteAlertAction = UIAlertAction(title: "Si", style: .default) { (action: UIAlertAction ) in
            let user = Auth.auth().currentUser

            user?.delete { error in
              if error == nil {
                self.db.collection("user").document(self.email).delete()
                self.deleteUserDefaults()
                let alertController = UIAlertController(title: "Usuario Eliminado", message: "Su usuario fue eliminado, si desea volver a inciar sesión, creese uno nuevo", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: { (action) in
                    self.navigationController?.popViewController(animated: true)
                }))
                self.present(alertController, animated: true) {
                    self.navigationController?.popViewController(animated: true)
                }
              } else {
                self.mostrarAlerta(title: "Error", message: "Ocurrio un error interno, vuelva a intentarlo mas tarde.", nameButton: "Aceptar")
              }
            }
        }
        alert.addAction(deleteAlertAction)
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
        present(alert, animated: true, completion: nil)
        
        
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
    
    
    @IBAction func changePassHomeButtonAction(_ sender: Any) {
        
        view.endEditing(true)
        changePassHomeButton.saltoAnimacion()
        
        let alert = UIAlertController(title: "Cambio de Contraseña", message: "Ingresa tu nueva contraseña:", preferredStyle: .alert)
        
        //Alert Action para que guarde la tarea
        
        let saveAction = UIAlertAction(title: "Confirmar", style: .default) { (action: UIAlertAction) in
            // Guardar texto de un texfield en el array y recar tabla
            
            let textField = alert.textFields!.first
            let pass = textField?.text
            
           
            Auth.auth().currentUser?.updatePassword(to: pass!) { error in
                if error != nil{
                let alertController = UIAlertController(title: "Atención", message: "Ocurrió un error al actualizar su contraseña, vuelve a intentarlo mas tarde", preferredStyle: .alert)
                
                alertController.addAction(UIAlertAction(title: "Aceptar", style: .default))
                
                    self.present(alertController, animated: true, completion: nil)}
                else {
                    let alertController = UIAlertController(title: "Cambio de Contraseña Exitoso", message: "Se cambio tu contraseña exitosamente", preferredStyle: .alert)
                    
                    alertController.addAction(UIAlertAction(title: "Aceptar", style: .default))
                    
                    self.present(alertController, animated: true, completion: nil)
                }
                
            }
            
        }
        // Creamos el boton cancelar
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel) { (action: UIAlertAction) in
            
        }
        
        //Añadir el textfield al AlertController
        
        alert.addTextField { (textField: UITextField) in
        }
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        //Para visualizar lanzar el UIAlert Controller
        present(alert, animated: true, completion: nil)
        
    }
    
}
