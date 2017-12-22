//
//  SignUpViewController.swift
//  Homework
//
//  Created by POLARIS on 12/21/17.
//  Copyright © 2017 Xiaoming Yu. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class SignUpViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet var studentNameTxt: UITextField!
    @IBOutlet var gradeTxt: UITextField!
    @IBOutlet var selectGrade: UIPickerView!
    @IBOutlet var schoolNameTxt: UITextField!
    @IBOutlet var selectSchool: UIPickerView!
    @IBOutlet var emailTxt: UITextField!
    @IBOutlet var passwordTxt: UITextField!
    @IBOutlet var confirmTxt: UITextField!
    @IBOutlet var submitBtn: UIButton!
    @IBOutlet var cancelBtn: UIButton!
    
    @IBOutlet var checkBox: CheckboxButton!
    @IBOutlet var loading: UIActivityIndicatorView!
    
    var grade = ["P.1", "P.2", "P.3", "P.4", "P.5", "P.6"]
    var school = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let schoolNameFileURL = Bundle.main.path(forResource: "hkname", ofType: "txt")
        do {
            let jsonData = try Data(contentsOf: URL(fileURLWithPath: schoolNameFileURL!), options: .dataReadingMapped)
            let jsonResult = try JSONSerialization.jsonObject(with: jsonData, options: .allowFragments) as! [String]
            for content in jsonResult {
                school.append( content )
            }
        } catch let error as NSError {
            print(error)
        }

        self.view.backgroundColor = UIColor(red:0.90, green:0.90, blue:0.90, alpha:1.0)
        self.navigationItem.title = "New Account"
        self.studentNameTxt.delegate = self
        self.gradeTxt.delegate = self
        self.schoolNameTxt.delegate = self
        self.emailTxt.delegate = self
        self.passwordTxt.delegate = self
        self.confirmTxt.delegate = self
        self.loading.isHidden = true
        self.submitBtn.isEnabled = false
        self.selectGrade.isHidden = true
        self.selectSchool.isHidden = true
        self.submitBtn.layer.borderColor = UIColor.white.cgColor
        self.submitBtn.layer.borderWidth = 1
        self.submitBtn.layer.masksToBounds = true
        self.cancelBtn.layer.borderColor = UIColor.white.cgColor
        self.cancelBtn.layer.borderWidth = 1
        self.cancelBtn.layer.masksToBounds = true
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == selectGrade {
            return self.grade.count
        } else {
            return self.school.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == selectGrade {
            return self.grade[row]
        } else {
            return self.school[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == selectGrade {
            self.gradeTxt.text = self.grade[row]
        } else {
            self.schoolNameTxt.text = self.school[row]
        }
    }
    
    @IBAction func gradeClickBtn(_ sender: Any) {
        self.selectGrade.isHidden = false
    }
    
    @IBAction func schoolClickBtn(_ sender: Any) {
        self.selectSchool.isHidden = false
    }
    
    @IBAction func goSignUp(_ sender: Any) {
        self.loading.isHidden = false
        self.loading.startAnimating()
        let validemail = isValidEmail(emailstr: emailTxt.text!)
        
        /////////////////////////////////////////////////////Handle Exception//////////////////////////////////////////////////////////
        if studentNameTxt.text == ""{
            viewAlert(message: "Please enter your student name.")
            self.loading.stopAnimating()
            self.loading.isHidden = true
        }
        else if gradeTxt.text == ""{
            viewAlert(message: "Please enter your grade.")
            self.loading.stopAnimating()
            self.loading.isHidden = true
        }
        else if emailTxt.text == "" || validemail == false{
            viewAlert(message: "Please enter your correct email address.")
            self.loading.stopAnimating()
            self.loading.isHidden = true
        }
        else if schoolNameTxt.text == ""{
            viewAlert(message: "Please enter your school name.")
            self.loading.stopAnimating()
            self.loading.isHidden = true
        }
        else if passwordTxt.text == ""{
            viewAlert(message: "Please enter your password.")
            self.loading.stopAnimating()
            self.loading.isHidden = true
        }
        else if strlen(passwordTxt.text) < 6{
            viewAlert(message: "Password must be 6 character at least.")
            self.loading.stopAnimating()
            self.loading.isHidden = true
        }
        else if confirmTxt.text == ""{
            viewAlert(message: "Please enter your confirm password.")
            self.loading.stopAnimating()
            self.loading.isHidden = true
        }
        else if passwordTxt.text != confirmTxt.text{
            viewAlert(message: "Please check your password setting again.")
            self.loading.stopAnimating()
            self.loading.isHidden = true
        }
        else{
            if emailTxt.text != "" && passwordTxt.text != "" {
                Auth.auth().createUser(withEmail: emailTxt.text!, password: passwordTxt.text!) { (user, error) in
                    if user != nil{
                        
                        print("Firebase SignUp Success")
                        
                        /******************************* Insert User data to document ***********************/
                        let st_id: String = (Auth.auth().currentUser?.uid)!
                        let name = self.studentNameTxt.text
                        let grade = self.gradeTxt.text
                        let school_name = self.schoolNameTxt.text
                        
                        let docData: [String: String] = [
                            "st_id" : st_id,
                            "name" : name!,
                            "grade" : grade!,
                            "school_name" : school_name!
                        ]
                        
                        let db = Firestore.firestore()
                        
                        db.collection("students").document(st_id).setData(docData)
                        
                        ///////////////////////////////////////////////////////////////////////////////////////
                        
                        //send verification email to user
                        Auth.auth().languageCode = "zh"
                        Auth.auth().currentUser?.sendEmailVerification { (error) in
                            if let error = error{
                                print("send email failed", error)
                                self.loading.stopAnimating()
                                self.loading.isHidden = true
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
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == gradeTxt {
            self.selectGrade.isHidden = false
        } else {
            self.selectGrade.isHidden = true
        }
        if textField == schoolNameTxt {
            self.selectSchool.isHidden = false
        } else {
            self.selectSchool.isHidden = true
        }
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
