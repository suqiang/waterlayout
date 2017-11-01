//
//  SQLayoutViewController.swift
//  wulewa
//
//  Created by 苏强 on 2017/10/30.
//  Copyright © 2017年 sugercode. All rights reserved.
//

import UIKit

class SQLayoutViewController: UIViewController {
    
    var viewModel: SQViewModelBase!
    
    var rootView: SQViewBase!
    
    var viewConfig: SQViewConfigBase
    
    let filepath:String
    
    init(filepath:String) {
        self.filepath = filepath
        self.viewConfig = SQViewManager.shareManager.viewConfig(withFilename: filepath)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white

        let viewModel = SQViewManager.shareManager.viewModelClass(viewname: viewConfig.view)!.init(config: viewConfig, dataDict: ["key1":"value1"])
        
        let width = view.frame.width - self.viewConfig.margin.left.screenFit(self.viewConfig.fit_enabled) -
        self.viewConfig.margin.right.screenFit(self.viewConfig.fit_enabled)
        viewModel.setNeedLayout(width: width, height: CGFloat(MAXFLOAT))

        let rootView = SQViewManager.shareManager.viewClass(viewname: viewConfig.view)!.init(layoutConfig: viewConfig)

        rootView.viewModel = viewModel

        self.view.addSubview(rootView)
        rootView.frame.origin.y = 100
        rootView.frame.origin.x = self.viewConfig.margin.left.screenFit(self.viewConfig.fit_enabled)
        self.viewModel = viewModel
        self.rootView = rootView
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

    

}
