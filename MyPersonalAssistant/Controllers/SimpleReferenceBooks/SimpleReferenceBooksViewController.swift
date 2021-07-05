//
//  ShopsViewController.swift
//  ChecksPricesGoods
//
//  Created by Vladimir Rice on 04.01.2021.
//

import UIKit

class SimpleReferenceBooksViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    

    var objects: [AnyObject]?
    
    var typeReferens: String = ""
    var typeReferensRus: String = ""
    var attributsCell: [String]!
    var attributs: [String]!
    var attributsRus: [String]!
    
    var attributImage: String?
    
    
    
    @IBOutlet weak var tableView: UITableView!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "1111111", style: .plain, target: nil, action: nil)
        
        navigationItem.title = typeReferensRus
            
        loadObjects()
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
 
        //if segue.identifier == "cell_ReferensBook" {
            let vc = (segue.destination as! SimpleReferenceBookViewController) //{
            //let indexPath = self.tableView.indexPathForSelectedRow
            //vc.currentObject = self.objectsCheck[indexPath!.row]
//            vc.typeReferens = "Shop"
//            var attributs = ["inn", "name", "nameJson", "adress"]
//            var attributsRus = ["ИНН", "Наименование", "Наименование из чека", "Адрес"]
//            //var attributsCell = ["inn", "name", "nameJson"]
//            var attributsImage = "image"
     
        vc.delegateViewController = self
        let indexPath = self.tableView.indexPathForSelectedRow
        vc.currentObject = self.objects![indexPath!.row]

        let typeReferensLoc = typeReferens
        //
        vc.typeReferens = typeReferensLoc
        //vc.typeReferensRus = typeReferensRus
        
        vc.delegateViewController = self
        vc.delegateViewControllerTableView = [tableView]

        vc.attributs = attributs
        //vc.attributsCell = attributsCell
        vc.attributsRus = attributsRus
        vc.attributImage = attributImage        //}
    }
        
   //}
    

    // MARK: - delegate tableview
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        objects!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = (tableView.dequeueReusableCell(withIdentifier: "simpleReferenceBooksTableViewCell", for: indexPath) as? SimpleReferenceBooksTableViewCell)!

        let currentObject = objects![indexPath.row]
        
        var textLabel = ""
//        if typeReferens == "Shop" {
//            textLabel = currentObject.inn + " " + ClShop().shopNameFromInn(inn: currentObject.inn)
//        } else {
            for attribut in attributsCell {
                if let curr = currentObject.value(forKey: attribut) as? Int {
                    textLabel = textLabel + " " + String(curr)
                    continue
                }
                if let curr = currentObject.value(forKey: attribut) as? String {
                    textLabel = textLabel + " " + curr
                    continue
                }
            }
 //       }
        
        cell.textLabel?.text = textLabel
        if attributImage != nil {  //UIImage(data: currentObject!.imageQR as Data)
            if attributImage != nil {
                let image = currentObject.value(forKey: attributImage!)
                if image != nil {
                    cell.imageCell.image = UIImage(data: image as! Data)
                }
            }
        }
        
        
        return cell
    }
    
    
    // MARK: - func
    func loadObjects() {
//        switch typeReferens {
//        case "Shop":
//            objects = RealmTool.objectsShop(predicate: "", filter: "")
//        default:
//            objects = []
//        }
    }
    
}
