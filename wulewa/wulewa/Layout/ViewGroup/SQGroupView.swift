//
//  SQGroupView.swift
//  wulewa
//
//  Created by 苏强 on 2017/10/26.
//  Copyright © 2017年 sugercode. All rights reserved.
//

import UIKit

class SQGroupView: SQViewBase {

    required init(layoutConfig config: SQViewConfigBase) {
        super.init(layoutConfig: config)
        
        let groupConfig = config as! SQGroupViewConfig
        
        var subview: SQViewBase
        for cfg in groupConfig.subviewConfigs {
            if let viewClass = SQViewManager.shareManager.viewClass(viewname: cfg.view){
                subview = viewClass.init(layoutConfig: cfg)
                
            }else{
                subview = SQViewBase(layoutConfig: SQViewConfigBase())
                print("can not reflect \(cfg.view) to class and continue")
            }
            
            addSubview(subview)
            mySubviews.append(subview)
        
        }
        
    }
    
    override var viewModel: SQViewModelBase!{
        didSet{
            for (i, vm) in (viewModel as! SQGroupViewModel).subViewModels.enumerated() {
                mySubviews[i].viewModel = vm
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
