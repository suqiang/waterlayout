//
//  SQCollectionViewWaterfallLayout.swift
//  wulewa
//
//  Created by 苏强 on 2017/10/12.
//  Copyright © 2017年 苏强. All rights reserved.
//

import UIKit

@objc protocol SQCollectionViewWaterfallDelegateLayout: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView,
                        waterLayout layout: SQCollectionViewWaterfallLayout,
                        itemWidth contentWidth: CGFloat,
                        heightOfItemAt indexPath: IndexPath) -> CGFloat
    
    @objc optional func collectionView(_ collectionView: UICollectionView,
                        waterLayout layout: SQCollectionViewWaterfallLayout,
                        columnCountFor section: Int) -> Int
    
    @objc optional func collectionView(_ collectionView: UICollectionView,
                        waterLayout layout: SQCollectionViewWaterfallLayout,
                        heightForHeaderIn section: Int) -> CGFloat
    
    @objc optional func collectionView(_ collectionView: UICollectionView,
                        waterLayout layout: SQCollectionViewWaterfallLayout,
                        heightForFooterIn section: Int) -> CGFloat
    
    @objc optional func collectionView(_ collectionView: UICollectionView,
                        waterLayout layout: SQCollectionViewWaterfallLayout,
                        insetFor section: Int) -> UIEdgeInsets
    
    @objc optional func collectionView(_ collectionView: UICollectionView,
                        waterLayout layout: SQCollectionViewWaterfallLayout,
                        insetForHeaderIn section: Int) -> UIEdgeInsets
    
    @objc optional func collectionView(_ collectionView: UICollectionView,
                        waterLayout layout: SQCollectionViewWaterfallLayout,
                        insetForFooterIn section: Int) -> UIEdgeInsets
    
    @objc optional func collectionView(_ collectionView: UICollectionView,
                        waterLayout layout: SQCollectionViewWaterfallLayout,
                        minimumInteritemSpacingFor section: Int) -> CGFloat
    
    @objc optional func collectionView(_ collectionView: UICollectionView,
                        waterLayout layout: SQCollectionViewWaterfallLayout,
                        minimumColumnSpacingFor section: Int) -> CGFloat
}

let unionSize = 20;
let SQCollectionElementKindSectionHeader = "SQCollectionElementKindSectionHeader"
let SQCollectionElementKindSectionFooter = "SQCollectionElementKindSectionFooter"
class SQCollectionViewWaterfallLayout: UICollectionViewLayout {
    
    public var columnCount: Int = 2 {
        didSet{
            if columnCount != oldValue{
                invalidateLayout()
            }
        }
    }
    public var minimumColumnSpacing: CGFloat = 5.0{
        didSet{
            if minimumColumnSpacing != oldValue{
                invalidateLayout()
            }
        }
    }
    
    public var minimumInteritemSpacing: CGFloat = 5.0{
        didSet{
            if minimumInteritemSpacing != oldValue{
                invalidateLayout()
            }
        }
    }
    
    public var headerHeight: CGFloat = 0.0{
        didSet{
            if headerHeight != oldValue{
                invalidateLayout()
            }
        }
    }
    
    public var footerHeight: CGFloat = 0.0{
        didSet{
            if footerHeight != oldValue{
                invalidateLayout()
            }
        }
    }
    
    public var headerInset = UIEdgeInsets.zero{
        didSet{
            if headerInset != oldValue{
                invalidateLayout()
            }
        }
    }
    
    public var footerInset = UIEdgeInsets.zero{
        didSet{
            if footerInset != oldValue{
                invalidateLayout()
            }
        }
    }
    
    public var sectionInset = UIEdgeInsets.zero{
        didSet{
            if sectionInset != oldValue{
                invalidateLayout()
            }
        }
    }
    
    public var minimumContentHeight: CGFloat = 0.0{
        didSet{
            if minimumContentHeight != oldValue{
                invalidateLayout()
            }
        }
    }
    
    public var sectionHeadersPinToVisibleBounds = false{
        didSet{
            if sectionHeadersPinToVisibleBounds != oldValue{
                invalidateLayout()
            }
        }
    }
    
    fileprivate var columnHeights = [[CGFloat]]()
    fileprivate lazy var sectionItemAttributes = [[UICollectionViewLayoutAttributes]]()
    fileprivate lazy var allItemAttributes = [UICollectionViewLayoutAttributes]()
    fileprivate lazy var headersAttributeDict = [Int:UICollectionViewLayoutAttributes]()
    fileprivate lazy var footersAttributeDict = [Int:UICollectionViewLayoutAttributes]()
    fileprivate lazy var unionRects = [CGRect]()
    fileprivate lazy var animationIndexPaths = [IndexPath]()
    fileprivate lazy var sectionHeightDict = [Int:CGFloat]()
    
