
//
//  BugManager.swift
//  RedMineProject
//
//  Created by fumi on 2019/5/7.
//  Copyright © 2019 rayor. All rights reserved.
//

import Foundation
class BugManager {
    
    static let shared = BugManager()
    private init() {}
    
    var updateBugModes:(([BugModel]) -> Void)?
    
    /** 计时器 */
    var timer:DispatchSourceTimer?
    
    /** 显示我的页面 */
    func requestShowMyPage() {
        
        // 构造网络请求
        let session = URLSession.shared
        var request = URLRequest.init(url: URL.init(string: APIEnumber.myPage.rawValue)!)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = NetManager.shared.header
        
        let task = session.dataTask(with: request) { (data, response, error) in
            
            if let _ = error {
                print("获取主页面失败")
                return
            }
            
            //TODO: 通过String来筛选出token位置信息
            NetManager.shared.configCookie(response)
            let string = String.init(data: data!, encoding: .utf8)
            print("__function: \(#function) __line :\(#line)")
            
            let models = bugFilterForModelS(string)
            
            /** 执行回调 */
            self.updateBugModes?(models)
            
            // 开始计时器
            if self.timer == nil || self.timer!.isCancelled {
                self.startTimer()
            }
            
        }
        
        task.resume()
    }
    
    
    /** 配置计时器 */
    func startTimer() {
        self.timer?.cancel()
        self.timer = nil
        self.timer = DispatchSource.makeTimerSource(flags: .strict, queue: DispatchQueue.global())
        self.timer?.schedule(deadline: DispatchTime.now(), repeating: .seconds(60), leeway: .seconds(5))
        self.timer?.setEventHandler {
            self.requestShowMyPage()
        }
        self.timer?.resume()
    }
    
    
    func stopTimer() {
        self.timer?.cancel()
        self.timer = nil
    }
}
