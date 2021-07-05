//
//  Files.swift
//  MyPersonalAssistant
//
//  Created by Vladimir Rice on 23.10.2020.
//  Copyright © 2020 Test. All rights reserved.
//

/*
 info.plist
 Application supports iTunes file sharing
 Supports opening documents in place
 */


import UIKit
import Alamofire
import SwiftyJSON
//import  CoreData

//attrListsTasks.append("id")
//attrListsTasks.append("name")
//attrListsTasks.append("updatedDate")
//
//attrTasks.append("id")
//attrTasks.append("idList")
//attrTasks.append("listName")
//attrTasks.append("updatedDate")
//attrTasks.append("name")


//struct sListTasks {
//    var id = ""
//    var name = ""
//    var updatedDate = ""
//}
//struct sTasks {
//    var id = ""
//    var idList = ""
//    var listName = ""
//    var name = ""
//}

class Files: UIViewController, UIDocumentInteractionControllerDelegate {
    
    var progressView: UIProgressView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    class func downloadFileURL(id: Int, urlString: String) -> AnyObject? {
        //            let destination = DownloadRequest.suggestedDownloadDestination(for: .documentDirectory)
        
        //            //MARK: Progress controller
        //            let alertView = UIAlertController(title: "Downloading", message: "Downloading file", preferredStyle: .alert)
        //            alertView.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        //
        //            //  Show UIAlertController it to your users
        //            present(alertView, animated: true, completion: {
        //                //  Add your progressbar after alert is shown (and measured)
        //                let margin:CGFloat = 8.0
        //                let rect = CGRect(x: margin, y: 72.0, width: alertView.view.frame.width - margin * 2.0 , height: 10.0)
        //                self.progressView = UIProgressView(frame: rect)
        //                self.progressView!.progress = 0
        //                self.progressView!.tintColor = self.view.tintColor
        //                alertView.view.addSubview(self.progressView!)
        //            })
        
        //let url = "http://MyUrl/DownloadFile"
        //let headers = ["Header1": "header 1 value"]
        
        var json: Any?
        
        //let parameters = nil?//[String]()
        
        AF.request(urlString, method: .get, parameters: nil).responseJSON
        { (response) in
            do {
                let json = try JSON(data: response.data!)
                print(json)
            } catch {
                print(error)
                // or display a dialog
            }          }
        
        //            AF.request(urlString, method: .get, parameters: parameters)
        //                .responseJSON { (response) in
        //                    var json = JSON(data: data!)
        //
        //                           println(json)
        //                           println(json["productList"][1])
        //                    //switch response.result {
        ////                    case .success:
        ////                        if let json = response.result as? [String: Any] {
        ////                            let status = json["status"] as! String
        ////                            print(status)
        ////                        }
        ////                    case .failure(let error): break
        ////                        // error handling
        ////                    }
        //            }
        
        
        //            Alamofire.request(url,
        //                                      method: .post,
        //                parameters: ["id": id],
        //                encoding: JSONEncoding.default,
        //                headers: headers,
        //                to: destination).downloadProgress(closure: { (progress) in
        //                    //progress closure
        //                    self.progressView?.setProgress(Float(progress.fractionCompleted), animated: true)
        //                }).response(completionHandler: { (DefaultDownloadResponse) in
        //                    //here you able to access the DefaultDownloadResponse
        //                    //result closure
        //                    alertView.dismiss(animated: true, completion: {
        //                        let viewer = UIDocumentInteractionController(url: DefaultDownloadResponse.destinationURL!)
        //                        viewer.delegate = self
        //                        viewer.presentPreview(animated: true)
        //                })
        //            })
        return json as AnyObject
    }
    
    
    class func mFolderURL() -> URL? {
    //class func mFolderURL(folderName: String? = "") -> URL? {
//        var folderNameStr = folderName
//        if folderName == "" {
//            folderNameStr = "MyPersonalAssistent"
//        }
        let fileManager = FileManager.default
        // Get document directory for device, this should succeed
        if let documentDirectory = fileManager.urls(for: .documentDirectory,
                                                    in: .userDomainMask).first {
            // Construct a URL with desired folder name
 //           let folderURL = documentDirectory.appendingPathComponent(folderNameStr!)
            let folderURL =  documentDirectory
//            // If folder URL does not exist, create it
//            if !fileManager.fileExists(atPath: folderURL.path) {
//                do {
//                    // Attempt to create folder
//                    try fileManager.createDirectory(atPath: folderURL.path,
//                                                    withIntermediateDirectories: true,
//                                                    attributes: nil)
//                } catch {
//                    // Creation failed. Print error & return nil
//                    print(error.localizedDescription)
//                    return nil
//                }
//            }
            // Folder either exists, or was created. Return URL
            return folderURL
        }
        // Will only be called if document directory not found
        return nil
    }

