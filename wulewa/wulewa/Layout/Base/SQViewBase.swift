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
            isHidden = !(viewModel.visibility == .visible)
        }
    }

    required init(layoutConfig config:SQViewConfigBase) {
        super.init(frame: CGRect.zero)
        
        let debug = true
        
        if debug {
            backgroundColor = UIColor.random
        }else{
            backgroundColor = config.highlight_background_color.uiColor()
        }
        
        UIScrollView.appearance()
    }
    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//
//    }
//
//    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
//
//    }
//
//    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//
//    }
//
//    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
//
//    }
    
//    override func draw(_ rect: CGRect) {
//
//    }
//
//    override func draw(_ layer: CALayer, in ctx: CGContext) {
//
//    }
//
//    override func drawHierarchy(in rect: CGRect, afterScreenUpdates afterUpdates: Bool) -> Bool {
//
//
//    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
