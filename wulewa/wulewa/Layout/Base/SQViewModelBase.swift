//
//  SQViewModelBase.swift
//  wulewa
//
//  Created by 苏强 on 2017/10/25.
//  Copyright © 2017年 sugercode. All rights reserved.
//

import UIKit

class SQViewModelBase {
    
    var config: SQViewConfigBase
    
    var superViewModel: SQViewModelBase?
    
    var dataDict: [String:Any]
    
    var visibility: SQVisibility = .visible
    
    var frame: CGRect = .zero
    

    required init(config: SQViewConfigBase, dataDict:[String:Any]) {
        self.dataDict = dataDict
        self.config = config
    }
    
    
    
    func onMeasure(width:CGFloat, height:CGFloat) {
        
        var myWidth: CGFloat = 0
        var myHeight: CGFloat = 0
        switch config.width_type {
        case .wrap_content:
            myWidth = 40
        case .exactly:
            myWidth = config.width
        case .match_parent:
            myWidth = width
        default:
            myWidth = 9
        }
        
        switch config.height_type {
        case .wrap_content:
            myHeight = 40
        case .exactly:
            myHeight = config.height
        case .match_parent:
            myHeight = height
        default:
            myHeight = 0
        }
        
        frame.size.height = myHeight
        frame.size.width = myWidth
        
    }
    
    func onLayout(){ }
}


enum SQVisibility: String {
    case visible = "visible"
    case invisible = "invisible"
    case gone = "gone"
}

