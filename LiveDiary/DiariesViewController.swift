//
//  DiariesViewController.swift
//  LiveDiary
//
//  Created by Minami Aramaki on 2016/08/14.
//  Copyright © 2016年 Minami Aramaki. All rights reserved.
//

import UIKit

class DiariesViewController: UICollectionViewController {
    private var displayDate : NSDate?
    private var diaries : [DiaryObject] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let store = NSUserDefaults.standardUserDefaults()
        displayDate = store.objectForKey("displayDate") as? NSDate
        //self.collectionView!.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
    }
    
    override func viewWillAppear(animated: Bool) {
        var allDiaries : [DiaryObject] = []
        let store = NSUserDefaults.standardUserDefaults()
        if (store.objectForKey("diaries") != nil){
            let data = store.objectForKey("diaries") as! NSData
            allDiaries = NSKeyedUnarchiver.unarchiveObjectWithData(data) as! [DiaryObject]
        }
        
        diaries = []
        for var diaryObject in allDiaries{
            if diaryObject.date?.compareDate(displayDate!) == .OrderedSame{
                diaries += [diaryObject]
            }
        }
        
        self.collectionView?.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return diaries.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! DiaryCollectionCell
        
        let diaryObject = diaries[indexPath.row]
        cell.label!.text = diaryObject.text
        cell.backgroundColor = CommonOperation().colorForIndex(diaryObject.feeling)
    
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewCon = storyboard.instantiateViewControllerWithIdentifier("edit") as! SpecifyViewController
        viewCon.displayDate = displayDate
        viewCon.index = indexPath.item
        let navCon = UINavigationController(rootViewController: viewCon)
        navCon.modalTransitionStyle = .CoverVertical
        self.presentViewController(navCon, animated: true, completion: nil)
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
    
    }
     */
    
    @IBAction func dismiss(){
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}

class TransitionNavigationController: UINavigationController {
    private var transitioner: Transitioner?
    
    class func instantiate(point: CGPoint) -> TransitionNavigationController {
        let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let viewController = storyboard.instantiateViewControllerWithIdentifier("diaries") as! TransitionNavigationController
        viewController.transitioner = Transitioner(style: .CircularReveal(point), viewController: viewController)
        return viewController
    }
}

class DiaryCollectionCell: UICollectionViewCell {
    @IBOutlet var label : UILabel?
}

class SpecifyViewController: UITableViewController, UITextViewDelegate, FeelingControllerDelegate {
    @IBOutlet var feelLabel : UILabel?
    @IBOutlet var textView : UITextView?
    
    var index : Int = 0
    private var displayDate : NSDate?
    private var diaries : [DiaryObject] = []
    private var feelingIndex : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let store = NSUserDefaults.standardUserDefaults()
        let data = store.objectForKey("diaries") as! NSData
        let allDiaries = NSKeyedUnarchiver.unarchiveObjectWithData(data) as? [DiaryObject]
        
        for var diaryObject in allDiaries!{
            if diaryObject.date?.compareDate(displayDate!) == .OrderedSame{
                diaries += [diaryObject]
            }
        }
        
        let diary = diaries[index]
        feelingIndex = Int(diary.feeling)
        feelingSelected(feelingIndex)
        if (diary.text != nil){
            textView!.text = diary.text
        }
        self.navigationController?.navigationBar.barTintColor = CommonOperation().colorForIndex(Int32(feelingIndex))
    }
    
    override func viewWillAppear(animated: Bool) {
        textView?.becomeFirstResponder();
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.section {
        case 0:
            let viewCon = FeelingViewController()
            viewCon.delegate = self
            self.navigationController?.pushViewController(viewCon, animated: true)
            break
        case 2:
            deleteDiary()
            break
        default: break
        }
        self.tableView.deselectRowAtIndexPath(indexPath, animated: false)
    }
    
    @IBAction func done(){
        let store = NSUserDefaults.standardUserDefaults()
        diaries[index].feeling = Int32(feelingIndex)
        diaries[index].text = textView?.text
        let data = NSKeyedArchiver.archivedDataWithRootObject(diaries)
        store.setObject(data, forKey: "diaries")
        store.synchronize()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func cancel(){
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func feelingSelected(selectedFeeling: Int) {
        feelingIndex = selectedFeeling
        let feeling : String
        switch selectedFeeling {
        case 0:
            feeling = "にこっ"
            break
        case 1:
            feeling = "ぐすん"
            break
        case 2:
            feeling = "まあまあ"
            break
        case 3:
            feeling = "むかっ"
            break
        case 4:
            feeling = "ハートフル"
            break
        default:
            feeling = ""
            break
        }
        feelLabel?.text = feeling
        self.tableView.reloadData()
    }
    
    func deleteDiary(){
        let delAlert = UIAlertController(title: "ほんとうにけしますか？", message: nil, preferredStyle: .ActionSheet)
        let delAction = UIAlertAction(title: "はい", style: .Default, handler: {
            (action: UIAlertAction!) -> Void in
            let delId = self.diaries[self.index].id
            let store = NSUserDefaults.standardUserDefaults()
            let data = store.objectForKey("diaries") as! NSData
            var allDiaries = NSKeyedUnarchiver.unarchiveObjectWithData(data) as? [DiaryObject]
            
            for (var i = 0; i < allDiaries!.count; i += 1){
                let diary = allDiaries![i]
                if diary.id == delId {
                    allDiaries?.removeAtIndex(i)
                    break
                }
            }
            
            let data2 = NSKeyedArchiver.archivedDataWithRootObject(allDiaries!)
            store.setObject(data2, forKey: "diaries")
            store.synchronize()
            self.diaries.removeAtIndex(self.index)
            self.dismissViewControllerAnimated(true, completion: nil)
        })
        let cancelAction = UIAlertAction(title: "いいえ", style: .Cancel, handler: {(action: UIAlertAction!) -> Void in})
        delAlert.addAction(cancelAction)
        delAlert.addAction(delAction)
        presentViewController(delAlert, animated: true, completion: nil)
    }
}

extension NSDate {
    /**
     レシーバと引数の年月日を比較した結果をNSComparisonResultで返します
     - parameter anotherDate:レシーバと比較する日
     - returns: レシーバとanotherDateの年月日を比較した結果
     */
    func compareDate(other: NSDate) -> NSComparisonResult {
        let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)
        
        // 年月日のみ取り出す
        let dateComps: NSDateComponents = calendar!.components(
            [.Year, .Month, .Day,],  // NSCalendarUnit
            fromDate: self
        )
        let otherDateComps: NSDateComponents = calendar!.components(
            [.Year, .Month, .Day,],  // NSCalendarUnit
            fromDate: other
        )
        
        // NSDateに変換
        let date: NSDate = calendar!.dateFromComponents(dateComps)!
        let otherDate: NSDate = calendar!.dateFromComponents(otherDateComps)!
        
        return date.compare(otherDate)
    }
}

