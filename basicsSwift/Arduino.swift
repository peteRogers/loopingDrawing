//
//  Arduino.swift
//  MouseWheelMover
//
//  Created by dt on 25/03/2020.
//  Copyright © 2020 dt. All rights reserved.
//

import Foundation
import ORSSerial

class Arduino:NSObject, ORSSerialPortDelegate{
    var arduinoData: (( [Int]?) -> Void)?
    var serialPort: ORSSerialPort? {
             didSet {
                 oldValue?.close()
                 oldValue?.delegate = nil
                 serialPort?.delegate = self
             }
         }
    
    override init(){
        super.init()
        openOrClosePort()
        
    }
    
    func close(){
        
        self.serialPort?.close()
    }
    
    
    // MARK: serial connection functions
   
    func sendData(string:String) {
           //let s = string + "\n"
             print(string)
           if let data = string.data(using: String.Encoding.utf8) {
               self.serialPort?.send(data)
              
           }
       }
     
     
     func openOrClosePort() {
         print("port closed")
         let availablePorts = ORSSerialPortManager.shared().availablePorts
         print(availablePorts)
         self.serialPort = ORSSerialPort(path: availablePorts[0].path)
         // self.serialPort = availablePorts[0]
         self.serialPort?.baudRate = 115200
         self.serialPort?.open()
         print("port opened")
         
     }
     
     
     
     
     func serialPortWasOpened(_ serialPort: ORSSerialPort) {
         //self.openCloseButton.title = "Close"
         let descriptor = ORSSerialPacketDescriptor(prefixString: "<", suffixString: ">", maximumPacketLength: 8, userInfo: nil)
         serialPort.startListeningForPackets(matching: descriptor)
     }
     
     func serialPortWasClosed(_ serialPort: ORSSerialPort) {
         //self.openCloseButton.title = "Open"
     }
     
    
     
     func serialPort(_ serialPort: ORSSerialPort, didReceivePacket packetData: Data, matching descriptor: ORSSerialPacketDescriptor) {
         if let dataAsString = NSString(data: packetData, encoding: String.Encoding.ascii.rawValue) {
             let valueString = dataAsString.substring(with: NSRange(location: 1, length: dataAsString.length-2))
             
            let stringArray:[String] = valueString.components(separatedBy: ",")
           let intArray = stringArray.compactMap({ Int($0) })
            arduinoData?( intArray)
        }
     }
     
     func serialPortWasRemoved(fromSystem serialPort: ORSSerialPort) {
         self.serialPort = nil
         // self.openCloseButton.title = "Open"
     }
     
     func serialPort(_ serialPort: ORSSerialPort, didEncounterError error: Error) {
         print("SerialPort \(serialPort) encountered an error: \(error)")
     }
     
     func serialPortWasRemovedFromSystem(_ serialPort: ORSSerialPort) {
          self.serialPort = nil
     }
}
