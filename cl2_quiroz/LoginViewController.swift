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
    
    
    override func viewDidLoad() {
        
        Analytics.logEvent("InitScreen", parameters: ["message" : "Integración de Firebase Completa"])
        super.viewDidLoad()
        loginButton.redondeado()
        emailTextField.becomeFirstResponder()
        
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
    
}

