//
//  SQViewManager.swift
//  wulewa
//
//  Created by 苏强 on 2017/10/25.
//  Copyright © 2017年 sugercode. All rights reserved.
//

import UIKit

class SQViewManager: NSObject {
    let view_map = ["viewbase":["view_name":"viewbase",
                            "view_class":"SQViewBase",
                            "view_style_class":"SQViewConfigBase",
                            "view_model_class":"SQViewModelBase"],
                    
                    "linear_layout":["view_name":"linear_layout",
                            "view_class":"SQLinearLayoutView",
                            "view_style_class":"SQLinearLayoutViewConfig",
                            "view_model_class":"SQLinearLayoutViewModel"]]

    static let shareManager = SQViewManager()
    private override init() {}
    
    func viewModelClass(viewname name:String) -> SQViewModelBase.Type? {
        
        if let info = view_map[name]{
            if let view_model_class = info["view_model_class"]{
                
                if let clazz = view_model_class.clazz {
                    return clazz as? SQViewModelBase.Type
                }else{
                    return nil
                }
            }else {
                return nil;
            }
        }else{
            return nil
        }
        
    }
    
    func viewClass(viewname name:String) -> SQViewBase.Type? {
        if let info = view_map[name]{
            if let view_class = info["view_class"]{
                
                if let clazz = view_class.clazz {
                    return clazz as? SQViewBase.Type
                }else{
                    return nil
                }
            }else {
                return nil;
            }
        }else{
            return nil
        }
    }
}
