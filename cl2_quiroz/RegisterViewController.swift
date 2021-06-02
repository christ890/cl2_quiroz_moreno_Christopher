//
//  RegisterViewController.swift
//  cl2_quiroz
//
//  Created by DARK NOISE on 31/05/21.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class RegisterViewController: UIViewController {
    
    private let db = Firestore.firestore()
    @IBOutlet weak var nameRegisterTextField: UITextField!
    @IBOutlet weak var emailRegisterTextField: UITextField!
    @IBOutlet weak var passRegisterTextField: UITextField!
    @IBOutlet weak var confirmPassRegisterTextField: UITextField!
    @IBOutlet weak var newRegisterButton: UIButton!
    @IBOutlet weak var linkToLoginRegisterButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newRegisterButton.redondeado()
        navigationItem.setHidesBackButton(true, animated: false)

        
    }

    @IBAction func newRegisterButtonAction(_ sender: Any) {
        
        view.endEditing(true)
        newRegisterButton.saltoAnimacion()
        if let nombre = nameRegisterTextField.text, let email = emailRegisterTextField.text , let pass = passRegisterTextField.text , let confirmpass = confirmPassRegisterTextField.text {
            if pass != confirmpass {
                alerta(titleAlert: "Atención", message: "No coincide la contraseña con la confirmación de la misma, deben ser iguales", textButton: "Aceptar")
            }else {
                Auth.auth().createUser(withEmail: email, password: pass) { (result, error) in
                    if let result = result , error == nil {
                        self.navigationController?.pushViewController(HomeViewController(email: result.user.email!), animated: true)
                    }else{
                        self.alerta(titleAlert: "Error", message: "Ocurrión un error en el servidor, intentelo mas tarde", textButton: "Aceptar")
                    }
                }
                db.collection("user").document(email).setData([
                    "name" : nombre,
                    "phone" : "",
                    "address":""
                ])
            }
        }
        else{
            alerta(titleAlert: "Atención", message: "Todos los campos son obligatorios", textButton: "Aceptar")
        }
        
    }
    
    @IBAction func linkToLoginRegisterButtonAction(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
    func alerta(titleAlert : String,message:String,textButton:String){
        let alertController = UIAlertController(title: titleAlert, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title:textButton, style: .default))
        self.present(alertController, animated: true, completion: nil)
    }
}
