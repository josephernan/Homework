//
//  SignUpViewController.swift
//  Homework
//
//  Created by POLARIS on 12/21/17.
//  Copyright © 2017 Xiaoming Yu. All rights reserved.
//

import UIKit
import FirebaseAuth

class SignUpViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var studentNameTxt: UITextField!
    @IBOutlet var gradeTxt: UITextField!
    @IBOutlet var schoolNameTxt: UITextField!
    @IBOutlet var emailTxt: UITextField!
    @IBOutlet var passwordTxt: UITextField!
    @IBOutlet var confirmTxt: UITextField!
    @IBOutlet var submitBtn: UIButton!
    @IBOutlet var checkBox: CheckboxButton!
    @IBOutlet var loading: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red:0.90, green:0.90, blue:0.90, alpha:1.0)
        studentNameTxt.delegate = self
        gradeTxt.delegate = self
        schoolNameTxt.delegate = self
        emailTxt.delegate = self
        passwordTxt.delegate = self
        confirmTxt.delegate = self
        self.navigationItem.title = "New Account"
        self.loading.isHidden = true
        self.submitBtn.isEnabled = false
        
    }
    
    @IBAction func goSignUp(_ sender: Any) {
        self.loading.isHidden = false
        self.loading.startAnimating()
        let validemail = isValidEmail(emailstr: emailTxt.text!)
        
        /////////////////////////////////////////////////////Handle Exception//////////////////////////////////////////////////////////
        if studentNameTxt.text == ""{
            viewAlert(message: "Please enter your student name.")
        }
        else if gradeTxt.text == ""{
            viewAlert(message: "Please enter your grade.")
        }
        else if emailTxt.text == "" || validemail == false{
            viewAlert(message: "Please enter your correct email address.")
        }
        else if schoolNameTxt.text == ""{
            viewAlert(message: "Please enter your school name.")
        }
        else if passwordTxt.text == ""{
            viewAlert(message: "Please enter your password.")
        }
        else if strlen(passwordTxt.text) < 6{
            viewAlert(message: "Password must be 6 character at least.")
        }
        else if confirmTxt.text == ""{
            viewAlert(message: "Please enter your confirm password.")
        }
        else if passwordTxt.text != confirmTxt.text{
            viewAlert(message: "Please check your password setting again.")
        }
        else{
            if emailTxt.text != "" && passwordTxt.text != "" {
                Auth.auth().createUser(withEmail: emailTxt.text!, password: passwordTxt.text!) { (user, error) in
                    if user != nil{
                        
                        print("Firebase SignUp Success")
                        
                        //send verification email to user
                        Auth.auth().languageCode = "es"
                        Auth.auth().currentUser?.sendEmailVerification { (error) in
                            if let error = error{
                                print("send email failed", error)
                                return
                            }
                            
                            //push notification with email verify and go to login page if yes.
                            
                            let alert = UIAlertController(title: nil, message: "SignUp success! Please check your email and try LogIn", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .default) { (_) in
                                self.navigationController?.popViewController(animated: false)
                            })
                            self.loading.stopAnimating()
                            self.loading.isHidden = true
                            self.present(alert, animated: false, completion: nil)
                        }
                        
                    }
                    else{
                        print(error?.localizedDescription as Any)
                        
                        let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                        
                        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                        alertController.addAction(defaultAction)
                        self.loading.stopAnimating()
                        self.loading.isHidden = true
                        self.present(alertController, animated: true, completion: nil)
                    }
                }
            }
        }
    }
    
    @IBAction func goCancel(_ sender: Any) {
        self.navigationController?.popViewController(animated: false)
    }
    
    @IBAction func doCheck(_ sender: CheckboxButton) {
        let state = sender.on ? "Check" : "Uncheck"
        if state == "Check" {
            self.submitBtn.isEnabled = true
        } else if state == "Uncheck" {
            self.submitBtn.isEnabled = false
        }
    }
    
    //show alert with exception
    func viewAlert(message: String) -> Void {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true)
        return
    }
    
    //validate email
    func isValidEmail(emailstr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: emailstr)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (textField == studentNameTxt) {
            gradeTxt.becomeFirstResponder()
        } else if (textField == gradeTxt) {
            schoolNameTxt.becomeFirstResponder()
        } else if (textField == schoolNameTxt) {
            emailTxt.becomeFirstResponder()
        } else if (textField == emailTxt) {
            passwordTxt.becomeFirstResponder()
        } else if (textField == passwordTxt) {
            confirmTxt.becomeFirstResponder()
        } else if (textField == confirmTxt) {
            textField.endEditing(true)
        }
        return true
    }

}
