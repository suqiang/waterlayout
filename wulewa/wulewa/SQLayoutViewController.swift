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
    
    let filepath:String
    
    init(filepath:String) {
        self.filepath = filepath
        super.init(nibName: nil, bundle: nil)
        
        let abs = Bundle.main.path(forResource: filepath, ofType: nil)!
        
        let data:Data = try! Data.init(contentsOf: URL(fileURLWithPath: abs))
        
        let dict = try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments)
        
        print("\(dict)")
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white

       
        
//        let viewModel = SQLinearLayoutViewModel(config: horizontalConfig, dataDict: ["key1":"value1"])
//        viewModel.setNeedLayout(width: 500, height: CGFloat(MAXFLOAT))
//
//        let rootView = SQLinearLayoutView(layoutConfig: horizontalConfig);
//
//        rootView.viewModel = viewModel
//
//        self.view.addSubview(rootView)
//        rootView.frame.origin.y = 100
//        self.viewModel = viewModel
//        self.rootView = rootView
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

    

}
