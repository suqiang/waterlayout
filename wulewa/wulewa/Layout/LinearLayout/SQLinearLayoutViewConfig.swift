//
//  SQLinearLayoutViewConfig.swift
//  wulewa
//
//  Created by 苏强 on 2017/10/26.
//  Copyright © 2017年 sugercode. All rights reserved.
//

import UIKit

class SQLinearLayoutViewConfig: SQGroupViewConfig {
    let orientation: SQLinearLayoutOrientation = .horizontal
    var gravity: String = "left|top"
}



enum SQLinearLayoutOrientation : String {
    case horizontal = "horizontal"
    case vertical = "vertical"
}
