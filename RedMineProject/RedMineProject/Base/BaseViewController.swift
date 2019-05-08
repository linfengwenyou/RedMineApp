//
//  BaseViewController.swift
//  RedMineProject
//
//  Created by fumi on 2019/5/8.
//  Copyright © 2019 rayor. All rights reserved.
//

import Cocoa

class BaseViewController: NSViewController {
    
    static func loadViewController(_ identifier:String) -> NSViewController {
        let storyboard = NSStoryboard(name: NSStoryboard.Name("Main"), bundle: nil)
        let identifier = NSStoryboard.SceneIdentifier(identifier)
        guard let vc = storyboard.instantiateController(withIdentifier: identifier) as? NSViewController else {
            fatalError("construct vc faile")
        }
        return vc
    }
    
}
