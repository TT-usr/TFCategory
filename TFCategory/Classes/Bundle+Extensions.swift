//
//  Bundle+Extensions.swift
//  network
//
//  Created by 姚天成 on 2017/5/25.
//  Copyright © 2017年 姚天成. All rights reserved.
//

import Foundation

extension Bundle{
    
    /// 获取项目的命名空间
    func nameSpace() -> String {
        return Bundle.main.infoDictionary!["CFBundleName"] as? String ?? ""
    }
    
    /// 获取项目的命名空间(计算型属性)
    var namespace : String {
        return Bundle.main.infoDictionary!["CFBundleName"] as? String ?? ""
    }
    
    /// EZSE: load xib
    //  Usage: Set some UIView subclass as xib's owner class
    //  Bundle.loadNib("ViewXibName", owner: self) //some UIView subclass
    //  self.addSubview(self.contentView)
    public class func loadNib(_ name: String, owner: AnyObject!) {
        _ = Bundle.main.loadNibNamed(name, owner: owner, options: nil)?[0]
    }
    
    /// EZSE: load xib
    /// Usage: let view: ViewXibName = Bundle.loadNib("ViewXibName")
    public class func loadNib<T>(_ name: String) -> T? {
        return Bundle.main.loadNibNamed(name, owner: nil, options: nil)?[0] as? T
    }
}