    fileprivate var delegate:SQCollectionViewWaterfallDelegateLayout? {
        get{
            return collectionView?.delegate as? SQCollectionViewWaterfallDelegateLayout
        }
    }
    
    override func prepare() {
        
        super.prepare()
        headersAttributeDict.removeAll()
        footersAttributeDict.removeAll()
        columnHeights.removeAll()
        allItemAttributes.removeAll()
        sectionItemAttributes.removeAll()
        unionRects.removeAll()
        
        guard  let numberOfSections = collectionView?.numberOfSections, numberOfSections > 0 else {
            return
        }
    
        for section in 0 ..< numberOfSections{
            columnHeights.append(Array<CGFloat>(repeating: 0.0, count: columnCountForSection(section)))
        }
        var top: CGFloat = 0.0
        var privousTop :CGFloat = 0.0
        var attributes: UICollectionViewLayoutAttributes
        
        for section in 0 ..< numberOfSections {
            
            let itemCount = collectionView!.numberOfItems(inSection: section)
            
            // if section doesn't hava any item, do not render this section (include header and footer)
            if(itemCount <= 0){
                continue
            }

            let minimumInteritemSpacing = delegate?.collectionView?(collectionView!, waterLayout: self, minimumInteritemSpacingFor: section) ?? self.minimumInteritemSpacing
            
            let columnSpacing = delegate?.collectionView?(collectionView!, waterLayout: self, minimumColumnSpacingFor: section) ?? self.minimumColumnSpacing
         
            let sectionInset = delegate?.collectionView?(collectionView!, waterLayout: self, insetFor: section) ?? self.sectionInset
            
            let width = CGFloat(collectionView!.bounds.width - sectionInset.left - sectionInset.right)
            
            let columnCount = columnCountForSection(section)
            
            let itemWidth = ((width - CGFloat(columnCount - 1) * columnSpacing) / CGFloat(columnCount));
            
            let headerHeight = delegate?.collectionView?(collectionView!, waterLayout: self, heightForHeaderIn: section) ?? self.headerHeight
            
            let headerInset = delegate?.collectionView?(collectionView!, waterLayout: self, insetForHeaderIn: section) ?? self.headerInset
            
            top += headerInset.top
            
            if headerHeight > 0{
                attributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: SQCollectionElementKindSectionHeader, with: IndexPath(item: 0, section: section))
                attributes.frame = CGRect(x: headerInset.left,
                                          y: top,
                                          width: collectionView!.bounds.width - headerInset.left - headerInset.right,
                                          height: headerHeight)
                attributes.zIndex = 2 + section
                headersAttributeDict[section] = attributes
                allItemAttributes.append(attributes)
                top = attributes.frame.maxY + headerInset.bottom
            }
            top += sectionInset.top
            
            for column in 0 ..< columnCount{
                columnHeights[section][column] = top
            }
            
            var itemAttributes = [UICollectionViewLayoutAttributes]()
            
            for item in 0 ..< itemCount {
                let indexPath = IndexPath(item: item, section: section)
                let columnIndex = nextColumnIndexForItem(item, inSection: section)
                let xOffset = sectionInset.left + (itemWidth + columnSpacing) * CGFloat(columnIndex)
                let yOffset = columnHeights[section][columnIndex]
                let itemHeight = delegate?.collectionView(collectionView!, waterLayout: self, itemWidth:itemWidth, heightOfItemAt: indexPath) ?? 0
        
                attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                attributes.frame = CGRect(x: xOffset, y: yOffset, width: itemWidth, height: itemHeight)
                itemAttributes.append(attributes)
                allItemAttributes.append(attributes)
                columnHeights[section][columnIndex] = attributes.frame.maxY + minimumInteritemSpacing
            }
            
            self.sectionItemAttributes.append(itemAttributes)
            
            let columnIndex = longestColumnIndexInSection(section)
            if columnHeights[section].isEmpty == false{
                top = columnHeights[section][columnIndex] - minimumInteritemSpacing + sectionInset.bottom
            }else{
                top = 0
            }
            
            let footerHeight = delegate?.collectionView?(collectionView!, waterLayout: self, heightForFooterIn: section) ?? self.footerHeight
            
            let footerInset = delegate?.collectionView?(collectionView!, waterLayout: self, insetForFooterIn: section) ?? self.footerInset
            
            top += footerInset.top
            
            if footerHeight > 0{
                attributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: SQCollectionElementKindSectionFooter, with: IndexPath(item: 0, section: section))
                attributes.zIndex = 1 + section
                attributes.frame = CGRect(x: footerInset.left,
                                          y: top,
                                          width: collectionView!.bounds.width - footerInset.left - footerInset.right,
                                          height: footerHeight)
                footersAttributeDict[section] = attributes
                allItemAttributes.append(attributes)
                
                top = attributes.frame.maxY + footerInset.bottom
                
            }
            
