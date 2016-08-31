//
//  WriteViewController.swift
//  LiveDiary
//
//  Created by Minami Aramaki on 2016/08/12.
//  Copyright © 2016年 Minami Aramaki. All rights reserved.
//

import UIKit

class WriteViewController: UITableViewController, UITextViewDelegate, FeelingControllerDelegate {
    @IBOutlet var feelLabel : UILabel?
    @IBOutlet var feelImg : UIImageView?
    @IBOutlet var textView : UITextView?
    private var feelingIndex : Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        feelingSelected(0)
    }
    
    override func viewWillAppear(animated: Bool) {
        textView?.becomeFirstResponder();
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 0 {
            let viewCon = FeelingViewController()
            viewCon.delegate = self
            self.navigationController?.pushViewController(viewCon, animated: true)
        }
        self.tableView.deselectRowAtIndexPath(indexPath, animated: false)
    }
    
    func feelingSelected(selectedFeeling: Int) {
        var imgName = ""
        feelingIndex = selectedFeeling
        let feeling : String
        switch selectedFeeling {
        case 0:
            feeling = "にこっ"
            imgName = "happy"
            break
        case 1:
            feeling = "ぐすん"
            imgName = "sad"
            break
        case 2:
            feeling = "まあまあ"
            imgName = "soso"
            break
        case 3:
            feeling = "むかっ"
            imgName = "angry"
            break
        case 4:
            feeling = "ハートフル"
            imgName = "love"
            break
        default:
            feeling = ""
            imgName = ""
            break
        }
        feelLabel?.text = feeling
        feelImg?.image = UIImage(named: imgName)
        self.tableView.reloadData()
    }
    
    @IBAction func done(){
        let store = NSUserDefaults.standardUserDefaults()
        /*let dateComp = NSDateComponents()
        dateComp.day = 1*/
        let wroteDate = NSDate()//NSCalendar.currentCalendar().dateByAddingComponents(dateComp, toDate: NSDate(), options: NSCalendarOptions())
        
        let maxId = store.integerForKey("maxId") + 1
        let diary = DiaryObject.init(id: Int32(maxId), feeling: Int32(feelingIndex), text: textView!.text, date: wroteDate)
        store.setInteger(maxId, forKey: "maxId")
        let data = NSKeyedArchiver.archivedDataWithRootObject(diary)
        store.setObject(data, forKey: "createdDiary")
        store.synchronize()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func cancel(){
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}

protocol FeelingControllerDelegate : class {
    func feelingSelected(selectedFeeling: Int)
}

class FeelingViewController: UITableViewController {
    weak var delegate: FeelingControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.tableView.registerClass(UITableView.self, forCellReuseIdentifier: "cell")
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.delegate?.feelingSelected(indexPath.row)
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell")
        
        switch indexPath.row {
        case 0:
            cell!.textLabel?.text = "にこっ"
            break
        case 1:
            cell!.textLabel?.text = "ぐすん"
            break
        case 2:
            cell!.textLabel?.text = "まあまあ"
            break
        case 3:
            cell!.textLabel?.text = "むかっ"
            break
        case 4:
            cell!.textLabel?.text = "ハートフル"
            break
        default: break
            
        }
        return cell!
    }
}
