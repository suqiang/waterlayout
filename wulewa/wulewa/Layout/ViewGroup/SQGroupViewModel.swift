//
//  SQGroupViewModel.swift
//  wulewa
//
//  Created by 苏强 on 2017/10/25.
//  Copyright © 2017年 sugercode. All rights reserved.
//

import UIKit

class SQGroupViewModel: SQViewModelBase {

    var subViewModels: [SQViewModelBase] = [SQViewModelBase]()

    required init(config: SQViewConfigBase, dataDict:[String:Any]) {
        super.init(config: config, dataDict: dataDict)
    
        var vm: SQViewModelBase
        for subviewConfig in (config as! SQGroupViewConfig).subviewConfigs{
            
            if let vmClazz = SQViewManager.shareManager.viewModelClass(viewname: subviewConfig.view){
                vm = vmClazz.init(config:subviewConfig,dataDict:dataDict)
            }else{
                vm = SQViewModelBase(config:subviewConfig, dataDict:dataDict)
                print("can not reflect \(subviewConfig.view) to class and continue")
            }
            vm.superViewModel = self
            subViewModels.append(vm)
        }
        
    }
    
    
    func measure(subviewModel:SQViewModelBase,
                                 parentWidth:CGFloat,widthUsed:CGFloat,
                                 parentHeight:CGFloat, heightUsed:CGFloat) {

        let subWidth: CGFloat =  getSize(sizeType: subviewModel.config.width_type,
                                         parentSize: parentWidth - widthUsed,
                                         space: config.padding.left.screenFit(config.fit_enabled)
                                            + config.padding.right.screenFit(config.fit_enabled)
                                            + subviewModel.config.margin.left.screenFit(subviewModel.config.fit_enabled)
                                            + subviewModel.config.margin.right.screenFit(subviewModel.config.fit_enabled),
                                         
                                         subSize: subviewModel.config.width.screenFit(subviewModel.config.fit_enabled))
        
        let subHeight: CGFloat = getSize(sizeType: subviewModel.config.height_type,
                                         parentSize: parentHeight - heightUsed,
                                         space: config.padding.top.screenFit(config.fit_enabled)
                                            + config.padding.bottom.screenFit(config.fit_enabled)
                                            + subviewModel.config.margin.top.screenFit(subviewModel.config.fit_enabled)
                                            + subviewModel.config.margin.bottom.screenFit(subviewModel.config.fit_enabled),
                                         subSize: subviewModel.config.height.screenFit(subviewModel.config.fit_enabled));

        subviewModel.onMeasure(width: subWidth, height: subHeight);


    }
    
    func getSize(sizeType: SQSizeType, parentSize:CGFloat, space:CGFloat, subSize:CGFloat) -> CGFloat {
        
        let newSize = CGFloat.maximum(0, parentSize - space)
        var resultSize: CGFloat = 0.0
        
        switch sizeType {
        case .exactly:
            resultSize = subSize
        case .weight:
            resultSize = newSize
        case .wrap_content:
            resultSize = newSize
        case .match_parent:
            resultSize = newSize
        }
        
        return resultSize;
    }

}
