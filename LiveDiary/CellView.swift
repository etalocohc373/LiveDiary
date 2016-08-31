//
//  CellView.swift
//  LiveDiary
//
//  Created by Minami Aramaki on 2016/08/30.
//  Copyright © 2016年 Minami Aramaki. All rights reserved.
//

import JTAppleCalendar

class CellView: JTAppleDayCellView {
    @IBInspectable var todayColor: UIColor! = UIColor(red: 254.0/255.0, green: 73.0/255.0, blue: 64.0/255.0, alpha: 0.3)
    @IBInspectable var normalDayColor: UIColor! = UIColor(white: 0.0, alpha: 0.1)
    @IBOutlet var selectedView: AnimationView!
    @IBOutlet var dayLabel: UILabel!
    @IBOutlet var diaryBadge: UIView!
    
    let textSelectedColor = UIColor.whiteColor()
    let textDeselectedColor = UIColor.blackColor()
    let previousMonthTextColor = UIColor.grayColor()
    lazy var todayDate : String = {
        [weak self] in
        let aString = self!.c.stringFromDate(NSDate())
        return aString
        }()
    lazy var c : NSDateFormatter = {
        let f = NSDateFormatter()
        f.dateFormat = "yyyy-MM-dd"
        
        return f
    }()
    
    func setupCellBeforeDisplay(cellState: CellState, date: NSDate) {
        // Setup Cell text
        dayLabel.text =  cellState.text
        
        // Setup text color
        configureTextColor(cellState)
        
        let store = NSUserDefaults.standardUserDefaults()
        let data = store.objectForKey("diaries") as? NSData
        let diaries = NSKeyedUnarchiver.unarchiveObjectWithData(data!) as! [DiaryObject]
        var diaryCount = 0
        for var diary in diaries {
            if diary.date?.compareDate(date) == .OrderedSame{
                diaryCount += 1
            }
        }
        
        // Setup Cell Background color
        self.backgroundColor = c.stringFromDate(date) == todayDate ? todayColor:normalDayColor
        //self.backgroundColor = diaryCount > 0 ? todayColor:normalDayColor
        self.diaryBadge.layer.cornerRadius =  self.diaryBadge.frame.width  / 2
        self.diaryBadge.hidden = diaryCount > 0 ? false:true
        
        // Setup cell selection status
        //delayRunOnMainThread(0.0) {
            self.configueViewIntoBubbleView(cellState)
        //}
        
        // Configure Visibility
        configureVisibility(cellState)
        
        // With cell states you can literally control every aspect of the calendar view
        // Uncomment this code block to watch "JTAPPLE" spelt on the calendar
        //        let dateSection = c.stringFromDate(cellState.dateSection().dateRange.start)
        //        if dateSection == "2016-01-01" && (cellState.row() == 0 || cellState.column() == 3 || (cellState.row() == 5 && cellState.column() < 4)) {
        //            self.backgroundColor = UIColor.redColor()
        //        } else if dateSection == "2016-02-01" && (cellState.row() == 0 || cellState.column() == 3) {
        //            self.backgroundColor = UIColor.redColor()
        //        } else if dateSection == "2016-03-01" && (cellState.column() == 0 || cellState.column() == 6 || cellState.row() == 2 || cellState.row() == 0) {
        //            self.backgroundColor = UIColor.redColor()
        //        } else if dateSection == "2016-04-01" && (cellState.column() == 0 || (cellState.column() == 6 && cellState.row() < 3) || cellState.row() == 2 || cellState.row() == 0) {
        //            self.backgroundColor = UIColor.redColor()
        //        } else if dateSection == "2016-05-01" && (cellState.column() == 0 || (cellState.column() == 6 && cellState.row() < 3) || cellState.row() == 2 || cellState.row() == 0) {
        //            self.backgroundColor = UIColor.redColor()
        //        } else if dateSection == "2016-06-01" && (cellState.column() == 0 || cellState.row() == 5) {
        //            self.backgroundColor = UIColor.redColor()
        //        }
    }
    
    func configureVisibility(cellState: CellState) {
        if
            cellState.dateBelongsTo == .ThisMonth ||
                cellState.dateBelongsTo == .PreviousMonthWithinBoundary ||
                cellState.dateBelongsTo == .FollowingMonthWithinBoundary {
            self.hidden = false
        } else {
            self.hidden = false
        }
        
    }
    
    func configureTextColor(cellState: CellState) {
        if cellState.isSelected {
            dayLabel.textColor = textSelectedColor
        } else if cellState.dateBelongsTo == .ThisMonth {
            dayLabel.textColor = textDeselectedColor
        } else {
            dayLabel.textColor = previousMonthTextColor
        }
    }
    
    func cellSelectionChanged(cellState: CellState) {
        if cellState.isSelected == true {
            if selectedView.hidden == true {
                configueViewIntoBubbleView(cellState)
                selectedView.animateWithBounceEffect(withCompletionHandler: {
                })
            }
        } else {
            configueViewIntoBubbleView(cellState, animateDeselection: true)
        }
    }
    
    private func configueViewIntoBubbleView(cellState: CellState, animateDeselection: Bool = false) {
        if cellState.isSelected {
            self.selectedView.layer.cornerRadius =  self.selectedView.frame.width  / 2
            self.selectedView.hidden = false
            configureTextColor(cellState)
            
        } else {
            if animateDeselection {
                configureTextColor(cellState)
                if selectedView.hidden == false {
                    selectedView.animateWithFadeEffect(withCompletionHandler: { () -> Void in
                        self.selectedView.hidden = true
                        self.selectedView.alpha = 1
                    })
                }
            } else {
                selectedView.hidden = true
            }
        }
    }
}

class AnimationView: UIView {
    
    func animateWithFlipEffect(withCompletionHandler completionHandler:(()->Void)?) {
        AnimationClass.flipAnimation(self, completion: completionHandler)
    }
    func animateWithBounceEffect(withCompletionHandler completionHandler:(()->Void)?) {
        let viewAnimation = AnimationClass.BounceEffect()
        viewAnimation(self){ _ in
            completionHandler?()
        }
    }
    func animateWithFadeEffect(withCompletionHandler completionHandler:(()->Void)?) {
        let viewAnimation = AnimationClass.FadeOutEffect()
        viewAnimation(self) { _ in
            completionHandler?()
        }
    }
}

extension UIColor {
    convenience init(colorWithHexValue value: Int, alpha:CGFloat = 1.0){
        self.init(
            red: CGFloat((value & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((value & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(value & 0x0000FF) / 255.0,
            alpha: alpha
        )
    }
}
