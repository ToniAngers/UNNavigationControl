//
//  CollectionViewController.swift
//  UnderNavBarView
//
//  Created by Anton Voropaev on 10/21/16.
//  Copyright © 2016 Anton Voropaev. All rights reserved.
//

import UIKit


class CollectionViewController: UIViewController, UnderNavBarViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    var titles:[String] = Array()
    var underView: UnderNavBarView!
    var triangleView:UIView? = nil
    var collection: UICollectionView!
    
    var indexPathNextCell:NSIndexPath!
    
    var controllersStack : [UIViewController]!
    
    var customOffset: NSInteger = 0
    
    var deltaOfset:CGFloat = 0
    var lastContentOffset: CGFloat = 0
    
    
    enum ScrollDirection {
        case ScrollDirectionRight
        case ScrollDirectionLeft
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.whiteColor()
        self.title = "Navigation SubView"
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .Horizontal
        
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.minimumLineSpacing = 0;
        
        let collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: flowLayout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.cyanColor()
        collectionView.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        collectionView.alwaysBounceHorizontal = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.pagingEnabled = true
        
        self.collection = collectionView
        
        self.view.addSubview(collectionView)
        
        self.titles = ["Challenges", "Ranking", "Something", "Challenges", "Ranking", "Something"]
        let underView = UnderNavBarView(titles:self.titles, type: .navBarTypeGreen)
        underView.delegate = self
        self.triangleView = underView.triangleView!
        self.underView = underView
        self.view.addSubview(underView)
        
        
        controllerCreation()
        
    }
    
    func controllerCreation()  { // Content Creation
        
        let VC1 = Controller1()
        let VC2 = Controller2()
        let VC3 = Controller3()
        let VC4 = Controller4()
        let VC5 = Controller5()
        let VC6 = Controller6()
        
        
        self.controllersStack = [VC1, VC2, VC3, VC4, VC5, VC6]
    }
    
    //MARK: UICollectionViewDataSourse&Delegate
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.titles.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath)
        let subArray = cell.contentView.subviews
        for item in subArray {
            item.removeFromSuperview()
        }
        
        let VC = self.controllersStack[indexPath.row]
        cell.contentView.addSubview(VC.view)
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        
        
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        let offsetX = scrollView.contentOffset.x
        let width = scrollView.bounds.width
        let page = Int(offsetX/width)
        let percent = (offsetX / width) - CGFloat(page)
        self.underView.moveTo(page, percent: percent)
        
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize
    {
        return CGSizeMake(self.view.frame.width, self.view.frame.height)
    }
    
    //MARK: UnderNavBarDelegate
    
    func itemOnSubNavigationBarSelected(sender: UnderNavBarView, index: NSIndexPath) {
        
        showControllerAtIndex(index.row)
    }
    
    func showControllerAtIndex(selectedIndex: Int)  {
        let path = NSIndexPath(forItem: selectedIndex, inSection: 0)
        self.collection.scrollToItemAtIndexPath(path, atScrollPosition: .CenteredHorizontally, animated: true)
    }
    
    
}
