//
//  UploadViewController.swift
//  Homework
//
//  Created by POLARIS on 12/21/17.
//  Copyright © 2017 Xiaoming Yu. All rights reserved.
//

import UIKit

class UploadViewController: UIViewController {

    lazy var picker: TGPhotoPicker = TGPhotoPicker(self, frame: CGRect(x: 6, y: 70, width: UIScreen.main.bounds.width - 12, height: UIScreen.main.bounds.height - uploadBtn.frame.size.height - (self.tabBarController?.tabBar.frame.size.height)! - 80 ))
    
    @IBOutlet var uploadBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Upload"
        self.view.backgroundColor = UIColor(red:0.90, green:0.90, blue:0.90, alpha:1.0)
        self.view.addSubview(picker)
        // Do any additional setup after loading the view.
        
    }

    @IBAction func uploadClick(_ sender: Any) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { (_) in
            self.tabBarController?.selectedIndex = 2
        })
        let contentVC = CustomAlertViewController()
        alert.setValue(contentVC, forKeyPath: "contentViewController")
        self.present(alert, animated: false)
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
