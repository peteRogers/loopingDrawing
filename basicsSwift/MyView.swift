//
//  MyView.swift
//  basicsSwift
//
//  Created by Peter Rogers on 22/10/2017.
//  Copyright © 2017 gold. All rights reserved.
//

import Foundation

import Cocoa

class MyView: NSView {
    
    var arduinoValues:[Int]?
    //to load an image first create a variable like this
    var myImage:CGImage!
    
   
    func setup(){
        //load your image like the line below
        myImage = loadImage(name:"filename.png")
        
    }

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
       
        //draws image based upon the rotary encoder
        canvas?.draw(myImage, in: CGRect(x: arduinoValues?.item(at: 0) ?? 0, y: 100, width: 100, height: 100 ))
        //set fill color
        canvas?.setFillColor(CGColor(red: 1, green: 0, blue: 0, alpha: 1))
        //fill an ellipse
        canvas?.fillEllipse(in: CGRect(x: 200, y: 200, width: 100, height: 100))
        //draw a bit of text
        drawText(text: "hello", position: CGPoint(x: 200, y: 200), fontSize: 70, color: NSColor.red)
        
    }
    
//************no need to work with code below here****************
    
    
    
    
//MARK: below are internal
    
    var canvas: CGContext? {
           return NSGraphicsContext.current?.cgContext
       }
    
    override func mouseDown(with theEvent : NSEvent) {
        print("left mouse")
        let mousePos = theEvent.locationInWindow
        print(mousePos.y)
        //drawCircle()
        
    }
    
    override func mouseUp(with event: NSEvent) {
         print("left mouse up")
    }
    
    public func arduinoEvent(a: [Int]){
        self.arduinoValues = a
    }
    
     func loadImage(name:String)->CGImage{
        if let im = NSImage(named: name){
            return im.cgImage(forProposedRect: nil, context: nil, hints: nil)!
        }
      
            
        let im = NSImage(named: "x.png")
        return im!.cgImage(forProposedRect: nil, context: nil, hints: nil)!
            
    
                
    }
    
    func drawText(text:String, position:CGPoint, fontSize:CGFloat, color:NSColor){
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center

        let attrs = [
         NSAttributedString.Key.font: NSFont.systemFont(ofSize: fontSize),
         NSAttributedString.Key.paragraphStyle: paragraphStyle,
         NSAttributedString.Key.foregroundColor: color]

        
       text.draw(at: position, withAttributes: attrs)
}
    
   // override var isFlipped: Bool { return true }
    required init?(coder aDecoder: NSCoder) {
         
           super.init(coder: aDecoder)
    
           setup()
          
       }
     
    
}

//extension NSBezierPath {
//
//    /// A `CGPath` object representing the current `NSBezierPath`.
//    var cgPath: CGPath {
//        let path = CGMutablePath()
//        let points = UnsafeMutablePointer<NSPoint>.allocate(capacity: 3)
//        let elementCount = self.elementCount
//
//        if elementCount > 0 {
//            var didClosePath = true
//
//            for index in 0..<elementCount {
//                let pathType = self.element(at: index, associatedPoints: points)
//
//                switch pathType {
//                case .moveTo:
//                    path.move(to: CGPoint(x: points[0].x, y: points[0].y))
//                case .lineTo:
//                    path.addLine(to: CGPoint(x: points[0].x, y: points[0].y))
//                    didClosePath = false
//                case .curveTo:
//                    let control1 = CGPoint(x: points[1].x, y: points[1].y)
//                    let control2 = CGPoint(x: points[2].x, y: points[2].y)
//                    path.addCurve(to: CGPoint(x: points[0].x, y: points[0].y), control1: control1, control2: control2)
//                    didClosePath = false
//                case .closePath:
//                    path.closeSubpath()
//                    didClosePath = true
//                }
//            }
//
//            if !didClosePath { path.closeSubpath() }
//        }
//
//        points.deallocate()
//        return path
//    }
//}
//
extension Array {

    func item(at index: Int) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
    
    






