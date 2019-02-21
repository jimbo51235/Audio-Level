//
//  TestView.swift
//  Spying Cam Cloud
//
//  Created by Kimberly on 8/17/18.
//  Copyright © 2018 Tom Bluewater. All rights reserved.
//

import UIKit

class TestView: UIView {
    var bottom = CGFloat()
    var oneCent = CGFloat()
    var myLayer = CALayer()
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let selfFrame = self.frame
        let path = UIBezierPath()
        let myWidth = selfFrame.size.width * 0.8
        let myHeight = selfFrame.size.height * 0.8
        path.move(to: CGPoint(x: (selfFrame.size.width - myWidth) * 0.5, y: (selfFrame.size.height - myHeight) * 0.5)) // top left
        path.addLine(to: CGPoint(x: (selfFrame.size.width - myWidth) * 0.5, y: (selfFrame.size.height - myHeight) * 0.5 + myHeight)) // bottom left
        path.addLine(to: CGPoint(x: (selfFrame.size.width - myWidth) * 0.5 + myWidth, y: (selfFrame.size.height - myHeight) * 0.5 + myHeight)) // bottom right
        path.addLine(to: CGPoint(x: (selfFrame.size.width - myWidth) * 0.5 + myWidth, y: (selfFrame.size.height - myHeight) * 0.5)) // top right
        path.close()
        UIColor.green.setStroke()
        path.lineWidth = 2.0
        path.stroke()
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .right
        let attributes = [
            NSAttributedString.Key.paragraphStyle: paragraphStyle,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12.0),
            NSAttributedString.Key.foregroundColor: UIColor.white
        ]
        
        let top = (selfFrame.size.height - myHeight) * 0.5
        let bot = (selfFrame.size.height - myHeight) * 0.5 + myHeight
        let diff = bot - top
        let left = (selfFrame.size.width - myWidth) * 0.5
        let right = (selfFrame.size.width - myWidth) * 0.5  + myWidth
        let measurement = diff/10.0
        for num in stride(from: top + measurement, to: bot, by: measurement) {
            let mPath = UIBezierPath()
            mPath.move(to: CGPoint(x: left, y: num))
            mPath.addLine(to: CGPoint(x: right, y: num))
            mPath.close()
            UIColor.green.withAlphaComponent(0.4).setStroke()
            mPath.lineWidth = 1.0
            mPath.stroke()
        }
        
        var count = 0
        for num in stride(from: top, to: bot + measurement, by: measurement) {
            let mPath = UIBezierPath()
            mPath.move(to: CGPoint(x: left, y: num))
            mPath.addLine(to: CGPoint(x: right, y: num))
            mPath.close()
            UIColor.green.withAlphaComponent(0.5).setStroke()
            mPath.lineWidth = 1.0
            mPath.stroke()
            
            let myText = NSString(format: "%i", 0 - count * 12) as String
            let attributedString = NSAttributedString(string: myText, attributes: attributes)
            attributedString.draw(at: CGPoint(x: left - 30.0, y: num - 6.0))
            count += 1
        }
        
        /* variables */
        oneCent = diff/120.0
        bottom = bot
    }
    
    func makeLayer(num: CGFloat) -> Void {
        myLayer.removeFromSuperlayer()
        
        let selfFrame = self.frame
        let middle = selfFrame.size.width / 2.0
        myLayer.frame = CGRect(x: middle - 25.0, y: bottom - num * oneCent, width: 50.0, height: num * oneCent)
        myLayer.backgroundColor = UIColor.red.cgColor
        self.layer.addSublayer(myLayer)
    }
    
    func removeLayer() {
        myLayer.removeFromSuperlayer()
    }
}

