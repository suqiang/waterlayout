//
//  SQGroupViewConfig.swift
//  wulewa
//
//  Created by 苏强 on 2017/10/25.
//  Copyright © 2017年 sugercode. All rights reserved.
//

import UIKit

class SQGroupViewConfig: SQViewConfigBase {
    var subviewConfigs: [SQViewConfigBase] = [SQViewConfigBase]()
    
    required init() {
        super.init()
    }
    
    required init(dict: Dictionary<String, Any>) {
        super.init(dict: dict)

        if let subs = dict["subviewConfigs"] as? [[String:Any]]{
            var viewConfig: SQViewConfigBase
            for subDict in subs{
                viewConfig = SQViewManager.shareManager.viewStyleClass(viewname: subDict["view"] as! String)!.init(dict: subDict)
                subviewConfigs.append(viewConfig)
            }
        }
    }
}
