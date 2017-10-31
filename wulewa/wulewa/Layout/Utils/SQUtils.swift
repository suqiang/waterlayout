//
//  SQUtils.swift
//  wulewa
//
//  Created by 苏强 on 2017/10/30.
//  Copyright © 2017年 sugercode. All rights reserved.
//

import UIKit

class SQUtils: NSObject {

}

extension UIColor {
    //返回随机颜色
    class var random: UIColor{
        get
        {
            let red = CGFloat(arc4random()%256)/255.0
            let green = CGFloat(arc4random()%256)/255.0
            let blue = CGFloat(arc4random()%256)/255.0
            return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
        }
    }
}

extension Bundle{
    class var namespace: String {
        
        let namespace = Bundle.main.infoDictionary!["CFBundleExecutable"] as? String ?? ""
        
        return namespace
    }
}

extension String{
    var clazz: AnyClass?{
        return NSClassFromString(Bundle.namespace + "." + self)
    }
}


extension String {
    /// 将十六进制颜色转换为UIColor
    func uiColor() -> UIColor {
        // 存储转换后的数值
        var red:UInt32 = 0, green:UInt32 = 0, blue:UInt32 = 0
        
        // 分别转换进行转换
        Scanner(string: self[0..<2]).scanHexInt32(&red)
        
        Scanner(string: self[2..<4]).scanHexInt32(&green)
        
        Scanner(string: self[4..<6]).scanHexInt32(&blue)
        
        return UIColor(red: CGFloat(red)/255.0, green: CGFloat(green)/255.0, blue: CGFloat(blue)/255.0, alpha: 1.0)
    }
    
}

extension UIColor {
    
    /// 用十六进制颜色创建UIColor
    ///
    /// - Parameter hexColor: 十六进制颜色 (0F0F0F)
    convenience init(hexString: String) {
    
        let hex = hexString.replacingOccurrences(of: "#", with: "")
        
        let count = hex.count
        
        // 存储转换后的数值
        var red:UInt32 = 0, green:UInt32 = 0, blue:UInt32 = 0, alpha: UInt32 = 0xff
        
        if count == 8{
            Scanner(string: hexString[count-8..<count-6]).scanHexInt32(&alpha)
        }
        // 分别转换进行转换
        Scanner(string: hexString[count-6..<count-4]).scanHexInt32(&red)
        
        Scanner(string: hexString[count-4..<count-2]).scanHexInt32(&green)
        
        Scanner(string: hexString[count-2..<count]).scanHexInt32(&blue)
        
        self.init(red: CGFloat(red)/255.0, green: CGFloat(green)/255.0, blue: CGFloat(blue)/255.0, alpha: CGFloat(alpha) / 255.0)
    }
}

extension String {
    
    /// String使用下标截取字符串
    /// 例: "示例字符串"[0..<2] 结果是 "示例"
    subscript (r: Range<Int>) -> String {
        get {
            let startIndex = self.index(self.startIndex, offsetBy: r.lowerBound)
            let endIndex = self.index(self.startIndex, offsetBy: r.upperBound)
            
            return String(self[startIndex..<endIndex])
        }
    }
}

extension UIColor {
    class func color(withHex hexInt:Int) -> UIColor{
        var alpha: CGFloat = 1.0
        if hexInt > 0xffffff || (hexInt >= 0x80ffffff && hexInt < 0){
            alpha = 1.0 - CGFloat((hexInt & 0xff000000) >> 24) / 255.0
        }
        let red = CGFloat(hexInt & 0x00ff0000) / 255.0
        let green = CGFloat(hexInt & 0x0000ff00) / 255.0
        let blue = CGFloat(hexInt & 0x000000ff) / 255.0
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
}


