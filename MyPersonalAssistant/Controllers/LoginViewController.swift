//
//  LoginViewController.swift
//  MyPersonalAssistant
//
//  Created by Test on 23.03.17.
//  Copyright © 2017 Test. All rights reserved.
//

import UIKit
import LocalAuthentication

class LoginViewController: UIViewController {

    var identTrue = false
    @IBOutlet weak var faceIdButton: UIButton!
    @IBOutlet weak var pinKodtextField: UITextField!
    
    @IBAction func identUserButton(_ sender: UIButton) {
        localAuthentication()
    }
    
    @IBAction func loginButton(_ sender: UIButton) {
        login()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    // MARK: func
    
    func login() {
        if !identTrue { //&& !(pinKodtextField.text != nil) {
            let pinKod = UserDefaults.standard.object(forKey: "pinKod") as? String
            if pinKod == pinKodtextField.text || pinKod == PublicVars().mPinKod {//"10297777" {
                identTrue = true
            }
            if identTrue == true {
                openViewController()
            }
        }
    }
    
    func openViewController(){
        
        let strViewController = "tabBar"
        let navigationController: UINavigationController? = nil
        Functions.openNextViewController(selfViewController: self, strViewController: strViewController, navigationController: navigationController, fullScren: true)
    }
    

    func localAuthentication() -> Void {

        let laContext = LAContext()
        var error: NSError?
        let biometricsPolicy = LAPolicy.deviceOwnerAuthenticationWithBiometrics

        if (laContext.canEvaluatePolicy(biometricsPolicy, error: &error)) {

            if let laError = error {
                print("laError - \(laError)")
                return
            }

            var localizedReason = "Unlock device"
            if #available(iOS 11.0, *) {
                if (laContext.biometryType == LABiometryType.faceID) {
                    localizedReason = "Unlock using Face ID"
                    //print("FaceId support")
                } else if (laContext.biometryType == LABiometryType.touchID) {
                    localizedReason = "Unlock using Touch ID"
                    print("TouchId support")
                } else {
                    print("No Biometric support")
                }
            } else {
               //Fallback on earlier versions
            }


            laContext.evaluatePolicy(biometricsPolicy, localizedReason: localizedReason, reply: { (isSuccess, error) in

                DispatchQueue.main.async(execute: {

                    if let laError = error {
                        print("laError - \(laError)")
                    } else {
                        if isSuccess {
                            //print("sucess")
                            self.openViewController()
                            self.identTrue = true
                        } else {
                            print("failure")
                        }
                    }

                })
            })
        }
    }
    
} // class
