//
//  HomeworkViewController.swift
//  Homework
//
//  Created by POLARIS on 12/21/17.
//  Copyright © 2017 Xiaoming Yu. All rights reserved.
//

import UIKit

class HomeworkListViewController: UITableViewController {

    var data = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Homework"
        self.view.backgroundColor = UIColor(red:0.90, green:0.90, blue:0.90, alpha:1.0)
        
        let test = HomeworkData()
        
        test.homeworkImg = UIImage(named: "homework-logo.jpeg")
        test.homeworkCount = 5
        test.date = Date()
        test.checkImg = UIImage(named: "Image 7.png")
        data.homeworklist.append(test)
    }

    override func viewWillAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = self.data.homeworklist.count
        return count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = self.data.homeworklist[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeworkCell") as! HomeworkCell
        
        cell.homeworkImg?.image = row.homeworkImg
        cell.count?.text = String(describing: row.homeworkCount)
        cell.count.layer.cornerRadius = cell.count.frame.width / 2
        cell.count.layer.masksToBounds = true
      
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy HH:mm"
        cell.date?.text = formatter.string(from: row.date!)
        
        cell.checkImg?.image = row.checkImg
        cell.backgroundColor = UIColor(red:0.90, green:0.90, blue:0.90, alpha:1.0)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = self.data.homeworklist[indexPath.row]
        guard let uvc = self.storyboard?.instantiateViewController(withIdentifier: "HomeworkCheckVC") as? HomeworkCheckViewController else {
            return
        }
        uvc.param = row
        self.navigationController?.pushViewController(uvc, animated: false)
    }
    
}
