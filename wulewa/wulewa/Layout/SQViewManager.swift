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
    
    fileprivate func clazz(withViewname viewname:String, classKey:String) -> AnyClass?{
        if let info = view_map[viewname]{
            if let view_model_class = info[classKey]{
                
                if let clazz = view_model_class.clazz {
                    return clazz
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
    
    func viewModelClass(viewname name:String) -> SQViewModelBase.Type? {
        return clazz(withViewname: name, classKey: "view_model_class") as? SQViewModelBase.Type
    }
    
    func viewClass(viewname name:String) -> SQViewBase.Type? {
        return clazz(withViewname: name, classKey: "view_class") as? SQViewBase.Type
    }
    
    func viewStyleClass(viewname name:String) -> SQViewConfigBase.Type? {
        return clazz(withViewname: name, classKey: "view_style_class") as? SQViewConfigBase.Type
    }
    
    func viewConfig(withFilename filename:String) -> SQViewConfigBase {
        
        
//        let abs = Bundle.main.path(forResource: filename, ofType: "txt")!
        guard let abs = Bundle.main.path(forResource: filename, ofType: nil) else {
            return SQViewConfigBase()
        }
        
        
        let data:Data = try! Data.init(contentsOf: URL(fileURLWithPath: abs))
        
        let dict = try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as! Dictionary<String, Any>
        
        
        let view = dict["view"]! as! String
        var viewStyle: SQViewConfigBase
        if let viewStyleClass = SQViewManager.shareManager.viewStyleClass(viewname: view){
            viewStyle = viewStyleClass.init(dict:dict)
        }else{
            viewStyle = SQViewConfigBase()
            print("can not reflect \(view) to SQViewConfigBase class and continue")
        }
        
        return viewStyle
    }
}
