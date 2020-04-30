//
//  CheckView.swift
//  Custom photo albums
//
//  Created by Aleksandr Tsebrii on 5/1/20.
//  Copyright © 2020 Aleksandr Tsebrii. All rights reserved.
//

import UIKit

class CheckView: UIView {
    
    // MARK: Initializate
    
    // Only override draw() if you perform custom drawing. An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        
        // Draw border
        drawLineFromPoint(startPoint: CGPoint(x: rect.minX, y: rect.minY),
                          endPoint: CGPoint(x: rect.maxX, y: rect.minY),
                          lineWidth: 1.0)
        drawLineFromPoint(startPoint: CGPoint(x: rect.maxX, y: rect.minY),
                          endPoint: CGPoint(x: rect.maxX, y: rect.maxY),
                          lineWidth: 1.0)
        drawLineFromPoint(startPoint: CGPoint(x: rect.maxX, y: rect.maxY),
                          endPoint: CGPoint(x: rect.minX, y: rect.maxY),
                          lineWidth: 1.0)
        drawLineFromPoint(startPoint: CGPoint(x: rect.minX, y: rect.maxY),
                          endPoint: CGPoint(x: rect.minX, y: rect.minY),
                          lineWidth: 1.0)
        
        // Draw check
        drawLineFromPoint(startPoint: CGPoint(x: rect.maxX * 0.2, y: rect.maxY * 0.6),
                          endPoint: CGPoint(x: rect.midX + 1, y: rect.maxY * 0.8),
                          lineWidth: 3.0)
        drawLineFromPoint(startPoint: CGPoint(x: rect.midX - 1, y: rect.maxY * 0.8),
                          endPoint: CGPoint(x: rect.maxX * 0.8, y: rect.maxY * 0.2),
                          lineWidth: 3.0)
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        translatesAutoresizingMaskIntoConstraints = false
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: Helper
    
    func drawLineFromPoint(startPoint: CGPoint, endPoint:CGPoint, lineWidth: CGFloat) {
        
        // Design the path
        let path = UIBezierPath()
        path.move(to: startPoint)
        path.addLine(to: endPoint)
        
        // Design path in layer
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = UIColor.white.cgColor
        shapeLayer.lineWidth = lineWidth
        
        layer.addSublayer(shapeLayer)
        
    }
    
}
