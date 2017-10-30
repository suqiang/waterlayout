//
//  RootViewController.swift
//  wulewa
//
//  Created by 苏强 on 2017/10/12.
//  Copyright © 2017年 苏强. All rights reserved.
//

import UIKit

class RootViewController: UIViewController {
    
    let cellSizes = [CGSize(width:500, height:500),
                     CGSize(width:700, height:665),
                     CGSize(width:899, height:689),
                     CGSize(width:400, height:200),
                     CGSize(width:500, height:400)]
    
    
    var isStick = false
    
    
    lazy var dataArray:[[CGSize]] = {
        var dataArray:[[CGSize]] = [[CGSize]]()
        let cellSizes = [CGSize(width:500, height:500),
                         CGSize(width:700, height:665),
                         CGSize(width:899, height:689),
                         CGSize(width:400, height:200),
                         CGSize(width:500, height:400)]
        for section in 0 ..< 6{
            var items = [CGSize]()
            for item in 0..<30{
                items.append(cellSizes[item % 4])
            }
            dataArray.append(items)
        }
        return dataArray
    }()
    
    lazy var collectionView: UICollectionView = {
        
//        let flowLayout = UICollectionViewFlowLayout()
//        flowLayout.minimumLineSpacing = 10
//        flowLayout.minimumInteritemSpacing = 0
//        flowLayout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: 50)

        let flowLayout = SQCollectionViewWaterfallLayout()
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        flowLayout.headerHeight = 120;
        flowLayout.footerHeight = 30;
        flowLayout.headerInset = UIEdgeInsets(top: 10, left: 10, bottom: 20, right: 10)
        flowLayout.minimumColumnSpacing = 10;
        flowLayout.minimumInteritemSpacing = 10;
        
        
        let collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: flowLayout)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(SQCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.register(SQCollectionViewFooter.self, forSupplementaryViewOfKind:SQCollectionElementKindSectionFooter, withReuseIdentifier: "footer")
        collectionView.register(SQCollectionViewHeader.self, forSupplementaryViewOfKind:SQCollectionElementKindSectionHeader, withReuseIdentifier: "header")
        collectionView.backgroundColor = UIColor.clear
        
        if #available(iOS 11.0, *) {
            collectionView.contentInsetAdjustmentBehavior = .never
            collectionView.contentInset = UIEdgeInsets(top: 64, left: 0, bottom: 0, right: 0)
            collectionView.scrollIndicatorInsets = collectionView.contentInset
        }
        
    
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.orange
        view.addSubview(collectionView)
        let left1 = UIBarButtonItem(title: "reloadAll", style: .plain, target: self, action: #selector(reloadAll))
        let left2 = UIBarButtonItem(title: "delete", style: .plain, target: self, action: #selector(deleteItem))
        let left3 = UIBarButtonItem(title: "insert", style: .plain, target: self, action: #selector(insertItem))
        let left4 = UIBarButtonItem(title: "reload", style: .plain, target: self, action: #selector(reloadItem))
        let left5 = UIBarButtonItem(title: "scroll", style: .plain, target: self, action: #selector(scrollItem))
        let left6 = UIBarButtonItem(title: "stick", style: .plain, target: self, action: #selector(stickHead))
        navigationItem.leftBarButtonItems = [left1, left2, left3, left4, left5, left6]
        
    }
    
    @objc func reloadAll() -> Void {
        self.collectionView.reloadData()
    }
    
    @objc func stickHead() -> Void {
        (self.collectionView.collectionViewLayout as! SQCollectionViewWaterfallLayout).sectionHeadersPinToVisibleBounds = self.isStick
        isStick = !isStick
    }
    
    @objc func scrollItem() -> Void {
        self.collectionView.scrollToItem(at: IndexPath(item: 23, section: 0), at: .top, animated: true)
    }
    
    @objc func deleteItem() -> Void {
        if dataArray.first!.count > 3 {
            let indexPath = IndexPath(item: 2, section: 0)
            dataArray[indexPath.section].remove(at: indexPath.item)
            self.collectionView.deleteItems(at: [indexPath])
        }
    }
    var index:Int = 0
    @objc func insertItem() -> Void {
        let indexPath = IndexPath(item: 2, section: 0)
        let indexPath1 = IndexPath(item: 3, section: 0)
        dataArray[indexPath.section].insert(cellSizes[index%4], at: 2)
        dataArray[indexPath.section].insert(cellSizes[index%4], at: 3)
        self.collectionView.insertItems(at: [indexPath, indexPath1])
        index += 1
    }
    
    @objc func reloadItem() -> Void {
        let newSize = CGSize(width: 100, height: 400)
        
        let indexPath = IndexPath(item: 2, section: 0)
        dataArray[indexPath.section][indexPath.item] = newSize
        self.collectionView.reloadItems(at: [indexPath])
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        collectionView.frame = view.bounds
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension RootViewController: UICollectionViewDelegate{
    
}

extension RootViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let itemSize = dataArray[indexPath.section][indexPath.item]
        let contentWidth = self.view.bounds.width
        var itemHeight: CGFloat = 0.0
        if (itemSize.height > 0 && itemSize.width > 0) {
            itemHeight = (CGFloat(itemSize.height * contentWidth / itemSize.width)).scaleFloor
        }
        print("return itemHeight")
        return CGSize(width: contentWidth, height: itemHeight)
        
    }
}

extension RootViewController: SQCollectionViewWaterfallDelegateLayout{
    func collectionView(_ collectionView: UICollectionView, waterLayout layout: SQCollectionViewWaterfallLayout, itemWidth contentWidth: CGFloat, heightOfItemAt indexPath: IndexPath) -> CGFloat {
        
        let itemSize = dataArray[indexPath.section][indexPath.item]
        
        var itemHeight: CGFloat = 0.0
        if (itemSize.height > 0 && itemSize.width > 0) {
            itemHeight = (CGFloat(itemSize.height * contentWidth / itemSize.width)).scaleFloor
        }
        print("return itemHeight")
        return itemHeight
    }
    
    func collectionView(_ collectionView: UICollectionView, waterLayout layout: SQCollectionViewWaterfallLayout, columnCountFor section: Int) -> Int {
        
        if section == 0{
            return 5
        }else if section == 2{
            return 1
        }
        else if section == 3{
            return 3
        }
        else{
            return 4
        }
    }
}

extension RootViewController: UICollectionViewDataSource{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return dataArray.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArray[section].count
    }
  
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! SQCollectionViewCell
        
        cell.backgroundColor = UIColor.yellow
        cell.label.text = "\(indexPath.section),\(indexPath.item)"
        print("return cell")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        var reusableView:UICollectionReusableView
        if kind == SQCollectionElementKindSectionHeader{
            reusableView = collectionView.dequeueReusableSupplementaryView(ofKind: SQCollectionElementKindSectionHeader, withReuseIdentifier: "header", for: indexPath)
            (reusableView as! SQCollectionViewHeader).label.text = "\(indexPath.section),\(indexPath.item)"
        }else if kind == SQCollectionElementKindSectionFooter{
            reusableView = collectionView.dequeueReusableSupplementaryView(ofKind: SQCollectionElementKindSectionFooter, withReuseIdentifier: "footer", for: indexPath)
        }else{
            reusableView = collectionView.dequeueReusableSupplementaryView(ofKind: "", withReuseIdentifier: "", for: indexPath)
        }
        return reusableView
    }
    
}
