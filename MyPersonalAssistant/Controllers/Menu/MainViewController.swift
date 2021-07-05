//
//  ViewController.swift
//  Tasks App
//
//  Created by Алексей Пархоменко on 01/02/2019.
//  Copyright © 2019 Алексей Пархоменко. All rights reserved.
//


import UIKit

protocol MainViewControllerDelegate {
    func toggleMenu()
}

class MainViewController: UIViewController {

    @IBOutlet weak var deliveryLabel: UILabel!
    @IBOutlet weak var menuButton: UIButton!
    
    private var galleryCollectionView = GalleryCollectionView()
    var delegate: MainViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        menuButton.setImage(UIImage(named:"icon_menu"), for: .normal)
        
        view.addSubview(galleryCollectionView)
        
        galleryCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        galleryCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        galleryCollectionView.topAnchor.constraint(equalTo: deliveryLabel.bottomAnchor, constant: 0).isActive = true
        galleryCollectionView.heightAnchor.constraint(equalToConstant: 300).isActive = true
        
        
        galleryCollectionView.set(cells: TasksModelMenu.fetchTasks())
        
        galleryCollectionView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tap)))
        
    }
    override func viewWillAppear(_ animated: Bool) {
        galleryCollectionView.set(cells: TasksModelMenu.fetchTasks())
        galleryCollectionView.reloadData()
    }

    @IBAction func menuButton(_ sender: UIButton) {
        if sender.currentImage == UIImage(named: "icon_menu") {
            sender.setImage(UIImage(named:"menuvert"), for: .normal)
        } else {
            sender.setImage(UIImage(named:"icon_menu"), for: .normal)
        }
        delegate?.toggleMenu()
    }
    

    @objc func tap(sender: UITapGestureRecognizer){
        if let indexPath = self.galleryCollectionView.indexPathForItem(at: sender.location(in: self.galleryCollectionView)) {
            _ = self.galleryCollectionView.cellForItem(at: indexPath)
            let idTask = String(galleryCollectionView.cells[indexPath.row].idTask!)
            let arrayObjects = TasksData.dataLoad(strPredicate: "id = %@", filter: idTask)
            if arrayObjects.count == 1 {
                openTask(taskObject: arrayObjects[0])
            }
        }
    }
    
    func openTask(taskObject: Tasks) {
 
        let tasksVC = storyboard?.instantiateViewController(withIdentifier:                       // "TasksVC") as! TasksViewController
                "TaskTableViewController") as! TaskTableViewController
        
        tasksVC.modalPresentationStyle = .overCurrentContext

        tasksVC.currentObject = taskObject
        tasksVC.objectReloadData = galleryCollectionView
        tasksVC.InitialView = "MainViewController"
        let navi_TasksVC = storyboard?.instantiateViewController(withIdentifier: "navi_Tasks") as! TasksNavigationController
        var arrayViewControllers:[UIViewController]? = []
        _ = navi_TasksVC.viewControllers.first
        
        arrayViewControllers?.append(tasksVC)
        navi_TasksVC.setViewControllers(arrayViewControllers!, animated: true)
        navi_TasksVC.navigationItem.backBarButtonItem?.isEnabled = false
        
        self.present(navi_TasksVC, animated: true)

        
        
    }

}
