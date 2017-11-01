//
//  SQLinearLayoutViewConfig.swift
//  wulewa
//
//  Created by 苏强 on 2017/10/26.
//  Copyright © 2017年 sugercode. All rights reserved.
//

import UIKit

class SQLinearLayoutViewConfig: SQGroupViewConfig {
    var orientation: SQLinearLayoutOrientation = .horizontal
    var gravity: String = "left|top"
    required init() {
        super.init()
    }
    required init(dict: Dictionary<String, Any>) {
        self.gravity = dict["gravity"] as? String ?? "left|top"
        self.orientation = SQLinearLayoutOrientation(rawValue: dict["orientation"] as? String ?? "horizontal") ?? .horizontal
        super.init(dict: dict)
    }
}



enum SQLinearLayoutOrientation : String {
    case horizontal = "horizontal"
    case vertical = "vertical"
}
