//
//  SQCollectionViewFooter.swift
//  wulewa
//
//  Created by 苏强 on 2017/10/18.
//  Copyright © 2017年 sugercode. All rights reserved.
//

import UIKit

class SQCollectionViewFooter: UICollectionReusableView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.green
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
