//
//  FileTextViewController.swift
//  MyPersonalAssistant
//
//  Created by Vladimir Rice on 16.05.2020.
//  Copyright © 2020 Test. All rights reserved.
//

import UIKit

class FileTextViewController: UIViewController {

    var fileName: String = ""
    var textTextViewtext = ""
    
    @IBOutlet weak var textTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textTextView.text = textTextViewtext
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: - action
    
    @IBAction func closeButton(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveButton(_ sender: UIBarButtonItem) {
        Functions.writeFileText(fileName: fileName, decodedURL: textTextView.text, addInTheEnd: false)
    }
    
    // MARK: -  func
    
}
