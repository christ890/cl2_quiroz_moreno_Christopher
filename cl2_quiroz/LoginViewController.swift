//
//  ViewController.swift
//  cl2_quiroz
//
//  Created by DARK NOISE on 31/05/21.
//

import UIKit
import FirebaseAnalytics

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
    }
    
    
    @IBAction func loginButtonAction(_ sender: Any) {
        
        loginButton.saltoAnimacion()
        
    }
    
    @IBAction func signinButtonAction(_ sender: Any) {
        
    }
    

}