            for index in 0..<columnCount{
                columnHeights[section][index] = top;
            }
            
            sectionHeightDict[section] = top - privousTop
            privousTop = top
        }

        let itemCounts = allItemAttributes.count
        var index = 0
        while(index < itemCounts){
            var unionRect = allItemAttributes[index].frame
            let rectEndIndex = min(index + unionSize, itemCounts)
            for i in index+1 ..< rectEndIndex{
                unionRect = unionRect.union(allItemAttributes[i].frame)
            }
            index = rectEndIndex
            unionRects.append(unionRect)
        }
        
    }
    
    
    override var collectionViewContentSize: CGSize{
        guard let numberOfSections = collectionView?.numberOfSections, numberOfSections > 0 else {
            return CGSize.zero
        }
        
        var contentSize = collectionView!.bounds.size
    
        contentSize.height = columnHeights.last!.max() ?? 0.0

        if contentSize.height < minimumContentHeight{
            contentSize.height = minimumContentHeight
        }
        
        return contentSize
    }
    
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        
        if indexPath.section >= self.sectionItemAttributes.count {
            return nil
        }
        
        if indexPath.item >= self.sectionItemAttributes[indexPath.section].count{
            return nil
        }
        
        return sectionItemAttributes[indexPath.section][indexPath.item]
    }
    
    
    override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        
        var attribute: UICollectionViewLayoutAttributes?
        
        let section = indexPath.section
        
        if elementKind == SQCollectionElementKindSectionHeader  {
            attribute = headersAttributeDict[section];
        }else if elementKind == SQCollectionElementKindSectionFooter {
            attribute = footersAttributeDict[section];
        }
        
        return attribute
        
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
    
        var begin = 0, end = unionRects.count
        
        var cellAttrDict = [IndexPath:UICollectionViewLayoutAttributes]()
        var supplHeaderAttrDict = [IndexPath:UICollectionViewLayoutAttributes]()
        var supplFooterAttrDict = [IndexPath:UICollectionViewLayoutAttributes]()
        var decorAttrDict = [IndexPath:UICollectionViewLayoutAttributes]()

        
        for  (i, unionRect) in unionRects.enumerated() {
            if rect.intersects(unionRect){
                begin = i * unionSize
                break
            }
        }
        
        for (i, unionRect) in unionRects.enumerated().reversed(){
            if rect.intersects(unionRect){
                end = min((i + 1) * unionSize, allItemAttributes.count)
                break
            }
        }
        
        let contentInset = collectionView!.contentInset
        
        for i  in begin ..< end{
            let attr = allItemAttributes[i]
            if rect.intersects(attr.frame){
                switch(attr.representedElementCategory){
                case UICollectionElementCategory.supplementaryView:
                    if (attr.representedElementKind == SQCollectionElementKindSectionHeader) {
                        supplHeaderAttrDict[attr.indexPath] = attr
                    } else if (attr.representedElementKind == SQCollectionElementKindSectionFooter) {
                        supplFooterAttrDict[attr.indexPath] = attr
                    }
                    break
                case UICollectionElementCategory.decorationView:
                    decorAttrDict[attr.indexPath] = attr
                    break
                case UICollectionElementCategory.cell:
                    cellAttrDict[attr.indexPath] = attr
                    break
                }
            }
        }
        

        if sectionHeadersPinToVisibleBounds == true {
            for (section, attr) in headersAttributeDict {
                let currentSection = section
                let firstSectionItemAttr = sectionItemAttributes[currentSection].first!
                let currentHeaderHeight = attr.frame.height
                let headerInset = delegate?.collectionView?(collectionView!, waterLayout: self, insetForHeaderIn: currentSection) ?? self.headerInset
                let temp1 = collectionView!.contentOffset.y + contentInset.top + headerInset.top
                let temp2 = firstSectionItemAttr.frame.minY - currentHeaderHeight - headerInset.bottom
                let temp3 = firstSectionItemAttr.frame.minY - currentHeaderHeight * 2 - 2 * headerInset.bottom + sectionHeightDict[currentSection]!
                attr.frame.origin = CGPoint(x:headerInset.left, y:min(max(temp1, temp2), temp3))
                supplHeaderAttrDict[attr.indexPath] = attr
            }
        }
        return Array(cellAttrDict.values) + Array(supplHeaderAttrDict.values) + Array(supplFooterAttrDict.values) + Array(decorAttrDict.values)
    }
    
    
    override func prepare(forCollectionViewUpdates updateItems: [UICollectionViewUpdateItem]) {
        super.prepare(forCollectionViewUpdates: updateItems)

        var indexPaths = [IndexPath]()
        for updateItem in updateItems {
            switch(updateItem.updateAction){
                case .delete:
                    if let indexPath = updateItem.indexPathBeforeUpdate{
                        indexPaths.append(indexPath)
                         print("。。。。。delete(\(indexPath))")
                    }
                case .insert:
                    if let indexPath = updateItem.indexPathAfterUpdate{
                        indexPaths.append(indexPath)
                        print("。。。。。insert(\(indexPath))")
                    }
                case .reload:
                    print("。。。。。reload(\("indexPath"))")
                case .move:
                    print("。。。。。move")
                case .none:
                    print("。。。。。none")
            }
        }

        self.animationIndexPaths.removeAll()
        self.animationIndexPaths.append(contentsOf: indexPaths)
    }

    override func initialLayoutAttributesForAppearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        
        if animationIndexPaths.contains(itemIndexPath) {
            let attribute = sectionItemAttributes[itemIndexPath.section][itemIndexPath.row]
            
            attribute.transform = CGAffineTransform(scaleX: 0.2, y: 0.2).rotated(by: CGFloat.pi)
            attribute.center = CGPoint(x: collectionView!.bounds.midX, y: collectionView!.bounds.maxY)
            attribute.alpha = 1;
            
            animationIndexPaths.remove(at: animationIndexPaths.index(of: itemIndexPath)!)
            return attribute
        }

        return nil
    }
    
    
    override func initialLayoutAttributesForAppearingSupplementaryElement(ofKind elementKind: String, at elementIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        
        var attribute: UICollectionViewLayoutAttributes?
        
        if elementKind == SQCollectionElementKindSectionHeader  {
            attribute = headersAttributeDict[elementIndexPath.section]
        }else if elementKind == SQCollectionElementKindSectionFooter {
            attribute = footersAttributeDict[elementIndexPath.section]
        }
        
        return attribute
        
    }

    override func finalLayoutAttributesForDisappearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        if animationIndexPaths.contains(itemIndexPath) {
            let attribute = sectionItemAttributes[itemIndexPath.section][itemIndexPath.row]
            animationIndexPaths.remove(at: animationIndexPaths.index(of: itemIndexPath)!)
            attribute.transform = CGAffineTransform(scaleX: 2, y: 2).rotated(by: 0)
            attribute.alpha = 0;
            return attribute
        }

        return nil
    }

    override func finalizeCollectionViewUpdates() {
        animationIndexPaths.removeAll()
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        
        guard let oldBounds = collectionView?.bounds else {
            return false
        }
        
        if sectionHeadersPinToVisibleBounds == true {
            return true // 有性能问题
        }
        
        return newBounds.width != oldBounds.width
    }

    override func invalidateLayout(with context: UICollectionViewLayoutInvalidationContext) {
        super.invalidateLayout(with: context)
        
        let ctx = context as! SQCustomInvalidationContext
        
        
 
    }
    
    override func invalidationContext(forBoundsChange newBounds: CGRect) -> UICollectionViewLayoutInvalidationContext {
        let context = super.invalidationContext(forBoundsChange: newBounds) as! SQCustomInvalidationContext
        
        context.attributes = Array(headersAttributeDict.values)
        
        return context
    }
    
    override class var invalidationContextClass: Swift.AnyClass {
        get{
            return SQCustomInvalidationContext.self
        }
        
    }

    fileprivate func nextColumnIndexForItem(_ item:Int, inSection section:Int) -> Int {
        return shortestColumnIndexInSection(item, inSection: section)
    }
    
    fileprivate func shortestColumnIndexInSection(_ item:Int, inSection section:Int) -> Int {
        return columnHeights[section].index(of: columnHeights[section].min()!)!
    }
    
    fileprivate func longestColumnIndexInSection(_ section:Int) -> Int {
        return columnHeights[section].index(of: columnHeights[section].max()!)!
    }
    
    fileprivate func columnCountForSection(_ section:Int) -> Int {
        if let collectionView = collectionView{
            return delegate?.collectionView?(collectionView, waterLayout: self, columnCountFor: section) ?? columnCount
        }
        return columnCount
    }
}

public extension CGFloat{
   public var scaleFloor:CGFloat{
        get{
            return floor(self * CGFloat(UIScreen.main.scale)) / CGFloat(UIScreen.main.scale)
        }
    }
}



class SQCustomInvalidationContext: UICollectionViewLayoutInvalidationContext{
    
//    override init() {
//        super.init()
//    }
    var attributes:[UICollectionViewLayoutAttributes]?
}



