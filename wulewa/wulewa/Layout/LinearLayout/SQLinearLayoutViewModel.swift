//
//  SQLinearLayoutViewModel.swift
//  wulewa
//
//  Created by 苏强 on 2017/10/26.
//  Copyright © 2017年 sugercode. All rights reserved.
//

import UIKit

class SQLinearLayoutViewModel: SQGroupViewModel {
    
    var totalSize: CGFloat = 0.0
    var weightSum: CGFloat = 0.0
    var allMatchParent = true
    var maxHeight: CGFloat = 0.0
    var matchParent = false

    lazy var myconfig: SQLinearLayoutViewConfig = {
        return config as! SQLinearLayoutViewConfig
    }()
    
    required init(config: SQViewConfigBase, dataDict:[String:Any]){
        super.init(config: config, dataDict: dataDict)
    }
    
    override func onMeasure(width: CGFloat, height: CGFloat) {
        if myconfig.orientation == .horizontal{
            measureHorizontal(width: width, height: height)
        }else if myconfig.orientation == .vertical{
            measureVertical(width: width, height: height)
        }
    }
    
    override func onLayout() {
        if myconfig.orientation == .horizontal{
            layoutHorizontal()
        }else if myconfig.orientation == .vertical{
            layoutVertical()
        }
    }
    
    func measureHorizontal(width: CGFloat, height: CGFloat) {
        totalSize = 0.0
        weightSum = 0.0
        let count = subViewModels.count
        
        var viewModel: SQViewModelBase
        var viewConfig: SQViewConfigBase
        
        for i in 0 ..< count {
            viewModel = subViewModels[i]
            viewConfig = viewModel.config
            
            
            // 【容错】父控件布局是宽度是wrap_content,而子控件宽度是weight, 默认将子控件宽度weight转为wrap_content
            if config.width_type == .wrap_content && viewConfig.width_type == .weight{
                viewConfig.width_type = .wrap_content
            }
            
            // 【容错】父控件布局是宽度是wrap_content,而子控件宽度是match_parent, 默认将子控件宽度类型转为wrap_content
            if config.width_type == .wrap_content && viewConfig.width_type == .match_parent{
                viewConfig.width_type = .wrap_content
            }
            
            // 【容错】横向布局高度设置为weight类型时，默认转成wrap_content
            if viewConfig.height_type == .weight{
                viewConfig.height_type = .wrap_content
            }
            
            // 【容错】横向布局高度设置为wrap_content类型时，而子布局高度是match_parent， 默认将子控件宽度类型转为wrap_content
            if config.height_type == .wrap_content && viewConfig.height_type == .match_parent{
                viewConfig.height_type = .wrap_content
            }
            
            if viewModel.visibility == .gone{
                continue
            }
            
            if viewConfig.height_type == .weight{
                self.weightSum += viewConfig.weight
                continue
            }
            
            measure(subviewModel: viewModel, parentWidth: width, widthUsed: totalSize, parentHeight: height, heightUsed: 0)
            
            totalSize += viewModel.frame.width + viewConfig.margin.left + viewConfig.margin.right
            
            maxHeight = CGFloat.maximum(maxHeight, viewModel.frame.height + viewConfig.margin.top + viewConfig.margin.bottom)
            
            allMatchParent = allMatchParent && viewConfig.height_type == .match_parent
            
        }
        
        
        var widthSize: CGFloat = 0.0 //totalSize + config.padding.left + config.padding.right
        
        switch config.width_type {
        case .wrap_content:
            widthSize = totalSize
        case .weight:
            widthSize = width
        case .match_parent:
            widthSize = width
        case .exactly:
            widthSize = CGFloat.minimum(width, config.width) // 精确宽度最大不超过父视图提供的宽度
        }

        
        if weightSum > 0{
            let shareSize = widthSize - self.totalSize
            
            if shareSize > 0{
                for i in 0 ..< count{
                    viewModel  = subViewModels[i];
                    viewConfig = viewModel.config;
                    
                    if viewModel.visibility == .gone {
                        continue;
                    }
                    
                    if viewConfig.width_type == .weight{
                        let subHeight = getSize(sizeType: viewConfig.height_type,
                                                parentSize: height,
                                                space: config.padding.top + config.padding.bottom + viewConfig.margin.top + viewConfig.margin.bottom,
                                                subSize: viewConfig.height)
                        
                        viewModel.onMeasure(width: shareSize * viewConfig.weight / self.weightSum, height: subHeight)
                        
                        totalSize += viewModel.frame.width + viewConfig.margin.left + viewConfig.margin.right
                        
                        maxHeight = CGFloat.maximum(maxHeight, viewConfig.margin.top + viewConfig.margin.bottom)
                        
                        allMatchParent = allMatchParent && viewConfig.height_type == .match_parent
                    }
                }
            }
        }
        
        
        switch config.height_type {

        case .match_parent:
            maxHeight = height == CGFloat(MAXFLOAT) ? maxHeight : height
        case .exactly:
            maxHeight = config.height
        case .weight:
            print("横向布局高度类型【weight】错误")
        case .wrap_content:
            maxHeight += 0
        }
        
        if allMatchParent {
            forceUniformHeight(count: count, height: maxHeight)
        }
        
        frame = CGRect(x: 0,
                       y: 0,
                       width: widthSize + config.padding.left + config.padding.right,
                       height: maxHeight + config.padding.top + config.padding.bottom)
        
    }
    
