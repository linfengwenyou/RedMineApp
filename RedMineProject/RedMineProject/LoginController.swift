//
//  LoginController.swift
//  RedMineProject
//
//  Created by fumi on 2019/5/8.
//  Copyright © 2019 rayor. All rights reserved.
//

import Cocoa

let saveUserKey = "saveUserKey"
let savePassKey = "savePassKey"


class LoginController: BaseViewController {
    @IBOutlet weak var userField: NSTextField!
    @IBOutlet weak var passField: NSTextField!
    
    @IBOutlet weak var statuLabel: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let user = UserDefaults.standard.value(forKey: saveUserKey) as? String,let pass = UserDefaults.standard.value(forKey: savePassKey) as? String {
            self.userField.stringValue = user
            self.passField.stringValue = pass
        }
    }
    
    
    /** 登录 */
    @IBAction func didClickLoginAction(_ sender: Any) {
        
        let user = userField.stringValue.trim
        let pass = passField.stringValue.trim
        
        if user.count > 0, pass.count > 0 {
            LoginManager.preLoginRequest(username: user, password: pass) { (loginSuccess) in
                
                DispatchQueue.main.async {
                    if loginSuccess {   // 登录成功配置
                        guard let appdelegate = NSApplication.shared.delegate as? AppDelegate else {
                            return
                        }
                        appdelegate.popover.contentViewController = ViewController.loadViewController("MainViewController")
                        BugManager.shared.requestShowMyPage()
                        
                        // 记住账号密码
                        UserDefaults.standard.set(user, forKey: saveUserKey)
                        UserDefaults.standard.set(pass, forKey: savePassKey)
                        UserDefaults.standard.synchronize()
                        
                    }
                    self.statuLabel.isHidden = loginSuccess
                }
                
            }
        }
        
    }
    
}


extension String {
    var trim:String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
