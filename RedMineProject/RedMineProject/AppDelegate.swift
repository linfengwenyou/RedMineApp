//
//  AppDelegate.swift
//  RedMineProject
//
//  Created by fumi on 2019/5/6.
//  Copyright © 2019 rayor. All rights reserved.
//

import Cocoa
import UserNotifications

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate,UNUserNotificationCenterDelegate {
    /** statu bar */
    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)

    let popover = NSPopover()
    var eventMonitor: EventMonitor?
    
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
     
        self.configureNotification()
        self.configureStatuBar()
        
//        if let mainVC = ViewController.loadViewController("MainViewController") as? ViewController {
//            popover.contentViewController = mainVC
//        }
        
        if let loginVC = LoginController.loadViewController("loginVC") as? LoginController {
            popover.contentViewController = loginVC
        }
        
        eventMonitor = EventMonitor(mask: [.leftMouseDown,.rightMouseDown], handler: { [weak self] (event) in
            if let strongSelf = self, strongSelf.popover.isShown {
                strongSelf.closePopover(sender: event)
            }
        })
        
        // 初次显示出来
        self.showPopover(sender: nil)
    }
    


    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    
    @IBAction func loginAction(_ sender: Any) {
        
        // 弹出的登录页面输入用户名密码
        
        print("__function: \(#function) __line :\(#line)")
        // 调用登录
    }
    
}


/** notification */
extension AppDelegate {
    
    func configureNotification() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert,.badge]) { (granted, error) in
            if let _ = error {
                print("获取授权失败:\(error.debugDescription)")
                return
            }
        }
        center.delegate = self
        
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        let content = response.notification.request.content.subtitle
        print("点击进入m\(content)bug")
        
        self.openAbug(bugId: content)
    }
    
    
    func openAbug(bugId:String) {
        // 进行跳转 bugID
        let url = APIEnumber.main.rawValue + "issues/" + bugId
        //        http://192.168.1.241:30001/issues/6281
        // 使用safair进行打开
        NSWorkspace.shared.open(URL.init(string: url)!)
    }
    
}

/** status Bar */
extension AppDelegate {
    func configureStatuBar() {
        // 配置statusBar
        if let button = statusItem.button {
            button.imagePosition = .imageLeft
            button.image = NSImage.init(named: NSImage.Name("StatusBarButtonImage"))
            button.action = #selector(didClickStatusAction)
        }
        
//        self.constructMenu()
    }
    
    func constructMenu() {
        // 配置子级按钮
        let menu = NSMenu()
        menu.addItem(NSMenuItem.init(title: "主页面", action: #selector(didClickShowMainPage), keyEquivalent: "C"))
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem.init(title: "help", action: #selector(didClickStatusAction), keyEquivalent: "H"))
        self.statusItem.menu = menu
    }
    
    // MARK: 事件
    @objc func didClickStatusAction() {
        self .didClickShowMainPage(nil)
    }
    
    @objc func didClickShowMainPage(_ sender: Any?) {
        if popover.isShown {
            closePopover(sender: sender)
        } else {
            showPopover(sender: sender)
        }
    }
    
    func showPopover(sender:Any?) {
        if let button = statusItem.button {
            popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
            eventMonitor?.start()
        }
    }
    
    
    func closePopover(sender:Any?) {
        popover.performClose(sender)
        eventMonitor?.stop()
    }
    
}
