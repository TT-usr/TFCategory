//
//  UISwitch+Extensions.swift
//  network
//
//  Created by 姚天成 on 2017/5/25.
//  Copyright © 2017年 姚天成. All rights reserved.
//

import UIKit

#if os(iOS)
    
extension UISwitch {
    
    /// Switch切换
    public func toggle() {
        self.setOn(!self.isOn, animated: true)
    }
}
    
#endif
