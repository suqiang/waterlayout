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
    
    lazy var matchParentViewModels: [SQViewModelBase] = [SQViewModelBase]()
    
    required init(config: SQViewConfigBase, dataDict:[String:Any]){
        super.init(config: config, dataDict: dataDict)
    }
    
    override func onMeasure(width: CGFloat, height: CGFloat) {
        
        var maxHeight: CGFloat = 0.0
        var maxWidth: CGFloat = 0.0
        
        let measureMatchParentChildren = config.width_type != .exactly || config.height_type != .exactly
        
        var viewConfig: SQViewConfigBase
        for viewModel in self.subViewModels {
            viewConfig = viewModel.config
            
            // 容错：【帧布局】宽度不支持配置 weight
            if viewConfig.width_type == .weight{
                viewConfig.width_type = .wrap_content
            }
            
            // 容错：【帧布局】高度不支持配置 weight
            if viewConfig.height_type == .weight{
                viewConfig.height_type = .wrap_content
            }
            
            if viewModel.visibility == .gone{
                continue
            }
            
            measure(subviewModel: viewModel, parentWidth: width, widthUsed: 0, parentHeight: height, heightUsed: 0)
            
            maxWidth = CGFloat.maximum(maxWidth, viewModel.frame.width + viewConfig.margin.left.screenFit(viewConfig.fit_enabled) + viewConfig.margin.right.screenFit(viewConfig.fit_enabled))
            
            maxHeight = CGFloat.maximum(maxHeight, viewModel.frame.height + viewConfig.margin.top.screenFit(viewConfig.fit_enabled) + viewConfig.margin.bottom.screenFit(viewConfig.fit_enabled))
            
            if measureMatchParentChildren{
                if viewConfig.width_type == .match_parent || viewConfig.height_type == .match_parent{
                  matchParentViewModels.append(viewModel)
                }
            }
        }
        
        let myWidth = getSize(sizeType: config.width_type,
                              maxSize:maxWidth,
                              parentSize: width,
                              space: config.padding.left.screenFit(config.fit_enabled) + config.padding.right.screenFit(config.fit_enabled),
                              subSize: config.width)
        
        let myHeight = getSize(sizeType: config.height_type,
                               maxSize:maxHeight,
                               parentSize: height,
                               space: config.padding.top.screenFit(config.fit_enabled) + config.padding.bottom.screenFit(config.fit_enabled),
                               subSize: config.height)
        
        frame = CGRect(x: 0, y: 0, width: myWidth, height: myHeight)
        
        if matchParentViewModels.count > 1{
            for viewModel in matchParentViewModels{
                viewConfig = viewModel.config
                var subWidth = myWidth
                var subHeight = myHeight
                
                if viewConfig.width_type == .match_parent{
                    subWidth = myWidth
                    - config.padding.left.screenFit(config.fit_enabled)
                    - config.padding.right.screenFit(config.fit_enabled)
                    - viewConfig.margin.left.screenFit(viewConfig.fit_enabled)
                    - viewConfig.margin.right.screenFit(viewConfig.fit_enabled)
                }else {
                    subWidth = CGFloat.minimum(myWidth - config.padding.left.screenFit(config.fit_enabled)
                        - config.padding.right.screenFit(config.fit_enabled)
                        - viewConfig.margin.left.screenFit(viewConfig.fit_enabled)
                        - viewConfig.margin.right.screenFit(viewConfig.fit_enabled),
                                               viewModel.frame.width)
                }
                
                if viewConfig.height_type == .match_parent{
                    subHeight = myHeight
                        - config.padding.top.screenFit(config.fit_enabled)
                        - config.padding.bottom.screenFit(config.fit_enabled)
                        - viewConfig.margin.top.screenFit(viewConfig.fit_enabled)
                        - viewConfig.margin.bottom.screenFit(viewConfig.fit_enabled)
                }else {
                    subHeight = CGFloat.minimum(myHeight - config.padding.top.screenFit(config.fit_enabled)
                        - config.padding.bottom.screenFit(config.fit_enabled)
                        - viewConfig.margin.top.screenFit(viewConfig.fit_enabled)
                        - viewConfig.margin.bottom.screenFit(viewConfig.fit_enabled),
                                               viewModel.frame.height)
                }
                
                viewModel.onMeasure(width: subWidth, height: subHeight)
            }
        }
        
        
    }
    
    func getSize(sizeType: SQSizeType, maxSize: CGFloat, parentSize:CGFloat, space:CGFloat, subSize:CGFloat) -> CGFloat {
        
        var resultSize: CGFloat = 0.0
        
        switch sizeType {
        case .exactly:
            resultSize = CGFloat.minimum(subSize, parentSize)
        case .weight:
            resultSize = parentSize
        case .wrap_content:
            resultSize = CGFloat.minimum(subSize, maxSize + space)
        case .match_parent:
            resultSize = parentSize
        }
        
        return resultSize;
    }
    
    
    
    
    override func onLayout() {
    
        let widthSpace = frame.width
            - config.padding.left.screenFit(config.fit_enabled)
            - config.padding.right.screenFit(config.fit_enabled)
        let heightSpace = frame.height
            - config.padding.top.screenFit(config.fit_enabled)
            - config.padding.bottom.screenFit(config.fit_enabled)
        
        var viewConfig: SQViewConfigBase
        for viewModel in subViewModels{
            viewConfig = viewModel.config
            if viewModel.visibility == .gone{
                continue
            }
            
            var originX: CGFloat = 0.0
            var originY: CGFloat = 0.0
            
            let gravity = viewConfig.layout_gravity
            
            if gravity.contains("left"){
                originX = config.padding.left.screenFit(config.fit_enabled) + viewConfig.margin.left.screenFit(viewConfig.fit_enabled)
            }else if gravity.contains("center_horizontal"){
                originX = config.padding.left.screenFit(config.fit_enabled)
                    + (widthSpace
                        - viewModel.frame.size.width
                        - viewConfig.margin.left.screenFit(viewConfig.fit_enabled)
                        - viewConfig.margin.right.screenFit(viewConfig.fit_enabled)) * 0.5
                    + viewConfig.margin.left.screenFit(viewConfig.fit_enabled)
                
            }else if gravity.contains("right"){
                originX = config.padding.left.screenFit(config.fit_enabled)
                        + widthSpace
                        - viewModel.frame.size.width
                        - viewConfig.margin.right.screenFit(viewConfig.fit_enabled)
            }else{
                originX = config.padding.left.screenFit(config.fit_enabled) + viewConfig.margin.left.screenFit(viewConfig.fit_enabled)
            }
            
            
            if gravity.contains("top"){
                originY = config.padding.top.screenFit(config.fit_enabled) + viewConfig.margin.top.screenFit(viewConfig.fit_enabled)
            }else if gravity.contains("center_vertical"){
                originY = config.padding.top.screenFit(config.fit_enabled)
                    + (heightSpace
                        - viewModel.frame.height
                        - viewConfig.margin.top.screenFit(viewConfig.fit_enabled)
                        - viewConfig.margin.bottom.screenFit(viewConfig.fit_enabled)) * 0.5
                    + viewConfig.margin.top.screenFit(viewConfig.fit_enabled)
                
            }else if gravity.contains("bottom"){
                originY = config.padding.top.screenFit(config.fit_enabled)
                    + heightSpace
                    - viewModel.frame.height
                    - viewConfig.margin.bottom.screenFit(viewConfig.fit_enabled)
            }else{
                originY = config.padding.top.screenFit(config.fit_enabled) + viewConfig.margin.top.screenFit(viewConfig.fit_enabled)
            }
            
            viewModel.frame.origin.x = originX
            viewModel.frame.origin.y = originY
            
            viewModel.onLayout()
            
        }
    }
}
