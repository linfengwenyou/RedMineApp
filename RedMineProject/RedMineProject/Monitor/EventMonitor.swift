
//
//  EventMonitor.swift
//  RedMineProject
//
//  Created by fumi on 2019/5/7.
//  Copyright © 2019 rayor. All rights reserved.
//
import Cocoa
import Foundation
/** 用来处理，点击屏幕外的区域隐藏当前选框 */
class EventMonitor {
    
    private var monitor: Any?
    private let mask: NSEvent.EventTypeMask
    private let handler: (NSEvent?) -> Void
    
    init(mask: NSEvent.EventTypeMask, handler: @escaping (NSEvent?) -> Void) {
        self.mask = mask
        self.handler = handler
    }
    
    deinit {
        
    }
    
    func start()  {
        monitor = NSEvent.addGlobalMonitorForEvents(matching: mask, handler: handler)
    }
    
    func stop() {
        if monitor != nil {
            NSEvent.removeMonitor(monitor!)
            monitor = nil
        }
    }
    
}

