//
//  ViewController.swift
//  Homework
//
//  Created by admin on 12/21/17.
//  Copyright © 2017 Xiaoming Yu. All rights reserved.
//

import UIKit
import FirebaseAuth

class MainViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var logoImg: UIImageView!
    @IBOutlet var emailTxt: UITextField!
    @IBOutlet var passwordTxt: UITextField!
    @IBOutlet var logInBtn: UIButton!
    @IBOutlet var signUpBtn: UIButton!
    @IBOutlet var loading: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red:0.90, green:0.90, blue:0.90, alpha:1.0)
        self.logoImg.image = UIImage(named: "homework-logo.jpeg")?.stretchableImage(withLeftCapWidth: 0, topCapHeight: 0)
        emailTxt.delegate = self
        passwordTxt.delegate = self
        logInBtn.layer.borderColor = UIColor.white.cgColor
        logInBtn.layer.borderWidth = 1
        logInBtn.layer.masksToBounds = true
        signUpBtn.layer.borderColor = UIColor.white.cgColor
        signUpBtn.layer.borderWidth = 1
        signUpBtn.layer.masksToBounds = true
        self.loading.isHidden = true
    }

    @IBAction func doLogIn(_ sender: Any) {
        self.loading.isHidden = false
        self.loading.startAnimating()
        Auth.auth().signIn(withEmail: emailTxt.text!, password: passwordTxt.text!) { (user, error) in
            if user != nil{
                
                if let user = Auth.auth().currentUser {
                    if !user.isEmailVerified{
                        let alert = UIAlertController(title: "Error", message: "Sorry. Your email address has not yet been verified. Please check your email for verification", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self.present(alert, animated: true)
                        self.loading.stopAnimating()
                        self.loading.isHidden = true
                        return
                    } else {
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SignUpVC") as? SignUpViewController
                        self.navigationController?.pushViewController(vc!, animated: false)
                        self.loading.stopAnimating()
                        self.loading.isHidden = true
                        print ("Email verified. Signing in...")
                        print("Firebase Login Success")
                    }
                }
            }
            else{
                print(error?.localizedDescription as Any)
                let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                
                self.present(alertController, animated: true, completion: nil)
                self.loading.stopAnimating()
                self.loading.isHidden = true
            }
        }

    }
    
    @IBAction func goSignUp(_ sender: Any) {
        guard let uvc = self.storyboard?.instantiateViewController(withIdentifier: "SignUpVC") else {
            return
        }
        self.navigationController?.pushViewController(uvc, animated: false)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if(textField == emailTxt){
            passwordTxt.becomeFirstResponder()
        }else if(textField == passwordTxt){
            textField.endEditing(true)
        }
        return true
    }
    
}

