//
//  TopBotView.swift
//  VerticalMania
//
//  Created by Tom Bluewater on 12/17/16.
//  Copyright © 2016 Tom Bluewater. All rights reserved.
//

import UIKit

class TopBotView3: UIView {
    override func draw(_ rect: CGRect) {
        let tHeight = self.frame.size.height
        let topLayer = CALayer()
        topLayer.frame = CGRect(x: 0.0, y: tHeight - 0.5, width: self.frame.size.width, height: 0.5)
        topLayer.backgroundColor = UIColor.black.cgColor
        topLayer.masksToBounds = true
        self.layer.addSublayer(topLayer)
        
        let bottomLayer = CALayer()
        bottomLayer.frame = CGRect(x: 0.0, y: 0.0, width: self.frame.size.width, height: 0.5)
        bottomLayer.backgroundColor = UIColor.black.cgColor
        bottomLayer.masksToBounds = true
        self.layer.addSublayer(bottomLayer)
    }
}

// used with StationViewController's topView and botView


