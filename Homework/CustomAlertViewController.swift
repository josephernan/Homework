//
//  CustomAlertViewController.swift
//  Homework
//
//  Created by POLARIS on 12/22/17.
//  Copyright © 2017 Xiaoming Yu. All rights reserved.
//

import UIKit

class CustomAlertViewController: UIViewController {

    override func viewDidLoad() {
        let icon = UIImage(named: "Image9.png")
        let iconV = UIImageView(image: icon)
        iconV.frame = CGRect(x: 0, y: 0, width: (icon?.size.width)!, height: (icon?.size.height)!)
        iconV.centerX = 100
        self.view.addSubview(iconV)
        
        let label = UILabel()
        label.text = "Upload Successful!"
        label.textAlignment = .center
        label.frame = CGRect(x: 0, y: (icon?.size.height)! + 5, width: 200, height: 30)
        self.view.addSubview(label)
        self.preferredContentSize = CGSize(width: 200, height: (icon?.size.height)! + (label.size.height) + 10)
    }
}
