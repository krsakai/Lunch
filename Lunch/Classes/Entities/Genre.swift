//
//  Genre.swift
//  Lunch
//
//  Created by 酒井邦也 on 2018/01/20.
//  Copyright © 2018年 酒井邦也. All rights reserved.
//

import Foundation
import ObjectMapper
import RealmSwift
import HEXColor

internal final class Genre: Object {
    
    @objc dynamic fileprivate(set) var genreId   = UUID().uuidString.replacingOccurrences(of: "-", with: "")
    @objc dynamic fileprivate(set) var name      = "｜"      // ジャンル名
    @objc dynamic fileprivate(set) var code      = ""       // ジャンルコード
    @objc dynamic fileprivate(set) var colorRawValue = ""   // 色(RGB文字列)
    @objc dynamic var isActive  = true                      // 有効かどうか
    
    var color: UIColor {
        var hexValue: UInt32 = 0
        guard Scanner(string: colorRawValue).scanHexInt32(&hexValue) else {
            return .white
        }
        return UIColor(hex6: hexValue)
    }
    
    var textColor: UIColor {
        if let rgbList = colorRawValue.split(2), rgbList.count > 2 {
            let r = Double(Int(rgbList[0], radix: 16)!) * 0.299
            let g = Double(Int(rgbList[1], radix: 16)!) * 0.587
            let b = Double(Int(rgbList[2], radix: 16)!) * 0.114
            return r + g + b < 127.5 ? .white : .black
        } else {
            return .black
        }
    }
    
    // MARK: - Override
    
    override static func primaryKey() -> String? {
        return "genreId"
    }
    
    override static func indexedProperties() -> [String] {
        return ["code"]
    }
}

extension Genre: ClonableObject {
    func updateColumn( reference: Genre) -> Genre {
        genreId = reference.genreId
        name = reference.name
        code = reference.code
        colorRawValue = reference.colorRawValue
        isActive = reference.isActive
        return self
    }
}

extension Genre {
    
    static func predicate(code: String) -> NSPredicate {
        return NSPredicate(format: "code = %@", code)
    }
    
    static func predicate(name: String) -> NSPredicate {
        return NSPredicate(format: "name = %@", name)
    }
    
    static func predicate(isActive: Bool) -> NSPredicate {
        return NSPredicate(format: "isActive = %@", NSNumber.init(booleanLiteral: isActive))
    }
}

extension Genre: Mappable {
    
    convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        name            <- map["name"]
        code            <- map["code"]
        colorRawValue   <- map["color"]
    }
}
