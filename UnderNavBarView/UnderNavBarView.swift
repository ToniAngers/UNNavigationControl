//
//  UnderNavBarView.swift
//  UnderNavBarView
//
//  Created by Anton Voropaev on 9/28/16.
//  Copyright © 2016 Anton Voropaev. All rights reserved.
//

import UIKit

protocol UnderNavBarViewDelegate: class {
    func itemOnSubNavigationBarSelected(sender: UnderNavBarView, index: NSIndexPath)
}


class UnderNavBarView: UIView, UICollectionViewDelegate,
    UICollectionViewDataSource,
    UICollectionViewDelegateFlowLayout,
UIScrollViewDelegate   {
    
    enum navBarType {
        case navBarTypeGreen
        case navBarTypeWhite
    }
    
    enum ScrollDirection {
        case ScrollDirectionRight
        case ScrollDirectionLeft
    }
    
    weak var delegate:UnderNavBarViewDelegate? //collectionView Item pressed
    var titles:[String]?
    var triangleView: TriangleView? = nil
    var navBarColorType:navBarType? = nil
    var deltaOfset:CGFloat = 0
    var lastContentOffset: CGFloat = 0
    var wholeTextWidth: CGFloat = 0
    var padding: CGFloat = 0
//    var selectedCellCenter:CGPoint!
    var myCollecion: UICollectionView? = nil
    var tapped: Bool  = false
    
    init(titles: [String], type: navBarType) {
        
        super.init(frame: CGRectMake(0, 0, CGRectGetWidth(UIScreen.mainScreen().bounds), 44))
        self.navBarColorType = type
        self.titles = titles
        
        self.backgroundColor = UIColor.clearColor()
        let index = NSIndexPath(forItem: 0, inSection: 0)
        
        collectionViewCreation(selectedItem: index, navType:type)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    //TODO: Change font
    
    func collectionViewCreation(selectedItem itemIndexPath: NSIndexPath?, navType:navBarType)  {
        
        for text in self.titles! {
            let sizeOfText = giveMeSizeOfText(text, font: UIFont(name: "Helvetica", size: 13))
            self.wholeTextWidth  += sizeOfText.width
        }
        let size = UIScreen.mainScreen().bounds.width - self.wholeTextWidth
        var padding : CGFloat = 40
        self.padding = padding
        
        if self.titles != nil {
            padding = size / CGFloat(self.titles!.count+1)
            self.padding = padding
            if self.padding < 40 {
                padding = 40
                self.padding = padding
            }
        }
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        
        layout.sectionInset = UIEdgeInsets(top: 0, left: padding, bottom:0, right: padding)
        layout.scrollDirection = .Horizontal
        
        let frame = CGRectMake(0, 0, self.bounds.width, 30)
        let collection = UICollectionView(frame: frame, collectionViewLayout: layout)
        collection.delegate = self
        collection.dataSource = self
        self.myCollecion = collection
        
        if navType == navBarType.navBarTypeGreen {
            collection.backgroundColor = UIColor(red: 0/255, green: 183/255, blue: 30/255, alpha: 1.0) /* #00b71e */
        } else {
            collection.backgroundColor = UIColor.whiteColor()
        }
        
        collection.contentSize = CGSizeMake(UIScreen.mainScreen().bounds.width, 30) //????
        collection.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
        collection.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        collection.alwaysBounceHorizontal = true
        collection.showsHorizontalScrollIndicator = false
        collection.selectItemAtIndexPath(itemIndexPath, animated: true, scrollPosition: .None)
        
        let compareWidth = self.wholeTextWidth + (self.padding * (CGFloat(self.titles!.count)+1))
        
        if compareWidth < UIScreen.mainScreen().bounds.width {
            collection.scrollEnabled = false
        } else {
            collection.scrollEnabled = true
        }
        
        self.addSubview(collection)
        
        let triangleView = TriangleView(view: self, type: .ColorTypeGreen, multiplyWidth: self.titles!.count)
        self.triangleView = triangleView
        
        let myCollectionViewcell =  collection.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: itemIndexPath!)
        let itemCenter = myCollectionViewcell.center
        self.triangleView?.center = CGPointMake(itemCenter.x, (self.triangleView?.center.y)!)
        self.deltaOfset = collection.contentOffset.x
    }
    
    //MARK: - UICollectionViewDataSource
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return (self.titles?.count)!
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath)
        let subArray = cell.contentView.subviews
        for item in subArray {
            item.removeFromSuperview()
        }
        
        let label = UILabel(frame: CGRectMake(0, 0, 50, 40))
        
        label.text = titles![indexPath.row]
        label.font = UIFont(name: "Helvetica", size: 13)
        
        if navBarColorType == .navBarTypeWhite {
            label.textColor = UIColor.lightGrayColor()
        } else {
            
            label.textColor = UIColor.whiteColor()
        }
        
        label.sizeToFit()
        cell.contentView.addSubview(label)
        return cell
    }
    
    //MARK: UICollectionViewDelegateFlowLayout
    
    func collectionView(collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                               sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        //        let text = titles![indexPath.row]
        //        lableProp = UILabel()
        //        lableProp?.text = text
        
        let size = giveMeSizeOfText(self.titles![(indexPath.row)], font: UIFont(name: "Helvetica", size: 13))
        
        return  size //(lableProp?.intrinsicContentSize())!
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return self.padding
    }
    
    //MARK: UICollectionViewDelegate
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        self.tapped = true
        
        let tappedCollectionViewcell =  collectionView.cellForItemAtIndexPath(indexPath)
        let tappedCollectionViewCellCenter = tappedCollectionViewcell!.center
