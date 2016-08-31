//
//  DiaryObject.swift
//  LiveDiary
//
//  Created by Minami Aramaki on 2016/08/13.
//  Copyright © 2016年 Minami Aramaki. All rights reserved.
//

import UIKit

class DiaryObject: NSObject {
    var id : Int32
    var feeling : Int32
    var text : String?
    var date : NSDate?
    
    required init(id : Int32, feeling: Int32, text: String?, date: NSDate?){
        self.id = id
        self.feeling = feeling
        self.text = text
        self.date = date
    }
    
    required init(coder decoder: NSCoder){
        self.id = decoder.decodeIntForKey("id")
        self.feeling = decoder.decodeIntForKey("feeling")
        self.text = decoder.decodeObjectForKey("text") as? String
        self.date = decoder.decodeObjectForKey("date") as? NSDate
    }
    
    func encodeWithCoder(coder: NSCoder){
        coder.encodeInt(self.id, forKey: "id")
        coder.encodeInt(self.feeling, forKey: "feeling")
        coder.encodeObject(self.text, forKey: "text")
        coder.encodeObject(self.date, forKey: "date")
    }
    
    convenience override init(){
        self.init(id: 0, feeling: 0, text: "", date: NSDate())
    }
}

class CommonOperation: NSObject {
    func colorForIndex(index: Int32) -> UIColor{
        let bgColor : UIColor
        switch index {
        case 0:
            bgColor = UIColor.orangeColor()
            break
        case 1:
            bgColor = UIColor.cyanColor()
            break
        case 2:
            bgColor = UIColor.greenColor()
            break
        case 3:
            bgColor = UIColor.redColor()
            break
        case 4:
            bgColor = UIColor.magentaColor()
            break
        default:
            bgColor = UIColor.whiteColor()
            break
        }
        return bgColor
    }
}
