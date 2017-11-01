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

class SQViewConfigBase {
    
    var fit_enabled: Bool = true
    var padding: UIEdgeInsets = .zero
    var margin: UIEdgeInsets = .zero
    
    var width: CGFloat = 0
    var width_type: SQSizeType = .wrap_content
    
    var height: CGFloat = 0
    var height_type: SQSizeType = .wrap_content
    
    var weight: CGFloat = 0
    
    var layout_gravity: String = ""

    var view: String = "viewbase"
    
    required init() {}
    
    required init(dict:Dictionary<String,Any>) {
        
        if let paddingDict = dict["padding"] as? [String:CGFloat]{
            self.padding = UIEdgeInsets(dict: paddingDict)
        }
        
        if let marginDict = dict["margin"] as? [String:CGFloat]{
            self.margin = UIEdgeInsets(dict: marginDict)
        }
        
        self.height = dict["height"] as? CGFloat ?? 0
        self.width = dict["width"] as? CGFloat ?? 0
        self.weight = dict["weight"] as? CGFloat ?? 0
        
        self.height_type = SQSizeType(rawValue: dict["height_type"] as? String ?? "wrap_content") ?? .wrap_content
        self.width_type = SQSizeType(rawValue: dict["width_type"] as? String ?? "wrap_content") ?? .wrap_content
        
        self.view = dict["view"] as? String ?? "viewbase"
        self.layout_gravity = dict["layout_gravity"] as? String ?? ""
        
        // self.height.screenFit(self.fit_enabled)
        
    }
    
}

let kSizeScale: CGFloat = {
    return CGFloat.minimum(UIScreen.main.bounds.width, UIScreen.main.bounds.height) / 320.0
}()

let kScreenScale: CGFloat = {
    return UIScreen.main.scale
}()

extension CGFloat{
    
    func screenFit(_ enabled:Bool) -> CGFloat{
        if enabled {
            return ceil(self * kSizeScale * kScreenScale) / kScreenScale
        }else{
            return self
        }
    }
}



