//
//  MenuViewController.swift
//  Tasks App
//
//  Created by Алексей Пархоменко on 25/02/2019.
//  Copyright © 2019 Алексей Пархоменко. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {

    var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
        configureTableView()
    }
    
    
    func configureTableView() {
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MenuTableCell.self, forCellReuseIdentifier: MenuTableCell.reuseId)
        view.addSubview(tableView)
        tableView.frame = view.frame
        
        tableView.separatorStyle = .none
        tableView.rowHeight = 90
        tableView.backgroundColor = .darkGray
    }

}

extension MenuViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MenuTableCell.reuseId) as! MenuTableCell
        let menuModel = MenuModel(rawValue: indexPath.row)
        cell.iconImageView.image = menuModel?.image
        cell.myLabel.text = menuModel?.description
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.row {
        case 0:
            let currentViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "navi_scaner")// as!
            self.present(currentViewController, animated: true, completion: nil)
        case 1:
            let currentViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "navi_settings")// as!
            self.present(currentViewController, animated: true, completion: nil)
        case 2:
            let currentViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "navi_about")// as!
            self.present(currentViewController, animated: true, completion: nil)
        default:
            break
        }

    }
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
//        if indexPath.row == 0 {
//            let aboutTableViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "navi_scaner")// as! QRCodeViewController
//            //            fileTextViewController.textTextViewtext = text2
//            //            fileTextViewController.fileName = "ScanHistory.txt"
//            self.present(aboutTableViewController, animated: true, completion: nil)
//            //navigationController?.pushViewController(aboutTableViewController, animated: true)
//        }
//
//        if indexPath.row == 1 {
//            let aboutTableViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "navi_about")// as! AboutTableViewController
////            fileTextViewController.textTextViewtext = text2
////            fileTextViewController.fileName = "ScanHistory.txt"
//            self.present(aboutTableViewController, animated: true, completion: nil)
//            //navigationController?.pushViewController(aboutTableViewController, animated: true)
//        }
//    }
    
    
}