    fileprivate func forceUniformWidth(count: Int,  width: CGFloat){
        
    }
    
    fileprivate func forceUniformHeight(count: Int,  height:CGFloat){
        var viewConfig: SQViewConfigBase
        for viewModel in self.subViewModels {
            viewConfig = viewModel.config
            if viewConfig.height_type == .wrap_content{
                
                viewConfig.height_type = .exactly
                let oldWidth = viewModel.frame.width
                viewModel.onMeasure(width: oldWidth,
                                    height: height - viewConfig.margin.top - viewConfig.margin.bottom)
                viewConfig.height_type = .match_parent
                viewModel.frame.size.width = oldWidth
            }
        }
    }
    
    
    func measureVertical(width: CGFloat, height: CGFloat) {
        
    }
    
    

    
    func layoutVertical(){
        

    }
    
    func layoutHorizontal(){
        var originX: CGFloat = 0
        var originY: CGFloat = 0
        
        let widthExcludePadding = frame.width - config.padding.left - config.padding.right
        let heightExcludePadding = frame.height - config.padding.top - config.padding.bottom
        
        if myconfig.gravity.contains("right") {
            originX = config.padding.left + widthExcludePadding - totalSize
        }else if myconfig.gravity.contains("center_horizontal"){
            originX = config.padding.left + (widthExcludePadding - totalSize) * 0.5
        }else if myconfig.gravity.contains("left"){
            originX = config.padding.left
        }else {
            originX = config.padding.left
        }
        
        let count = subViewModels.count
        
        var viewModel: SQViewModelBase
        var viewConfig: SQViewConfigBase

        for i in 0 ..< count {
            viewModel = subViewModels[i]
            viewConfig = viewModel.config
            
            if viewModel.visibility == .gone{
                continue
            }
            
            let gravity = viewConfig.layout_gravity.isEmpty ? viewConfig.layout_gravity:myconfig.gravity
            
            if gravity.contains("top"){
                originY = config.padding.top + viewConfig.margin.top
            }else if gravity.contains("center_vertical"){
                originY = config.padding.top + (heightExcludePadding - (viewModel.frame.height + viewConfig.margin.top + viewConfig.margin.bottom)) * 0.5 + viewConfig.margin.top
            }else if gravity.contains("bottom"){
                originY = config.padding.top + widthExcludePadding - viewConfig.margin.bottom - viewModel.frame.size.height
            }else{
                originY = config.padding.top + viewConfig.margin.top;
            }
            
            originX += viewConfig.margin.left
            viewModel.frame.origin.x = originX
            viewModel.frame.origin.y = originY
            originX += viewModel.frame.width + viewConfig.margin.right
            viewModel.onLayout()
        }
        
        
    }
    
}
