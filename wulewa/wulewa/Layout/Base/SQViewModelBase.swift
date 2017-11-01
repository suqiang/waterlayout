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
    
    var rootViewModel: SQViewModelBase{
        var rootViewModel = self
        while rootViewModel.superViewModel != nil{
            rootViewModel = rootViewModel.superViewModel!
        }
        return rootViewModel
    }
    
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
            myWidth = config.width.screenFit(config.fit_enabled)
        case .match_parent:
            myWidth = width
        case .weight:
            myWidth = width
        }
        
        switch config.height_type {
        case .wrap_content:
            myHeight = 40
        case .exactly:
            myHeight = config.height.screenFit(config.fit_enabled)
        case .match_parent:
            myHeight = height
        case .weight:
            myHeight = height

        }
        
        frame.size.height = myHeight
        frame.size.width = myWidth
        
    }
    
    func onLayout(){ }
    
    public func setNeedLayout(width:CGFloat, height:CGFloat){
        onMeasure(width: width, height: height)
        onLayout()
    }
    
}


enum SQVisibility: String {
    case visible = "visible"
    case invisible = "invisible"
    case gone = "gone"
}

