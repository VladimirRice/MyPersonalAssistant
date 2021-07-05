//
//  MenuModel.swift
//  Tasks App
//
//  Created by Алексей Пархоменко on 25/02/2019.
//  Copyright © 2019 Алексей Пархоменко. All rights reserved.
//

import Foundation
import UIKit

enum MenuModel: Int, CustomStringConvertible {
    
    case Scaner
//    case Menu
    case Settings
    case About
    
    var description: String {
        switch self {
        case .Scaner: return "Сканер"
//        case .Menu: return "Menu"
        case .Settings: return "Настройки"
        case .About: return "О приложении"
            
        }
    }
    
    var image: UIImage {
        switch self {
        case .Scaner: return UIImage(named: "focus1") ?? UIImage()
//        case .Menu: return UIImage(named: "Menu") ?? UIImage()
        case .Settings: return UIImage(named: "settings1") ?? UIImage()
        case .About: return UIImage(named: "AppIcon") ?? UIImage()
            
        }
    }
    
}
