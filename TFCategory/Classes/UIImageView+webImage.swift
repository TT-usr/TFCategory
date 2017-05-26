//
//  UIImageView+webImage.swift
//  network
//
//  Created by 姚天成 on 2017/5/24.
//  Copyright © 2017年 姚天成. All rights reserved.
//

// 对 sd 做一层隔离
import SDWebImage

extension UIImageView{
    
    /// 设置网络图片
    ///
    /// - Parameters:
    ///   - urlString: 图片地址
    ///   - placeholderImage: 占位图片
    ///   - isAvatar: 是否为头像(true 默认切圆角 ,白色底,灰色线)
    func tf_sdImage(urlString :String?,placeholderImage:UIImage? ,isAvatar: Bool = false) {
        
        // 多重守护
        guard let urlString = urlString,
            let url = URL(string :urlString) else {

            image = placeholderImage
                
            return
        }
        

        sd_setImage(with: url, placeholderImage: placeholderImage, options: [], progress: nil) { (image, _, _, _) in
            
            if isAvatar {
                self.image = image?.tf_avatarImage(size: self.bounds.size)
            }
            
        }
        
        
    }
    
}
