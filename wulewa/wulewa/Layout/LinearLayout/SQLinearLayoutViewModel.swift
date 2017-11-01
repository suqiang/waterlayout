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
        
        var allMatchParent = true
        var maxHeight: CGFloat = 0.0
        var matchParent = false
        
        var weightTotalMargin: CGFloat = 0;
        
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
            
            if viewConfig.width_type == .weight{
                self.weightSum += viewConfig.weight
                weightTotalMargin += viewConfig.margin.left.screenFit(viewConfig.fit_enabled) + viewConfig.margin.right.screenFit(viewConfig.fit_enabled)
                continue
            }
            
            if viewConfig.height_type == .match_parent{
                matchParent = true
            }
            
            measure(subviewModel: viewModel, parentWidth: width, widthUsed: totalSize, parentHeight: height, heightUsed: 0)
            
            totalSize += viewModel.frame.width
                + viewConfig.margin.left.screenFit(viewConfig.fit_enabled)
                + viewConfig.margin.right.screenFit(viewConfig.fit_enabled)
            
            maxHeight = CGFloat.maximum(maxHeight, viewModel.frame.height + viewConfig.margin.top.screenFit(viewConfig.fit_enabled) + viewConfig.margin.bottom.screenFit(viewConfig.fit_enabled))
            
            allMatchParent = allMatchParent && viewConfig.height_type == .match_parent
            
        }
        
        
        var widthSize: CGFloat = 0.0 //totalSize + config.padding.left + config.padding.right
        
        switch config.width_type {
        case .wrap_content:
            widthSize = totalSize
        case .weight:
            widthSize = width -  config.padding.left.screenFit(config.fit_enabled) - config.padding.right.screenFit(config.fit_enabled)
        case .match_parent:
            widthSize = width -  config.padding.left.screenFit(config.fit_enabled) - config.padding.right.screenFit(config.fit_enabled)
        case .exactly:
            widthSize = CGFloat.minimum(width, config.width.screenFit(config.fit_enabled)) // 精确宽度最大不超过父视图提供的宽度
        }

        
        if weightSum > 0{
            let shareSize = widthSize - self.totalSize - weightTotalMargin
            
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
                                                space: config.padding.top.screenFit(config.fit_enabled) + config.padding.bottom.screenFit(config.fit_enabled) + viewConfig.margin.top.screenFit(viewConfig.fit_enabled) + viewConfig.margin.bottom.screenFit(viewConfig.fit_enabled),
                                                subSize: viewConfig.height.screenFit(viewConfig.fit_enabled))
                        
                        viewModel.onMeasure(width: shareSize * viewConfig.weight / self.weightSum, height: subHeight)
                        
                        totalSize += viewModel.frame.width + viewConfig.margin.left.screenFit(viewConfig.fit_enabled) + viewConfig.margin.right.screenFit(viewConfig.fit_enabled)
                        
                        maxHeight = CGFloat.maximum(maxHeight, viewModel.frame.height + viewConfig.margin.top.screenFit(viewConfig.fit_enabled) + viewConfig.margin.bottom.screenFit(viewConfig.fit_enabled))
                        
                        allMatchParent = allMatchParent && viewConfig.height_type == .match_parent
                    }
                }
            }
        }
        
        
        switch config.height_type {

        case .match_parent:
            maxHeight = height == CGFloat(MAXFLOAT) ? maxHeight : height
        case .exactly:
            maxHeight = config.height.screenFit(config.fit_enabled)
        case .weight:
            print("横向布局高度类型【weight】错误")
        case .wrap_content:
            maxHeight += 0
        }
        
        if matchParent {
            forceUniformHeight(count: count, height: maxHeight)
        }
        
        frame = CGRect(x: 0,
                       y: 0,
                       width: widthSize + config.padding.left.screenFit(config.fit_enabled) + config.padding.right.screenFit(config.fit_enabled),
                       height: maxHeight + config.padding.top.screenFit(config.fit_enabled) + config.padding.bottom.screenFit(config.fit_enabled))
        
    }
    
    
    
    fileprivate func forceUniformHeight(count: Int,  height:CGFloat){
        var viewConfig: SQViewConfigBase
        for viewModel in self.subViewModels {
            viewConfig = viewModel.config
            if viewConfig.height_type == .wrap_content{
                
                viewConfig.height_type = .exactly
                let oldWidth = viewModel.frame.width
                viewModel.onMeasure(width: oldWidth,
                                    height: height - viewConfig.margin.top.screenFit(viewConfig.fit_enabled) - viewConfig.margin.bottom.screenFit(viewConfig.fit_enabled))
                viewConfig.height_type = .match_parent
                viewModel.frame.size.width = oldWidth
            }
        }
    }
    
    
    func measureVertical(width: CGFloat, height: CGFloat) {
        totalSize = 0.0
        weightSum = 0.0
        
        var maxWidth: CGFloat = 0.0
        var matchParent = false
        var weightTotalMargin: CGFloat = 0;
        let count = subViewModels.count
        
        var viewModel: SQViewModelBase
        var viewConfig: SQViewConfigBase
        
        for i in 0 ..< count {
            viewModel = subViewModels[i]
            viewConfig = viewModel.config
            
            
            // 【容错】父控件布局是高度是wrap_content,而子控件高度是weight, 默认将子控件宽度weight转为wrap_content
            if config.height_type == .wrap_content && viewConfig.height_type == .weight{
                viewConfig.height_type = .wrap_content
            }
            
            // 【容错】父控件布局是高度是wrap_content,而子控件高度是match_parent, 默认将子控件高度类型转为wrap_content
            if config.height_type == .wrap_content && viewConfig.height_type == .match_parent{
                viewConfig.height_type = .wrap_content
            }
            
            // 【容错】纵向布局高度设置为weight类型时，默认转成wrap_content
            if viewConfig.width_type == .weight{
                viewConfig.width_type = .wrap_content
            }
            
            // 【容错】纵向布局宽度设置为wrap_content类型时，而子布局宽度是match_parent， 默认将子控件卡宽度类型转为wrap_content
            if config.width_type == .wrap_content && viewConfig.width_type == .match_parent{
                viewConfig.width_type = .wrap_content
            }
            
            if viewModel.visibility == .gone{
                continue
            }
            
            if viewConfig.height_type == .weight{
                self.weightSum += viewConfig.weight
                weightTotalMargin += viewConfig.margin.top.screenFit(viewConfig.fit_enabled) + viewConfig.margin.bottom.screenFit(viewConfig.fit_enabled)
                continue
            }
            
            if viewConfig.width_type == .match_parent{
                matchParent = true
            }
            
            measure(subviewModel: viewModel, parentWidth: width, widthUsed: 0, parentHeight: height, heightUsed: totalSize)
            
            totalSize += viewModel.frame.height + viewConfig.margin.top.screenFit(viewConfig.fit_enabled) + viewConfig.margin.bottom.screenFit(viewConfig.fit_enabled)
            
            maxWidth = CGFloat.maximum(maxWidth, viewModel.frame.width + viewConfig.margin.left.screenFit(viewConfig.fit_enabled) + viewConfig.margin.right.screenFit(viewConfig.fit_enabled))
            
        }
        
        
        var heightSize: CGFloat = 0.0
        
        switch config.height_type {
        case .wrap_content:
            heightSize = totalSize
        case .weight:
            heightSize = height - config.padding.top.screenFit(config.fit_enabled) - config.padding.bottom.screenFit(config.fit_enabled)
        case .match_parent:
            heightSize = height - config.padding.top.screenFit(config.fit_enabled) - config.padding.bottom.screenFit(config.fit_enabled)
        case .exactly:
            heightSize = CGFloat.minimum(height, config.height.screenFit(config.fit_enabled)) // 精确宽度最大不超过父视图提供的高度
        }
        
        
        if weightSum > 0{
            let shareSize = heightSize - self.totalSize - weightTotalMargin
            
            if shareSize > 0{
                for i in 0 ..< count{
                    viewModel  = subViewModels[i];
                    viewConfig = viewModel.config;
                    
                    if viewModel.visibility == .gone {
                        continue;
                    }
                    
                    if viewConfig.height_type == .weight{
                        let subWidth = getSize(sizeType: viewConfig.width_type,
                                                parentSize: width,
                                                space: config.padding.left.screenFit(config.fit_enabled) + config.padding.right.screenFit(config.fit_enabled) + viewConfig.margin.left.screenFit(viewConfig.fit_enabled) + viewConfig.margin.right.screenFit(viewConfig.fit_enabled),
                                                subSize: viewConfig.width.screenFit(viewConfig.fit_enabled))
                        
                        viewModel.onMeasure(width: subWidth, height: shareSize * viewConfig.weight / self.weightSum)
                        
                        totalSize += viewModel.frame.height + viewConfig.margin.top.screenFit(viewConfig.fit_enabled) + viewConfig.margin.bottom.screenFit(viewConfig.fit_enabled)
                        
                        maxWidth = CGFloat.maximum(maxWidth,viewModel.frame.width +  viewConfig.margin.left.screenFit(viewConfig.fit_enabled) + viewConfig.margin.right.screenFit(viewConfig.fit_enabled))
                        
                    }
                }
            }
        }
        
        
        switch config.width_type {
            
        case .match_parent:
            maxWidth = width == CGFloat(MAXFLOAT) ? maxWidth : width - config.padding.left.screenFit(config.fit_enabled) - config.padding.right.screenFit(config.fit_enabled)
        case .exactly:
            maxWidth = config.width.screenFit(config.fit_enabled)
        case .weight:
            print("横向布局高度类型【weight】错误")
        case .wrap_content:
            maxWidth += 0
        }
        
        if matchParent {
            forceUniformWidth(count: count, width: maxWidth)
        }
        
        frame = CGRect(x: 0,
                       y: 0,
                       width: maxWidth + config.padding.left.screenFit(config.fit_enabled) + config.padding.right.screenFit(config.fit_enabled),
                       height: heightSize + config.padding.top.screenFit(config.fit_enabled) + config.padding.bottom.screenFit(config.fit_enabled))
    }
    
    fileprivate func forceUniformWidth(count: Int,  width: CGFloat){
        var viewConfig: SQViewConfigBase
        for viewModel in self.subViewModels {
            viewConfig = viewModel.config
            if viewConfig.width_type == .wrap_content{
                
                viewConfig.width_type = .exactly
                let oldHeight = viewModel.frame.height
                viewModel.onMeasure(width: width - viewConfig.margin.left.screenFit(viewConfig.fit_enabled) - viewConfig.margin.right.screenFit(viewConfig.fit_enabled),
                                    height: oldHeight)
                viewConfig.width_type = .match_parent
                viewModel.frame.size.height = oldHeight
            }
        }
    }
    
    

    
    func layoutVertical(){
        
        var originX: CGFloat = 0
        var originY: CGFloat = 0
        
        let widthExcludePadding = frame.width - config.padding.left.screenFit(config.fit_enabled) - config.padding.right.screenFit(config.fit_enabled)
        let heightExcludePadding = frame.height - config.padding.top.screenFit(config.fit_enabled) - config.padding.bottom.screenFit(config.fit_enabled)
        
        if myconfig.gravity.contains("bottom") {
            originY = config.padding.top.screenFit(config.fit_enabled) + heightExcludePadding - totalSize
        }else if myconfig.gravity.contains("center_vertical"){
            originY = config.padding.top.screenFit(config.fit_enabled) + (heightExcludePadding - totalSize) * 0.5
        }else if myconfig.gravity.contains("top"){
            originY = config.padding.left.screenFit(config.fit_enabled)
        }else {
            originY = config.padding.left.screenFit(config.fit_enabled)
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
            
            let gravity = viewConfig.layout_gravity.isEmpty ? myconfig.gravity:viewConfig.layout_gravity
            
            if gravity.contains("left"){
                originX = config.padding.left.screenFit(config.fit_enabled) + viewConfig.margin.left.screenFit(viewConfig.fit_enabled)
            }else if gravity.contains("center_horizontal"){
                originX = config.padding.left.screenFit(config.fit_enabled) + (widthExcludePadding - (viewModel.frame.width + viewConfig.margin.left.screenFit(viewConfig.fit_enabled) + viewConfig.margin.right.screenFit(viewConfig.fit_enabled))) * 0.5 + viewConfig.margin.left.screenFit(viewConfig.fit_enabled)
            }else if gravity.contains("right"){
                originX = config.padding.left.screenFit(config.fit_enabled) + widthExcludePadding - viewConfig.margin.right.screenFit(config.fit_enabled) - viewModel.frame.size.width
            }else{
                originX = config.padding.left.screenFit(config.fit_enabled) + viewConfig.margin.left.screenFit(viewConfig.fit_enabled);
            }
            
            originY += viewConfig.margin.top.screenFit(viewConfig.fit_enabled)
            viewModel.frame.origin.x = originX
            viewModel.frame.origin.y = originY
            originY += viewModel.frame.height + viewConfig.margin.bottom.screenFit(viewConfig.fit_enabled)
            viewModel.onLayout()
        }
        
    }
    
    func layoutHorizontal(){
        var originX: CGFloat = 0
        var originY: CGFloat = 0
        
        let widthExcludePadding = frame.width - config.padding.left.screenFit(config.fit_enabled) - config.padding.right.screenFit(config.fit_enabled)
        let heightExcludePadding = frame.height - config.padding.top.screenFit(config.fit_enabled) - config.padding.bottom.screenFit(config.fit_enabled)
        
        if myconfig.gravity.contains("right") {
            originX = config.padding.left.screenFit(config.fit_enabled) + widthExcludePadding - totalSize
        }else if myconfig.gravity.contains("center_horizontal"){
            originX = config.padding.left.screenFit(config.fit_enabled) + (widthExcludePadding - totalSize) * 0.5
        }else if myconfig.gravity.contains("left"){
            originX = config.padding.left.screenFit(config.fit_enabled)
        }else {
            originX = config.padding.left.screenFit(config.fit_enabled)
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
            
            let gravity = viewConfig.layout_gravity.isEmpty ? myconfig.gravity:viewConfig.layout_gravity
            
            if gravity.contains("top"){
                originY = config.padding.top.screenFit(config.fit_enabled) + viewConfig.margin.top.screenFit(viewConfig.fit_enabled)
            }else if gravity.contains("center_vertical"){
                originY = config.padding.top.screenFit(config.fit_enabled) + (heightExcludePadding - (viewModel.frame.height + viewConfig.margin.top.screenFit(viewConfig.fit_enabled) + viewConfig.margin.bottom.screenFit(viewConfig.fit_enabled))) * 0.5 + viewConfig.margin.top.screenFit(viewConfig.fit_enabled)
            }else if gravity.contains("bottom"){
                originY = config.padding.top.screenFit(config.fit_enabled) + heightExcludePadding - viewConfig.margin.bottom.screenFit(viewConfig.fit_enabled) - viewModel.frame.size.height
            }else{
                originY = config.padding.top.screenFit(config.fit_enabled) + viewConfig.margin.top.screenFit(viewConfig.fit_enabled);
            }
            
            originX += viewConfig.margin.left.screenFit(viewConfig.fit_enabled)
            viewModel.frame.origin.x = originX
            viewModel.frame.origin.y = originY
            originX += viewModel.frame.width + viewConfig.margin.right.screenFit(viewConfig.fit_enabled)
            viewModel.onLayout()
        }
        
        
    }
    
}
