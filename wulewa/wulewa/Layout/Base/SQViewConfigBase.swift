//
//  SQViewConfigBase.swift
//  wulewa
//
//  Created by 苏强 on 2017/10/25.
//  Copyright © 2017年 sugercode. All rights reserved.
//

import UIKit


enum SQSizeType: String {
    case exactly = "exactly"
    case weight = "weight"
    case match_parent = "match_parent"
    case wrap_content = "wrap_content"
}

public struct SQGravity: OptionSet {
    
    public let rawValue: Int
    
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
    
    public init(stringValue: String) {
        
        //TODO 数据合法性校验
        
        var rawValue = 0
        
        if stringValue.contains("top") {
            rawValue =  rawValue|(1 << 0)
        }
        
        if stringValue.contains("bottom") {
            rawValue =  rawValue|(1 << 1)
        }
        
        if stringValue.contains("left") {
            rawValue =  rawValue|(1 << 2)
        }
        
        if stringValue.contains("right") {
            rawValue =  rawValue|(1 << 3)
        }
        
        if stringValue.contains("center_vertical") {
            rawValue =  rawValue|(1 << 4)
        }
        
        if stringValue.contains("center_horizontal") {
            rawValue =  rawValue|(1 << 5)
        }
        
        
        
        self.init(rawValue: rawValue)
    }
    
    static let none     = SQGravity(rawValue: 0)
    static let top      = SQGravity(rawValue: 1 << 0)
    static let bottom   = SQGravity(rawValue: 1 << 1)
    static let left     = SQGravity(rawValue: 1 << 2)
    static let right    = SQGravity(rawValue: 1 << 3)
    static let center_vertical      = SQGravity(rawValue: 1 << 4)
    static let center_horizontal    = SQGravity(rawValue: 1 << 5)
    
}

class SQViewConfigBase {
    
    var padding: UIEdgeInsets = .zero
    var margin: UIEdgeInsets = .zero
    
    var width: CGFloat = 0
    var width_type: SQSizeType = .wrap_content
    
    var height: CGFloat = 0
    var height_type: SQSizeType = .wrap_content
    
    var weight: CGFloat = 0
    
    var layout_gravity: String = ""

    var view: String = "viewbase"
}


