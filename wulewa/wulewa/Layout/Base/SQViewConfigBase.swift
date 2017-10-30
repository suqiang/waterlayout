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
    
    var sizeFit: Bool = true
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

extension CGFloat{
    var scale: CGFloat{
        return self
    }
}