//        let pointOnSelf = self.convertPoint(tappedCollectionViewCellCenter, fromView: tappedCollectionViewcell)
        
        UIView.animateWithDuration(0.3, animations: {
            self.triangleView?.center = CGPointMake(tappedCollectionViewCellCenter.x - self.lastContentOffset, (self.triangleView?.center.y)!)
        }) { (true) in
            self.tapped = false
        }
        self.delegate?.itemOnSubNavigationBarSelected(self, index: indexPath)
    }
    
    //MARK: UIScrollViewDelegate
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        var scrollDirection: ScrollDirection
        
        if (self.lastContentOffset > scrollView.contentOffset.x) {
            scrollDirection = .ScrollDirectionRight;
            self.deltaOfset = scrollView.contentOffset.x - self.lastContentOffset
            self.triangleView?.center.x -= self.deltaOfset
            
        }
        else if (self.lastContentOffset < scrollView.contentOffset.x) {
            scrollDirection = .ScrollDirectionLeft;
            self.deltaOfset = self.lastContentOffset - scrollView.contentOffset.x
            
            self.triangleView?.center.x += self.deltaOfset
        }
        
        self.lastContentOffset = scrollView.contentOffset.x;
    }
    

    func indexPathForLastCell() -> NSIndexPath {
        
        return NSIndexPath(forRow: self.titles!.count - 1, inSection: 0)
    }
    

    func giveMeSizeOfText(string: String, font: UIFont!) -> CGSize { //Calculation text size for UILable
        
        var sizeOfString = CGSize()
        
        if let font = font
        {
            let text = string
            let fontAttributes = [NSFontAttributeName: font]
            sizeOfString = (text as NSString).sizeWithAttributes(fontAttributes)
        }
        return sizeOfString
    }
    
    func moveTo(index: Int, percent: CGFloat) {
        
        let path = NSIndexPath(forItem: index, inSection: 0)
        
        self.myCollecion?.scrollToItemAtIndexPath(path, atScrollPosition: .CenteredHorizontally, animated: true)
        
        if self.tapped == false {
            
            let itemsCount = self.myCollecion!.numberOfItemsInSection(0)
            
            if index >= 0 && index < itemsCount {
                var indexPath = NSIndexPath(forItem: index, inSection: 0)
                let currentCell = self.myCollecion!.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath)
                let currentCellCenterX = currentCell.center.x - self.lastContentOffset
                
                var nextCellCenterX : CGFloat = 0.0
                if index + 1 != itemsCount {
                    indexPath = NSIndexPath(forItem: index + 1, inSection: 0)
                    let nextCell = self.myCollecion!.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath)
                    nextCellCenterX = nextCell.center.x  - self.lastContentOffset
                } else {
                    nextCellCenterX = self.myCollecion!.bounds.width
                }
                
                let difference = (nextCellCenterX - currentCellCenterX) * percent
                
                let centerY = self.triangleView!.center.y
                self.triangleView?.center = CGPointMake(currentCellCenterX + difference, centerY)
            }
            
        }
    }
    
}
