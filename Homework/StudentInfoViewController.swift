//
//  StudentInfoViewController.swift
//  Homework
//
//  Created by POLARIS on 12/21/17.
//  Copyright © 2017 Xiaoming Yu. All rights reserved.
//

import UIKit
import Firebase

class StudentInfoViewController: UIViewController {

    @IBOutlet var studentName: UILabel!
    @IBOutlet var schoolName: UILabel!
    @IBOutlet var email: UILabel!
    @IBOutlet var grade: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Student Information"
        self.view.backgroundColor = UIColor(red:0.90, green:0.90, blue:0.90, alpha:1.0)
        
        //flag of person
        let person_flag = "students"
        
        let st_id: String = (Auth.auth().currentUser?.uid)!
        
        //firebase document connection
        let db = Firestore.firestore()
        
        let docRef = db.collection(person_flag).document(st_id)
        
        docRef.getDocument { (document, error) in
            if let document = document {
                
                let student_data = document.data()
                self.studentName.text = student_data["name"] as? String
                self.schoolName.text = student_data["school_name"] as? String
                self.email.text = Auth.auth().currentUser?.email
                self.grade.text = student_data["grade"] as? String
                
            } else {
                print("Document does not exist")
            }
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
