//
//  ViewController.swift
//  basicsSwift
//
//  Created by Peter Rogers on 22/10/2017.
//  Copyright © 2017 gold. All rights reserved.
//

import Cocoa

class ViewController: NSViewController,  NSWindowDelegate{
    
    @IBOutlet weak var canvasView: MyView!
    var displayLink: CVDisplayLink?
    public static var animationQueue: DispatchQueue = DispatchQueue.main
    var arduino:Arduino!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.createDisplayLink()
        // Do any additional setup after loading the view.
        //
        //************************ARDUINO***************
        //code to connect and interact with arduino
        arduino = Arduino()
        arduino.arduinoData = { [unowned self] value in
            
            if let v = self.canvasView{
                v.arduinoValues = value
            }
            
            
        }
    }
    
    
    override func viewDidAppear() {
        view.window?.delegate = self
        super.viewDidAppear()
        
    }
    
    
    func windowShouldClose(_ sender: NSWindow) -> Bool {
        //switch everything off before quitting
        arduino.close()
        
        
        
        NSApplication.shared.terminate(self)
        return true
    }
    
    
    // MARK: control looping redrawing etc
    
    private func createDisplayLink() {
        let error = CVDisplayLinkCreateWithActiveCGDisplays(&displayLink)
        guard let dLink = displayLink, kCVReturnSuccess == error else {
           
            self.displayLink = nil
            return
        }
        
        /// nowTime is the current frame time, and outputTime is when the frame will be displayed.
        CVDisplayLinkSetOutputHandler(dLink) { (_, nowTime, outputTime, _, _) in
            //let fps = (outputTime.pointee.rateScalar * Double(outputTime.pointee.videoTimeScale) / Double(outputTime.pointee.videoRefreshPeriod))
            ViewController.animationQueue.async {
               // self.view.needsDisplay = true
                self.canvasView.needsDisplay = true
            }
            return kCVReturnSuccess
        }
        CVDisplayLinkStart(dLink)
    }
    
}

