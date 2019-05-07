//
//  LoginManager.swift
//  RedMineProject
//
//  Created by fumi on 2019/5/6.
//  Copyright © 2019 rayor. All rights reserved.
//

import Foundation
import Alamofire
// 登录用户
class LoginManager {
    /** 预登陆，需要获取登录用到的token */
    static func preLoginRequest() {
        
        
        let session = URLSession.shared
        var request = URLRequest.init(url: URL.init(string: APIEnumber.login.rawValue)!)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = NetManager.shared.header
        
        let task = session.dataTask(with: request) { (data, response, error) in
            
            if let _ = error {
                print("获取登录页面失败:\(error.debugDescription)")
                return
            }
            //TODO: 通过String来筛选出token位置信息
            let string = String.init(data: data!, encoding: .utf8)
            // 需要将此key写入参数中使用
            let key = authenticityTokey(string)
            /** 调取登录接口 */
            
            NetManager.shared.configCookie(response)
            self.loginAlamofireRequest(key)
        }
        
        task.resume()
    }
    
    /*
    /** 登录 */
    static func loginRequest(_ authtoken:String) {
        let param = ["utf8":"✓",
                     "authenticity_token":authtoken,
                     "back_url":APIEnumber.main.rawValue,
                     "username":"fumi_liusong",
                     "password":"12345678","login":"登录"]
        
        // 构造网络请求
        let session = URLSession.shared
        let urlString = APIEnumber.login.rawValue
        var request = URLRequest.init(url: URL.init(string: urlString)!)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = NetManager.shared.header
        
        // TODO： 登录配置有问题，使用POST时无法配置信息有误
        //        var paramString = ""
        //        for (key, value) in param {
        //            paramString = paramString + "\(key)=\(value)"
        //            paramString = paramString + "&"
        //        }
        //
        //        request.httpBody = paramString.dropLast().data(using: .utf8)
        
        request.httpBody = NetManager.urlQueryEncod(param: param)?.dropFirst().addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)?.data(using: .utf8)
        
        let task = session.dataTask(with: request) { (data, response, error) in
            
            if let _ = error {
                print("获取登录页面失败")
                return
            }
            
            //TODO: 通过String来筛选出token位置信息
            let string = String.init(data: data!, encoding: .utf8)
            print("__function: \(#function) __line :\(#line)")
            print(string)
            //            // 需要将此key写入参数中使用
            //            let key = authenticityTokey(string)
            //            /** 调取登录接口 */
            //            self.login(key)
            
            
            self.showMain()
            
            //            NetManager.shared.configCookie(response)
            
        }
        
        task.resume()
    }
 */
    
    /** 登录 */
    static func loginAlamofireRequest(_ authtoken:String) {
        let param = ["utf8":"✓",
                     "authenticity_token":authtoken,
                     "back_url":APIEnumber.main.rawValue,
                     "username":"fumi_liusong",
                     "password":"12345678","login":"登录"]
        
        
        
        
        // 会话代理
        let sessionDelegate = SessionManager.default.delegate
        sessionDelegate.taskWillPerformHTTPRedirection = {
            session, task, response, request in
            print("direct Action")
            
            // 配置Cookie 最重要
            NetManager.shared.configCookie(response)
            
            // 调用主页面
            self.requestShowMain()
            return nil
        }
        
        
        // 构造网络请求
        let urlString = APIEnumber.login.rawValue
        
        SessionManager.default.request(URL.init(string: urlString)!, method: .post, parameters: param, headers: NetManager.shared.header).responseData(completionHandler: { (response) in
            // 配置Cookie
            if let _ = response.error {
                print("网络错误")
                return
            }
            // 走重定向，不使用配置了
//            NetManager.shared.configCookie(response.response)
//            self.showMain()
        })
        
    }
    
    /** 主页面 */
    static func requestShowMain() {
        // 判断是否登录成功
        // 构造网络请求
        let session = URLSession.shared
        var request = URLRequest.init(url: URL.init(string: APIEnumber.main.rawValue)!)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = NetManager.shared.header
        
        let task = session.dataTask(with: request) { (data, response, error) in
            
            if let _ = error {
                print("获取主页面失败")
                return
            }
            
            //TODO: 通过String来筛选出token位置信息
            let string = String.init(data: data!, encoding: .utf8)
            NetManager.shared.configCookie(response)
           let isSuccess = isLoginSuccess(string)
            
            // 判断是否登录成功
            if !isSuccess {
                print("登录失败，请查看代码信息")
                return
            }
            
            BugManager.shared.requestShowMyPage()
        }
        
        task.resume()
    }
    
}
