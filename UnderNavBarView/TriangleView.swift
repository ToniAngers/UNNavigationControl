//
//  TriangleView.swift
//  UnderNavBarView
//
//  Created by Anton Voropaev on 9/30/16.
//  Copyright © 2016 Anton Voropaev. All rights reserved.
//

import UIKit

class TriangleView: UIView {
    
    var trinagleSuperView: UIView? = nil
    
    
    enum ColorType {
        case ColorTypeGreen
        case ColorTypeWhite
    }
    
    var color:ColorType? = nil
    

    init(view: UIView, type: ColorType, multiplyWidth: Int) {
    
        super.init(frame: CGRectMake(view.frame.origin.x - view.frame.width-10, 30, CGRectGetWidth(view.bounds)*CGFloat(multiplyWidth), 14))
    self.backgroundColor = UIColor.clearColor()
    self.trinagleSuperView = view
        
        
        self.color = type

        view.addSubview(self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
   
    override func drawRect(rect: CGRect) {
        
        let customViewHeight: CGFloat = 1
        let customViewWidth: CGFloat = UIScreen.mainScreen().bounds.width
        
        let plusPath = UIBezierPath()
        plusPath.lineWidth = customViewHeight
        
        if self.color == .ColorTypeWhite {
            plusPath.moveToPoint(CGPointMake(CGRectGetMaxX(self.bounds), 0))
            plusPath.moveToPoint(CGPointMake(CGRectGetMaxX(self.bounds), 14))

//          plusPath.addLineToPoint(CGPointMake(CGRectGetMaxX(self.bounds), 15))
            plusPath.addLineToPoint(CGPointMake(self.frame.width/2 + 10, 14))
            plusPath.addLineToPoint(CGPointMake(self.frame.width/2, 5))
            plusPath.addLineToPoint(CGPointMake(self.frame.width/2 - 10, 14))
            plusPath.addLineToPoint(CGPointMake(0, 14))
            plusPath.addLineToPoint(CGPointMake(0, 0))
            UIColor.lightGrayColor().setStroke()
            plusPath.stroke()
            
            
         
            self.layer.shadowColor = UIColor.lightGrayColor().CGColor
            self.layer.shadowOffset = CGSizeMake(0, 1);
            self.layer.shadowOpacity = 2;
            self.layer.shadowRadius = 1.0;
            
        } else {
            //create the path
            plusPath.moveToPoint(CGPointMake(0, 0))
            plusPath.addLineToPoint(CGPointMake(CGRectGetMaxX(self.bounds), 0))
            plusPath.addLineToPoint(CGPointMake(CGRectGetMaxX(self.bounds), 14))
            plusPath.addLineToPoint(CGPointMake(self.frame.width/2 + 10, 14))
            plusPath.addLineToPoint(CGPointMake(self.frame.width/2, 5))
            plusPath.addLineToPoint(CGPointMake(self.frame.width/2 - 10, 14))
            plusPath.addLineToPoint(CGPointMake(0, 14))
            plusPath.addLineToPoint(CGPointMake(0, 0))
            UIColor(red: 0/255, green: 183/255, blue: 30/255, alpha: 1.0).setFill()
            plusPath.fill()
            
            self.layer.shadowColor = UIColor.lightGrayColor().CGColor
            self.layer.shadowOffset = CGSizeMake(0, 1);
            self.layer.shadowOpacity = 2;
            self.layer.shadowRadius = 1.0;
        }
        
        
    }

}
