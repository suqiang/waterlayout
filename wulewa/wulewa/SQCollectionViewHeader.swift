//
//  SQCollectionViewHeader.swift
//  wulewa
//
//  Created by 苏强 on 2017/10/18.
//  Copyright © 2017年 sugercode. All rights reserved.
//

import UIKit

class SQCollectionViewHeader: UICollectionReusableView {
    
    lazy var label: UILabel = {
        let label = UILabel(frame:self.bounds)
        label.textColor = UIColor.black
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .center
        label.autoresizingMask = UIViewAutoresizing.flexibleWidth.union(.flexibleHeight)
        return label
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.red
        self .addSubview(label)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
