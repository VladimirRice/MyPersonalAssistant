//
//  ImageViewController.swift
//  MyPersonalAssistant
//
//  Created by Vladimir Rice on 16.04.2020.
//  Copyright © 2020 Vladimir Rice. All rights reserved.
//

import UIKit
 
class ImageViewController: UIViewController, UIScrollViewDelegate{

    @IBOutlet weak var imageImageView: UIImageView!
    @IBOutlet weak var imageScrollView: UIScrollView!
    
    var currentImage: UIImage!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageImageView?.image = UIImage()
        
        if currentImage != nil {
            imageImageView?.image = currentImage
        }
        
//        imageImageView.layer.borderWidth = 0.3
//        imageImageView.layer.borderColor = UIColor.black.cgColor
        //navigationItem.leftBarButtonItem?.title = "Назад"
        //navigationItem. leftBarButtonItems
        //.navigationItem.title
     
        let title = "< Назад"// + currentListObject!.name!
        let backButton = UIBarButtonItem(title: title, style: UIBarButtonItem.Style.plain, target: self, action: #selector(backAction))
        navigationItem.leftBarButtonItem = backButton

        //self.scrollView.contentSize = self.imageImageView.bounds.size*2
        imageScrollView.delegate = self
        imageScrollView.minimumZoomScale = 1.0
        imageScrollView.maximumZoomScale = 6.0
        
    }
    
    @objc func backAction(){
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: UIScrollViewDelegate
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageImageView
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

//    @IBAction func closeButton(_ sender: UIButton) {
//        self.dismiss(animated: true, completion: nil)
//    }
    
}
