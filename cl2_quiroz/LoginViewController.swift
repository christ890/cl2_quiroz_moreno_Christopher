//
//  ViewController.swift
//  cl2_quiroz
//
//  Created by DARK NOISE on 31/05/21.
//

import UIKit
import FirebaseAnalytics
import FirebaseAuth

class LoginViewController: UIViewController {
    
    
    @IBOutlet weak var loginStackView: UIStackView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signinButton: UIButton!
    @IBOutlet weak var resetPassLoginButton: UIButton!
    
    
    override func viewDidLoad() {
        
        Analytics.logEvent("InitScreen", parameters: ["message" : "Integración de Firebase Completa"])
        super.viewDidLoad()
        loginButton.redondeado()
        emailTextField.becomeFirstResponder()
        navigationController?.setNavigationBarHidden(true, animated: false)
        //comprobar inicio de sesión
        let defaults = UserDefaults.standard
        if let email = defaults.value(forKey: "email") as? String{
            self.navigationController?.pushViewController(HomeViewController(email: email), animated: false)
        }
        
        
        
    }
    
    
    @IBAction func loginButtonAction(_ sender: Any) {
        
        loginButton.saltoAnimacion()
        if let email = emailTextField.text, let password = passTextField.text {
            Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
                if let result = result , error == nil {
                    
                    self.emailTextField.text = ""
                    self.passTextField.text = ""
                    self.emailTextField.becomeFirstResponder()
                    let defaults = UserDefaults.standard
                    defaults.setValue(email, forKey: "email")
                    self.navigationController?.pushViewController(HomeViewController(email: result.user.email!), animated: true)
                    
                }else {
                    
                    let alertController = UIAlertController(title: "Atención", message: "Verifique los datos ingresados", preferredStyle: .alert)
                    
                    alertController.addAction(UIAlertAction(title: "Aceptar", style: .default))
                    
                    self.present(alertController, animated: true, completion: nil)
                    
                }
        
            }
        }
    }
    
    @IBAction func signinButtonAction(_ sender: Any) {
        
        self.navigationController?.pushViewController(RegisterViewController(), animated: true)
        
    }
    
    @IBAction func resetPassLoginButtonAction(_ sender: Any) {
      
        view.endEditing(true)
        
        resetPassLoginButton.saltoAnimacion()
        
        //Creamos el UIAlertController
                
                let alert = UIAlertController(title: "Recuperación de Contraseña", message: "Estas seguro de recuperar tu contraseña mediante un enlace enviado al correo que registraste?", preferredStyle: .alert)
                
                //Alert Action para que guarde la tarea
                
                let saveAction = UIAlertAction(title: "Enviar", style: .default) { (action: UIAlertAction) in
                    // Guardar texto de un texfield en el array y recar tabla
                    
                    let textField = alert.textFields!.first
                    let email = textField?.text
                    
                    Auth.auth().languageCode = "es"
                    Auth.auth().sendPasswordReset(withEmail: email!) { error in
                        if error != nil{
                        let alertController = UIAlertController(title: "Atención", message: "No se ha encontrado tu email o ha ocurrido un error al enviar el email a \(email!), vuelve a intentarlo mas tarde", preferredStyle: .alert)
                        
                        alertController.addAction(UIAlertAction(title: "Aceptar", style: .default))
                        
                            self.present(alertController, animated: true, completion: nil)}
                        else {
                            let alertController = UIAlertController(title: "Envío Exitoso", message: "Se envió email de recuperación al \(email!), revisa tu bandeja de entrada o el apartado de Spam", preferredStyle: .alert)
                            
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

