//
//  DeviceModel.swift
//  Lunch
//
//  Created by 酒井邦也 on 2017/02/25.
//  Copyright © 2017年 酒井邦也. All rights reserved.
//

import UIKit
import CoreLocation
import CoreBluetooth
import KeychainAccess

internal enum ThemeColor: Int {
    case red    = 1
    case green  = 2
    case blue   = 3
    case water  = 4
    
    var title: String {
        switch self {
        case .red:   return "赤"
        case .green: return "緑"
        case .blue:  return "青"
        case .water: return "水色"
        }
    }
    
    var hexValue: UInt32 {
        switch self {
        case .red: return LunchColor.Common.redRawValue.hexValue
        case .green: return LunchColor.Common.greenRawValue.hexValue
        case .blue: return LunchColor.Common.blueRawValue.hexValue
        case .water: return LunchColor.Common.waterRawValue.hexValue
        }
    }
    
    var color: UIColor {
        switch self {
        case .red: return LunchColor.Common.red
        case .green: return LunchColor.Common.green
        case .blue: return LunchColor.Common.blue
        case .water: return LunchColor.Common.water
        }
    }
}


internal final class DeviceModel {

    static let sharedModel = DeviceModel()
    
    static var isOverLunch: Bool {
        guard let _ = HistoryManager.shared.historyDataFromRealm(predicate: History.predicateCurrentDate) else {
            return false
        }
        return true
    }
    
    /// NSUserDefaultsのアクセスで使用するキー
    private enum UserDefaultsKey: String {
        case isFirstReadMasterData   = "IsFirstReadMasterData"
        case currentLocation         = "CurrentLocation"
        case themeColor              = "ThemeColor"
        case searchRadius            = "SearchRadius"
        case searchLocationDateTime  = "SearchLocationDateTime"
        case customLocationName      = "CustomLocationName"
        case customLocationX         = "CustomLocationX"
        case customLocationY         = "CustomLocationY"
    }
    
    static var isFirstReadMasterData: Bool {
        if UserDefaults.standard.bool(forKey: UserDefaultsKey.isFirstReadMasterData.rawValue) {
            return true
        } else {
            UserDefaults.standard.set(true, forKey: UserDefaultsKey.isFirstReadMasterData.rawValue)
            return false
        }
    }
    
    static var currentLocation: CLLocation? {
        get {
            let latitude = UserDefaults.standard.double(forKey: UserDefaultsKey.currentLocation.rawValue + "x")
            let longitude = UserDefaults.standard.double(forKey: UserDefaultsKey.currentLocation.rawValue + "y")
            guard latitude != 0 && longitude != 0 else {
                return nil
            }
            return CLLocation(latitude: latitude, longitude: longitude)
        }
        set {
            guard let location = newValue else {
                return
            }
            UserDefaults.standard.set(location.coordinate.latitude, forKey: UserDefaultsKey.currentLocation.rawValue + "x")
            UserDefaults.standard.set(location.coordinate.longitude, forKey: UserDefaultsKey.currentLocation.rawValue + "y")
        }
    }
    
    static var themeColor: ThemeColor {
        get {
            return ThemeColor(rawValue: UserDefaults.standard.integer(forKey: UserDefaultsKey.themeColor.rawValue)) ??  ThemeColor.blue
        }
        set {
            UserDefaults.standard.set(newValue.rawValue, forKey: UserDefaultsKey.themeColor.rawValue)
        }
    }
    
    static var searchRange: SearchRange {
        get {
            return  SearchRange(rawValue: UserDefaults.standard.string(forKey: UserDefaultsKey.searchRadius.rawValue) ?? SearchRange.middle.rawValue) ?? SearchRange.middle
        }
        set {
            UserDefaults.standard.set(newValue.rawValue, forKey: UserDefaultsKey.searchRadius.rawValue)
        }
    }
    
    static var searchLocationDateTime: Date {
        get {
            guard let date = UserDefaults.standard.string(forKey: UserDefaultsKey.searchLocationDateTime.rawValue) else {
                return NSDateZero
            }
            return date.dateFromDisplayedFormat(format: .noSeparatorYearToSecond)
        }
        set {
            UserDefaults.standard.set(newValue.stringFromDate(format: .noSeparatorYearToSecond), forKey: UserDefaultsKey.searchLocationDateTime.rawValue)
        }
    }
    
    static var isCustomLocation: Bool {
        if let location = DeviceModel.customLocation {
            return true
        } else {
            return false
        }
    }
    
    static var customLocation: Location? {
        get {
            let locationName = UserDefaults.standard.string(forKey: UserDefaultsKey.customLocationName.rawValue)
            let latitude = UserDefaults.standard.double(forKey: UserDefaultsKey.customLocationX.rawValue)
            let longitude = UserDefaults.standard.double(forKey: UserDefaultsKey.customLocationY.rawValue)
            
            if let name = locationName, !name.isEmpty, latitude != 0, longitude != 0 {
                return Location(name: name, latitude: latitude, longitude: longitude)
            } else {
                return nil
            }
        }
        set {
            guard let location = newValue else {
                UserDefaults.standard.removeObject(forKey: UserDefaultsKey.customLocationName.rawValue)
                UserDefaults.standard.removeObject(forKey: UserDefaultsKey.customLocationX.rawValue)
                UserDefaults.standard.removeObject(forKey: UserDefaultsKey.customLocationY.rawValue)
                return
            }
            UserDefaults.standard.set(location.name, forKey: UserDefaultsKey.customLocationName.rawValue)
            UserDefaults.standard.set(location.latitude, forKey: UserDefaultsKey.customLocationX.rawValue)
            UserDefaults.standard.set(location.longitude, forKey: UserDefaultsKey.customLocationY.rawValue)
        }
    }
    
    /// KeyChainのアクセスで使用するキー
    enum KeychainKey: String {
        case MemberId       = "MemberId"
        case MemberNameJp   = "MemberNameJp"
        case MemberNameKana = "MemberNameKana"
        case MemberEmail    = "MemberEmail"
    }
    
    // MARK: KeyChain Prame
    
    static var memberId: String {
        let keychain = Keychain()
        let key = KeychainKey.MemberId.rawValue
        if let memberId = keychain[string: key] {
            return memberId
        }
        let memberId = UUID().uuidString.replacingOccurrences(of: "-", with: "")
        keychain[string: key] = memberId
        return memberId
    }

    static var memberEmail: String {
        get {
            return Keychain()[string: KeychainKey.MemberEmail.rawValue] ?? ""
        }
        set {
            Keychain()[string: KeychainKey.MemberEmail.rawValue] = newValue
        }
    }
    
    static func removeKeychainAll() {
        try! Keychain().removeAll()
    }
}
