//
//  ViewController.swift
//  UnderNavBarView
//
//  Created by Anton Voropaev on 9/28/16.
//  Copyright © 2016 Anton Voropaev. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UnderNavBarViewDelegate {
    
     var items:[String] = Array()
     var underView:UIView?=nil
     var tableView:UITableView? = nil
     var triangleView:UIView? = nil

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       self.view.backgroundColor = UIColor.whiteColor()
        
        
        let underView = UnderNavBarView(titles: ["Challenges", "Ranking", "Something", "Challenges", "Challenges"], type: .navBarTypeGreen
        )
        underView.delegate = self
        self.triangleView = underView.triangleView!
        
        self.underView = underView
        
        self.view.addSubview(underView)
        
        self.items.append("HELLO1")
        self.items.append("HELLO2")
        self.items.append("HELLO3")
        self.items.append("HELLO4")
        self.items.append("HELLO5")
        self.items.append("HELLO6")
        
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.view.bringSubviewToFront(self.triangleView!)

        tableViewCreation()
    }
    
    func tableViewCreation()  {
        
        let tableView = UITableView(frame: CGRectMake(0, 110, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)), style: .Grouped)
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.clearColor()
        tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
        self.view.addSubview(tableView)
        
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("Cell")! as UITableViewCell
        
        cell.textLabel?.text = self.items[indexPath.row]
        
        return cell
        
    }
    
    func showNewContent(sender: UnderNavBarView, index: NSIndexPath) {
        
    
        
        
    }
   
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

