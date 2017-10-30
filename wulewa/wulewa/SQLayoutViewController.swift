//
//  SQLayoutViewController.swift
//  wulewa
//
//  Created by 苏强 on 2017/10/30.
//  Copyright © 2017年 sugercode. All rights reserved.
//

import UIKit

class SQLayoutViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white

        let horizontalConfig = SQLinearLayoutViewConfig()
        horizontalConfig.view = "linear_layout"
        horizontalConfig.height_type = .wrap_content
        horizontalConfig.width_type = .match_parent
        
        
        let viewConfig1 = SQViewConfigBase()
        viewConfig1.height = 100
        viewConfig1.height_type = .exactly
        viewConfig1.width = 100
        viewConfig1.width_type = .exactly
        viewConfig1.margin = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        
        let viewConfig2 = SQViewConfigBase()
        viewConfig2.height = 50
        viewConfig2.height_type = .exactly
        viewConfig2.width = 50
        viewConfig2.width_type = .exactly
        viewConfig2.margin = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        

        
        let horizontalConfig1 = SQLinearLayoutViewConfig()
        horizontalConfig1.view = "linear_layout"
        horizontalConfig1.height_type = .wrap_content
        horizontalConfig1.width_type = .wrap_content
        
        
        let viewConfig11 = SQViewConfigBase()
        viewConfig11.height = 100
        viewConfig11.height_type = .exactly
        viewConfig11.width = 100
        viewConfig11.width_type = .exactly
        viewConfig11.margin = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        
        let viewConfig22 = SQViewConfigBase()
        viewConfig22.height = 50
        viewConfig22.height_type = .exactly
        viewConfig22.width = 50
        viewConfig22.width_type = .exactly
        viewConfig22.margin = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        
        horizontalConfig1.subviewConfigs.append(viewConfig11)
        horizontalConfig1.subviewConfigs.append(viewConfig22)
        
        horizontalConfig.subviewConfigs.append(viewConfig1)
        horizontalConfig.subviewConfigs.append(viewConfig2)
        horizontalConfig.subviewConfigs.append(horizontalConfig1)
        
        
        let viewModel = SQLinearLayoutViewModel(config: horizontalConfig, dataDict: ["key1":"value1"])
        
        viewModel.onMeasure(width: 500, height: CGFloat(MAXFLOAT))
        viewModel.onLayout()
        
        let rootView = SQLinearLayoutView(layoutConfig: horizontalConfig);
        
        rootView.viewModel = viewModel
        
        self.view.addSubview(rootView)
        rootView.frame.origin.y = 100
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    

}
