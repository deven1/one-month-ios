//
//  Video.swift
//  VimeoStaffPicks
//
//  Created by Alfie Hanssen on 5/20/15.
//  Copyright (c) 2015 Alfie Hanssen. All rights reserved.
//

import Foundation
import UIKit
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func >= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l >= r
  default:
    return !(lhs < rhs)
  }
}


class Video {
    
    var name: String? = ""
    var duration: String?
    var imageURLString: String? = ""
    
    init(dictionary: Dictionary<String,AnyObject>) {
        
        self.name = dictionary["name"] as? String
        
        let duration = dictionary["duration"] as? Int ?? 0
        self.duration = self.formattedDuration(duration)
        
        let pictures = dictionary["pictures"] as? Dictionary<String,AnyObject>
        if let constPictures = pictures {
            
            let sizes = constPictures["sizes"] as? Array<Dictionary<String,AnyObject>>
            if let constSizes = sizes {
                
                if constSizes.count > 0 {

                    let screenWidth = UIScreen.main.bounds.size.width * UIScreen.main.scale
                    
                    let viableSizes = constSizes.filter({$0["width"] as? CGFloat >= screenWidth})
                    
                    if viableSizes.count > 0 {
                        
                        let selectedSize = viableSizes[0]
                        
                        self.imageURLString = selectedSize["link"] as? String
                    }
                    else
                    {
                        let selectedSize = constSizes.last
                        
                        self.imageURLString = selectedSize?["link"] as? String
                    }
                }
            }
        }
    }
    
    func formattedDuration(_ duration: Int) -> String
    {
        let minutes = duration / 60
        
        let seconds = duration % 60
        
        let minutesString = minutes < 10 ? "0\(minutes)" : "\(minutes)"
        
        let secondsString = seconds < 10 ? "0\(seconds)" : "\(seconds)"
        
        return minutesString + ":" + secondsString
    }
}
