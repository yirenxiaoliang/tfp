//
//  UIView+Extension.swift
//  TeamFaceSwift
//
//  Created by 尹明亮 on 2018/11/19.
//  Copyright © 2018年 尹明亮. All rights reserved.
//

import Foundation
import UIKit

extension UIView{
    
    public var x: CGFloat{
        get{
            return self.frame.origin.x
        }
        set{
            var r = self.frame
            r.origin.x = newValue
            self.frame = r
        }
    }
    
    public var y: CGFloat{
        get{
            return self.frame.origin.y
        }
        set{
            var r = self.frame
            r.origin.y = newValue
            self.frame = r
        }
    }
    
    public var width: CGFloat{
        get{
            return self.frame.size.width
        }
        set{
            var r = self.frame
            r.size.width = newValue
            self.frame = r
        }
    }
    
    public var height: CGFloat{
        get{
            return self.frame.size.height
        }
        set{
            var r = self.frame
            r.size.height = newValue
            self.frame = r
        }
    }
    
    public var centerX: CGFloat{
        get{
            return self.center.x
        }
        set{
            var r = self.center
            r.x = newValue
            self.center = r
        }
    }
    
    public var centerY: CGFloat{
        get{
            return self.center.y
        }
        set{
            var r = self.center
            r.y = newValue
            self.center = r
        }
    }
    
    
    public var size: CGSize{
        get{
            return self.frame.size
        }
        set{
            var r = self.frame
            r.size = newValue
            self.frame = r
        }
    }
    
    public var origin: CGPoint{
        get{
            return self.frame.origin
        }
        set{
            var r = self.frame
            r.origin = newValue
            self.frame = r
        }
    }
    
    public var top: CGFloat{
        get{
            return self.frame.origin.y
        }
        set{
            var r = self.frame
            r.origin.y = newValue
            self.frame = r
        }
    }
    
    public var bottom: CGFloat{
        get{
            return self.frame.origin.y + self.frame.size.height
        }
        set{
            var r = self.frame
            r.origin.y = newValue - self.frame.size.height
            self.frame = r
        }
    }
    
    public var left: CGFloat{
        get{
            return self.frame.origin.x
        }
        set{
            var r = self.frame
            r.origin.x = newValue
            self.frame = r
        }
    }
    
    
    public var right: CGFloat{
        get{
            return self.frame.origin.x + self.frame.size.width
        }
        set{
            var r = self.frame
            r.origin.x = newValue - self.frame.size.width
            self.frame = r
        }
    }
}
