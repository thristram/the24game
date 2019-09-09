//
//  UIDeviceExtension.swift
//  Seraph
//
//  Created by Fangchen Li on 9/6/17.
//  Copyright © 2017 Fangchen Li. All rights reserved.
//

import Foundation
import UIKit

public extension UIDevice {
    
    
    
    var modelName: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        switch identifier {
        case "iPod5,1":                                 return "iPod Touch 5"
        case "iPod7,1":                                 return "iPod Touch 6"
        case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
        case "iPhone4,1":                               return "iPhone 4s"
        case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
        case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
        case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
        case "iPhone7,2":                               return "iPhone 6"
        case "iPhone7,1":                               return "iPhone 6 Plus"
        case "iPhone8,1":                               return "iPhone 6s"
        case "iPhone8,2":                               return "iPhone 6s Plus"
        case "iPhone9,1", "iPhone9,3":                  return "iPhone 7"
        case "iPhone9,2", "iPhone9,4":                  return "iPhone 7 Plus"
        case "iPhone8,4":                               return "iPhone SE"
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
        case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad 3"
        case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad 4"
        case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
        case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
        case "iPad6,11", "iPad6,12":                    return "iPad 5"
        case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad Mini"
        case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad Mini 2"
        case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad Mini 3"
        case "iPad5,1", "iPad5,2":                      return "iPad Mini 4"
        case "iPad6,3", "iPad6,4":                      return "iPad Pro 9.7 Inch"
        case "iPad6,7", "iPad6,8":                      return "iPad Pro 12.9 Inch"
        case "iPad7,1", "iPad7,2":                      return "iPad Pro 12.9 Inch 2. Generation"
        case "iPad7,3", "iPad7,4":                      return "iPad Pro 10.5 Inch"
        case "AppleTV5,3":                              return "Apple TV"
        case "i386", "x86_64":                          return "Simulator"
        default:                                        return identifier
        }
    }
    
    var isPlus: Bool {
        if UIScreen.main.bounds.height == 736{
            return true
        }   else{
            return false
        }
    }
    
    var is5: Bool {
        if UIScreen.main.bounds.height == 568{
            return true
        }   else{
            return false
        }
    }
    
    var is4: Bool {
        if UIScreen.main.bounds.height == 480{
            return true
        }   else{
            return false
        }
    }
    
    var isX: Bool{
        if UIScreen.main.bounds.height == 812{
            return true
        }   else{
            return false
        }
    }
    var isMax: Bool{
        if UIScreen.main.bounds.height == 896{
            return true
        }   else{
            return false
        }
    }
    var isNotch: Bool {
        if self.isX || self.isMax{
            return true
        }
        return false
    }
    var isiPad: Bool{
        let ss = self.screenSize
        if (ss == .iPad) || (ss == .iPad10) || ( ss == .iPad12){
            return true
        }   else    {
            return false
        }
    }
    enum DeviceScreenSize: String{
        case iPhone4
        case iPhone5
        case iPhone7
        case iPhonePlus
        case iPhoneX
        case iPad
        case iPad10
        case iPad12
        case iPhoneXsMax
    }
    var HDIdentifier: String{
        
        if self.isiPad{
            return "HD"
        }   else    {
            return ""
        }
    }
    var screenSize: DeviceScreenSize{
        let screenSize = UIScreen.main.bounds
        let screenHeight = screenSize.height
        //        let screenWidth = screenSize.width
        print("screen Height: \(screenHeight)")
        switch screenHeight{
        case 480:
            return .iPhone4
        case 568:
            return .iPhone5
        case 667:
            return .iPhone7
        case 736:
            return .iPhonePlus
        case 812:
            return .iPhoneX
        case 896:
            return .iPhoneXsMax
        case 768:
            print("iPad")
            return .iPad
        case 834:
            print("iPad-10.5")
            return .iPad10
        case 1366:
            print("iPad-12.9")
            return .iPad12
        case 1024:
            print("iPad-12.9")
            return .iPad12
        default:
            return .iPhone7
        }
    }
    
    var deviceID: String{
        return UIDevice.current.identifierForVendor!.uuidString
    }
    var deviceName: String{
        return UIDevice.current.name
    }
    func initilizeUIDevice(){
        let _ = self.screenSize
    }
    
}

