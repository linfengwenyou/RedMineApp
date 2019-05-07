
//
//  NETManager.swift
//  RedMineProject
//
//  Created by fumi on 2019/5/6.
//  Copyright © 2019 rayor. All rights reserved.
//

import Foundation

class NetManager {
    
    static let shared = NetManager()
    private init() {}
    
    private var _redmine_session:String = ""
    var redmine_session:String {
        set {
            _redmine_session = newValue
        }
        get {
            return _redmine_session
        }
    }
    
    var header:[String:String]? {
        return ["Cookie":self.redmine_session]
    }
    
    // 配置初始化请求信息
    var baseParam:[String:Any]? = {
        return ["token":"123213"] as? [String:Any]
    }()
    
    
    
    func configCookie(_ response:URLResponse?) {
        if let response = response as? HTTPURLResponse {
            if let cookie = response.allHeaderFields["Set-Cookie"] as? String {
                // 保存cookie
                self.redmine_session = cookie
            }
        }
    }
    
    /** 当定义接口不规范时，如POST却要求参数像GET请求拼接上去，用来拼接串 */
    static func urlQueryEncod(param:[String: String]) -> String? {
        var urlComponents = URLComponents()
        var items = [URLQueryItem]()
        for (name, value) in param {
            let queryItem = URLQueryItem.init(name: name, value: value)
            items.append(queryItem)
        }
        urlComponents.queryItems = items
        let result = urlComponents.url?.absoluteString
        return result
    }
}

enum APIEnumber:String {
    case main = "http://192.168.1.241:30001/"
    case login = "http://192.168.1.241:30001/login"
    case myPage = "http://192.168.1.241:30001/my/page"
    case queryAll = ""
}
