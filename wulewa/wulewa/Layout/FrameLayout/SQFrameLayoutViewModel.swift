//
//  SQFrameLayoutViewModel.swift
//  wulewa
//
//  Created by 苏强 on 2017/11/1.
//  Copyright © 2017年 sugercode. All rights reserved.
//

import UIKit

class SQFrameLayoutViewModel: SQGroupViewModel {

    lazy var myconfig: SQFrameLayoutViewConfig = {
        return config as! SQFrameLayoutViewConfig
    }()
    
    required init(config: SQViewConfigBase, dataDict:[String:Any]){
        super.init(config: config, dataDict: dataDict)
    }
    
    override func onMeasure(width: CGFloat, height: CGFloat) {
        
    }
    
    override func onLayout() {
       
    }
}
