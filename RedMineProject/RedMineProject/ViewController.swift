//
//  ViewController.swift
//  RedMineProject
//
//  Created by fumi on 2019/5/6.
//  Copyright © 2019 rayor. All rights reserved.
//

import Cocoa
import UserNotifications


class ViewController: NSViewController {

    @IBOutlet weak var tableView: NSTableView!
    var datasource:[BugModel]?
    
    static func MainViewController() -> ViewController {
        let storyboard = NSStoryboard(name: NSStoryboard.Name("Main"), bundle: nil)
        let identifier = NSStoryboard.SceneIdentifier("MainViewController")
        guard let vc = storyboard.instantiateController(withIdentifier: identifier) as? ViewController else {
            fatalError("construct vc faile")
        }
        
        return vc
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LoginManager.preLoginRequest()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        
        BugManager.shared.updateBugModes = { models in
            DispatchQueue.main.async {
                if models.count != (self.datasource?.count ?? 0) , models.count > 0 { // 初次启动给出提示
                    let model = models.first
                    self.showNotification(model: model)
                }
                self.datasource = models
                self.tableView.reloadData()
                if let appdelegate = NSApplication.shared.delegate as? AppDelegate {
                    if let button = appdelegate.statusItem.button {
                        button.title = "\(self.datasource?.count ?? 0)"
                    }
                }
            }
        }
    }
    
    func showNotification(model:BugModel?) {
        guard let model = model else {
            print("false alarm")
            return
        }
        
        let center = UNUserNotificationCenter.current()
        let content = UNMutableNotificationContent()
        content.body = model.bugTitle
        content.subtitle = model.bugId
        let request = UNNotificationRequest.init(identifier: "您有新bug请尽快处理", content: content, trigger: nil)
        center.add(request) { (error) in
//            self.openAbug(model: model)
        }
        
    }
    
    /** 打开一个bug */
    func openAbug(model:BugModel) {
        // 进行跳转
        let url = APIEnumber.main.rawValue + "issues/" + model.bugId
        //        http://192.168.1.241:30001/issues/6281
        // 使用safair进行打开
        NSWorkspace.shared.open(URL.init(string: url)!)
    }
}



extension ViewController: NSTableViewDelegate, NSTableViewDataSource {
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return self.datasource?.count ?? 0
    }
    
    func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
        let model = self.datasource?[row]
        let identifier = tableColumn?.identifier.rawValue ?? "id"
        if identifier == "id" {
            return model?.bugId
        } else if identifier == "desc" {
            return model?.bugTitle
        }
        return nil
    }
    
    func tableView(_ tableView: NSTableView, shouldShowCellExpansionFor tableColumn: NSTableColumn?, row: Int) -> Bool {
        return true
    }
    
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return 15
    }

    func tableView(_ tableView: NSTableView, shouldEdit tableColumn: NSTableColumn?, row: Int) -> Bool {
        return false
    }
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        if tableView.selectedRow < 0 {
            return
        }
        if tableView.selectedRow >= (self.datasource?.count ?? 0) {
            return
        }
        guard let model = self.datasource?[tableView.selectedRow] else {
            return
        }
        print(tableView.selectedRow)
        self.openAbug(model: model)
        
    }
    
    
    func tableView(_ tableView: NSTableView, selectionIndexesForProposedSelection proposedSelectionIndexes: IndexSet) -> IndexSet {
        return proposedSelectionIndexes
    }
}
// 学习参考：http://www.cnblogs.com/v-BigdoG-v/p/7504718.html
