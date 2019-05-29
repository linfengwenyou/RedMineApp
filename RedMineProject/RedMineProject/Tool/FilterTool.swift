//
//  FilterTool.swift
//  RedMineProject
//
//  Created by fumi on 2019/5/6.
//  Copyright © 2019 rayor. All rights reserved.
//

import Foundation

// 使用正则表达式进行信息筛选
func authenticityTokey(_ content:String?) -> String {
   
    guard let content = content else {  // 如果没有配置就直接回退处理
        return ""
    }
    
    let pattern = "(?<=csrf-token\" content=\").*(?=\")"
    let regular = try? NSRegularExpression.init(pattern: pattern , options: [])
    
    guard let results = regular?.matches(in: content, options: .init(rawValue: 0), range: NSMakeRange(0, content.count)) else  {
        return ""
    }
    
    var authenKey:String = ""
    for result in results {
        if let range = Range(result.range, in: content) {
            authenKey = "\(content[range])"
            break
        }
    }
    
    return authenKey
}

/** 是否登录成功 */
func isLoginSuccess(_ content:String?) -> Bool {
    guard let content = content else {  // 如果没有配置就直接回退处理
        return false
    }
    
    let pattern = "登录为"
    let regular = try? NSRegularExpression.init(pattern: pattern , options: [])
    
    guard let results = regular?.matches(in: content, options: .init(rawValue: 0), range: NSMakeRange(0, content.count)) else  {
        return false
    }
    return true
}

/** 判断用户登录是否有效 */
func isInValidUserOrPassword(_ content:String?) -> Bool {
    guard let content = content else {  // 如果没有配置就直接回退处理
        return true
    }
    
    let pattern = "无效的用户名或密码"
    let regular = try? NSRegularExpression.init(pattern: pattern , options: [])
    
    guard let results = regular?.matches(in: content, options: .init(rawValue: 0), range: NSMakeRange(0, content.count)) else  {
        return false
    }
    
    return results.count > 0
}


/** 获取bug模型 */
func bugFilterForModelS(_ content:String?) -> [BugModel] {
    var models = [BugModel]()
    
    guard let content = content else {  // 如果没有配置就直接回退处理
        return models
    }
    // 只要bugid和名字
    let statuPattern = "(?<=<td class=\"status\">).*(?=</td>)"
    
    let regularStatus = try? NSRegularExpression.init(pattern: statuPattern, options: [])
    guard let statusResults = regularStatus?.matches(in: content, options: .init(rawValue: 0), range: NSMakeRange(0, content.count)) else {
        return models;
    }
    
    if statusResults.count == 0 {
        return models;
    }
    var status = [String]()
    for result in statusResults {
        if let range = Range(result.range, in: content) {
            let value = "\(content[range])"
            status.append(value)
        }
    }
    
    
    let pattern = "(?<=<td class=\"subject\"><a href=\"/issues/)\\d+.*(?=</a>)"
    let regular = try? NSRegularExpression.init(pattern: pattern , options: [])
    
    guard let results = regular?.matches(in: content, options: .init(rawValue: 0), range: NSMakeRange(0, content.count)) else  {
        return models
    }
    
    if results.count != statusResults.count {
        print("数据解析不匹配，请查看数据验证");
        return models;
    }
    
    for result in results {
        if let range = Range(result.range, in: content) {
            let value = "\(content[range])"
            let bug = bugDetailFilter(value)
            models.append(bug)
        }
    }
    
    var finalModel = [BugModel]()
    for (index, var item) in models.enumerated() {
        item.bugState = status[index]
        finalModel.append(item)
    }
    
    return finalModel
    
}



private func bugDetailFilter(_ content:String) -> BugModel {
    
    // 怎么从正则表达式直接获筛选两组信息

    print("bug信息",content)
    
    let tmpArr = content.components(separatedBy: "\">")
    return BugModel.init(bugId: (tmpArr.first ?? "--"), bugTitle: (tmpArr.last ?? "--"), bugState: "--")
    
}
