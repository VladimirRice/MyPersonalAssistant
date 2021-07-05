//
//  vars.swift
//  MyPersonalAssistant
//
//  Created by Vladimir Rice on 13.12.2020.
//

import Foundation


enum SinchronGoogleErrors: Error {
    case errorSession
    case errorParse
    
    }

//struct Vars {
//    var appPro: Bool = true
//    var mPinKod = "10297777"
//
//}

class PublicVars {

    //var vars = Vars()
    var appPro: Bool = false
    var mPinKod: String = "10297777"
    //var appForItunes: Bool = true
    var autoSaveCloseForm = UserDefaults.standard.object(forKey: "autoSaveCloseForm") as? Bool ?? true
    
//    init(appPro: Bool, mPinKod: String) {
//            self.appPro = false
//            self.mPinKod = "10297777"
//        }
    
    let pinKod = UserDefaults.standard.object(forKey: "pinKod") as? String
    
    init() {
        appProInit()
    }
    
    func appProInit(){
        //if pinKod == mPinKod {
            appPro = true
        //    appForItunes = false
        //}
    }
    
}