    class func filesJson() -> [String] {
        
        //let documentsUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        if let documentsUrl = mFolderURL() {
            do {
                // Get the directory contents urls (including subfolders urls)
                let directoryContents = try FileManager.default.contentsOfDirectory(at: documentsUrl, includingPropertiesForKeys: nil)
                //            print(directoryContents)
                //
                // if you want to filter the directory contents you can do like this:
                let jsonFilesPath = directoryContents.filter{ $0.pathExtension == "json" || $0.pathExtension == "zip"}
                //print("json urls:",jsonFiles)
                //let extensions = ["zip", "json"]
                var jsonFileNames: [String] = []
                for file in jsonFilesPath {
                    jsonFileNames.append(file.lastPathComponent)
                }
                //let jsonFileNames = jsonFilesPath.map{ $0.deletingPathExtension().pathExtension}// .lastPathComponent }
//
                return jsonFileNames
            } catch {
                print(error)
            }
        }
        
        return []
    }
    
//
    
    class func filesCountArh() {
        let countFiles = Int(UserDefaults.standard.object(forKey: "countFileBackup") as? String ?? "10")
        if countFiles == 0 {
            return
        }
        var filesForDeleted: [String] = []
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        guard let directoryURL = URL(string: paths.path) else {return}
        do {
           let contents = try
           FileManager.default.contentsOfDirectory(at: directoryURL,
                  includingPropertiesForKeys:[.contentModificationDateKey],
                  options: [.skipsHiddenFiles, .skipsSubdirectoryDescendants])
               .filter { $0.lastPathComponent.hasSuffix(".zip") }
               .sorted(by: {
                   let date0 = try $0.promisedItemResourceValues(forKeys:[.contentModificationDateKey]).contentModificationDate!
                   let date1 = try $1.promisedItemResourceValues(forKeys:[.contentModificationDateKey]).contentModificationDate!
                return date0.compare(date1) == .orderedDescending
                })
          
            // Print results
            if contents.count > countFiles! {
                
                var currentCount = 1
                for item in contents {
                    if currentCount > countFiles! {
                        //guard let name = try? item.promisedItemResourceValues(forKeys:[.contentModificationDateKey]).name  else {return}
                        let name = item.path
                        filesForDeleted.append(name)
                    }
                    currentCount = currentCount + 1
//                    guard let t = try? item.promisedItemResourceValues(forKeys:[.contentModificationDateKey]).contentModificationDate
//                    else {return}
//                    print ("\(t)   \(item.lastPathComponent)")
                }
            }
            
        } catch {
            print (error)
        }
        
        for filePath in filesForDeleted {
            do {
                
//                let filePaths = try FileManager.default.contentsOfDirectory(atPath: file)
//                for filePath in filePaths {
                    try FileManager.default.removeItem(atPath: filePath)
//                }
            } catch {
                print("Could not clear temp folder: \(error)")
            }
        }
        
    }
    
    
} // class

extension FileManager {

    enum ContentDate {
        case created, modified, accessed

        var resourceKey: URLResourceKey {
            switch self {
            case .created: return .creationDateKey
            case .modified: return .contentModificationDateKey
            case .accessed: return .contentAccessDateKey
            }
        }
    }

    func contentsOfDirectory(atURL url: URL, sortedBy: ContentDate, ascending: Bool = true, options: FileManager.DirectoryEnumerationOptions = [.skipsHiddenFiles]) throws -> [String]? {

        let key = sortedBy.resourceKey

        var files = try contentsOfDirectory(at: url, includingPropertiesForKeys: [key], options: options)

        try files.sort {

            let values1 = try $0.resourceValues(forKeys: [key])
            let values2 = try $1.resourceValues(forKeys: [key])

            if let date1 = values1.allValues.first?.value as? Date, let date2 = values2.allValues.first?.value as? Date {

                return date1.compare(date2) == (ascending ? .orderedAscending : .orderedDescending)
            }
            return true
        }
        return files.map { $0.lastPathComponent }
    }
}
