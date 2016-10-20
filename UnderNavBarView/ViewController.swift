//
//  ViewController.swift
//  UnderNavBarView
//
//  Created by Anton Voropaev on 9/28/16.
//  Copyright © 2016 Anton Voropaev. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UnderNavBarViewDelegate, UIScrollViewDelegate {
    
     var items:[String] = Array()
     var titles:[String] = Array()

     var underView: UnderNavBarView!
     var tableView:UITableView? = nil
     var triangleView:UIView? = nil
     var scrollView: UIScrollView!
     var controllersStack : [UIViewController]!
    
    
     var indexOfCurrentVC: Int = 0
    
//MARK: LyfeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.whiteColor()
        self.title = "Navigation SubView"
        
        self.scrollView = UIScrollView(frame: self.view.bounds)
        self.scrollView.pagingEnabled = true
        self.scrollView.delegate = self
        self.view.addSubview(self.scrollView)
        
        self.titles = ["Challenges", "Ranking", "Something"]
        
        let underView = UnderNavBarView(titles:self.titles, type: .navBarTypeGreen)
        
        underView.delegate = self
        self.triangleView = underView.triangleView!
        self.underView = underView
        self.view.addSubview(underView)
        fillArrayWithData()
        
        
        let V1:Controller1 = Controller1()
        self.addChildViewController(V1)
        self.scrollView.addSubview(V1.view)
        
        let V2:Controller2 = Controller2()
        self.addChildViewController(V2)
        self.scrollView.addSubview(V2.view)
        
        var V2Frame: CGRect = V2.view.frame
        V2Frame.origin.x = V1.view.frame.maxX
        V2.view.frame = V2Frame
        
        let V3:Controller3 = Controller3()
        self.addChildViewController(V3)
        self.scrollView.addSubview(V3.view)
        var V3Frame: CGRect = V3.view.frame
        V3Frame.origin.x = V2.view.frame.maxX
        V3.view.frame = V3Frame
        
        self.controllersStack = [V1, V2, V3]
        
        self.scrollView.contentSize = CGSizeMake(self.view.frame.width * CGFloat(self.titles.count), V1.view.frame.height)
        
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        tableViewCreation()
        self.view.bringSubviewToFront(self.underView!)
        
    }
  
 //MARK: UITableViewDelegate
    
    func tableViewCreation()  {
        
        let tableView = UITableView(frame: CGRectMake(0, 37, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)), style: .Grouped)
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.clearColor()
        tableView.contentInset = UIEdgeInsetsMake(-20, 0, 0, 0)
        self.scrollView.addSubview(tableView)
        
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("Cell")! as UITableViewCell
        
        cell.textLabel?.text = self.items[indexPath.row]
        
        return cell
        
    }
 //MARK: SubNavigationBarDelegete
    
    func itemOnSubNavigationBarSelected(sender: UnderNavBarView, index: NSIndexPath) {
        
        showControllerAtIndex(index.row)

    }
    
 //MARK: UIScrollViewDelegate
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
       
        if self.underView.tapped == false { //check if cell in collection tapped - moveTriangleTo() doesnt call.
            
            if scrollView.contentOffset.x > 0 {
                let index = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
                self.indexOfCurrentVC = index
                
                let indexPath = NSIndexPath(forItem: indexOfCurrentVC , inSection: 0)
                self.underView.moveTrinagleTo(indexPath)
            }
        }
        print(scrollView.contentOffset)
        
    }
    
    
    
    
    
    
 //MARK: Help functions
    
    func fillArrayWithData() {
        
        self.items.append("HELLO1")
        self.items.append("HELLO2")
        self.items.append("HELLO3")
        self.items.append("HELLO4")
        self.items.append("HELLO5")
        self.items.append("HELLO6")
    }
    
    
    func showControllerAtIndex(selectedIndex: Int)  {
        
        let selectedVC = self.controllersStack[selectedIndex]
        self.scrollView.scrollRectToVisible(selectedVC.view.frame, animated: true)
        
        
    }
    
    
   
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

