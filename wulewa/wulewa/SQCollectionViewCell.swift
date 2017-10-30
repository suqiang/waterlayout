//
//  SQCollectionViewCell.swift
//  wulewa
//
//  Created by 苏强 on 2017/10/18.
//  Copyright © 2017年 sugercode. All rights reserved.
//

import UIKit

class SQCollectionViewCell: UICollectionViewCell {
    
    lazy var label: UILabel = {
        let label = UILabel(frame:contentView.bounds)
        label.textColor = UIColor.lightGray
        label.font = UIFont.systemFont(ofSize: 20)
        label.textAlignment = .center
        label.autoresizingMask = UIViewAutoresizing.flexibleWidth.union(.flexibleHeight)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(label)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}
