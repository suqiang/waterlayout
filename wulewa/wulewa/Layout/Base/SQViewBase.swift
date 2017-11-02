//
//  SQViewBase.swift
//  wulewa
//
//  Created by 苏强 on 2017/10/25.
//  Copyright © 2017年 sugercode. All rights reserved.
//

import UIKit

class SQViewBase: UIView {
    
    var mySubviews = [SQViewBase]()
    
    var viewModel: SQViewModelBase!{
        didSet{
            frame = viewModel.frame
            print("SQViewModelBase -- set")
        }
    }

    required init(layoutConfig config:SQViewConfigBase) {
        super.init(frame: CGRect.zero)
        backgroundColor = UIColor.random
        
        UIScrollView.appearance()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
