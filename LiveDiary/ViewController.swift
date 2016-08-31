//
//  ViewController.swift
//  LiveDiary
//
//  Created by Minami Aramaki on 2016/08/12.
//  Copyright © 2016年 Minami Aramaki. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var charaImg : UIImageView!
    @IBOutlet var trashcan : UIImageView!
    
    private let SCREEN_WIDTH = UIScreen.mainScreen().bounds.size.width
    private let SCREEN_HEIGHT = UIScreen.mainScreen().bounds.size.height
    private let foodImg = UIImageView.init(image: UIImage.init(named: "macaron.png"))
    private var blinkIndex = 0
    private var charaTouched = false
    private var touchUp = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        charaImg.contentMode = .ScaleAspectFit
        charaImg.tag = 2
        trashcan.contentMode = .ScaleAspectFit
        foodImg.tag = 1
        foodImg.userInteractionEnabled = true
        foodImg.frame = CGRect.init(x: SCREEN_WIDTH / 2 - 50, y: 500, width: 100, height: 100)
        foodImg.hidden = true
        self.view.addSubview(foodImg)
        
        NSTimer.scheduledTimerWithTimeInterval(0.2, target: self, selector: #selector(ViewController.blinkChara), userInfo: nil, repeats: true)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        let store = NSUserDefaults.standardUserDefaults()
        let data = store.objectForKey("createdDiary") as? NSData
        if (data != nil){
            trashcan.hidden = false
            foodImg.hidden = false
            let diary = NSKeyedUnarchiver.unarchiveObjectWithData(data!) as! DiaryObject
            var diaries : [DiaryObject] = []
            let arrData = store.objectForKey("diaries") as? NSData
            if (arrData != nil){
                diaries = NSKeyedUnarchiver.unarchiveObjectWithData(arrData!) as! [DiaryObject]
            }
            diaries += [diary]
            let saveData = NSKeyedArchiver.archivedDataWithRootObject(diaries)
            store.setObject(saveData, forKey: "diaries")
            store.removeObjectForKey("createdDiary")
            store.synchronize()
            
            UIApplication.sharedApplication().cancelAllLocalNotifications();
            let notification = UILocalNotification()
            notification.fireDate = NSDate(timeIntervalSinceNow: 60 * 60 * 24 * 3);//５秒後
            notification.timeZone = NSTimeZone.defaultTimeZone()
            notification.alertBody = "おなかすいたな〜"
            notification.alertAction = "OK"
            notification.soundName = UILocalNotificationDefaultSoundName
            UIApplication.sharedApplication().scheduleLocalNotification(notification);
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func presentDiaryController() {
        let store = NSUserDefaults.standardUserDefaults()
        store.setObject(NSDate(), forKey: "displayDate")
        store.synchronize()
        
        let viewCon = TransitionNavigationController.instantiate(charaImg.center)
        self.presentViewController(viewCon, animated: true, completion: nil)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first
        if touch?.view!.tag == 2{
            //animateChara(true)
            charaTouched = true
            touchUp = true
            charaImg.image = UIImage(named: "stroke3.png")
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first
        if touch!.view!.tag == 1{
            foodImg.center = (touch?.locationInView(self.view))!
            charaImg.image = UIImage(named: "eat.png")
        }
        if touch!.view!.tag == 2{
            charaTouched = true
            touchUp = false
            charaImg.image = UIImage(named: "stroke3.png")
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first
        if touch!.view!.tag == 1 && distanceBetweenPoints(charaImg.center, point2: (touch?.locationInView(self.view))!) < 70{
            foodImg.hidden = true
            trashcan.hidden = true
            charaImg.image = UIImage(named: "stroke.png")
            
            
        }
        if touch!.view!.tag == 1 && distanceBetweenPoints(trashcan.center, point2: (touch?.locationInView(self.view))!) < 25{
            foodImg.hidden = true
            trashcan.hidden = true
            charaImg.image = UIImage(named: "normal.png")
            
            let store = NSUserDefaults.standardUserDefaults()
            let data = store.objectForKey("diaries") as? NSData
            var diaries = NSKeyedUnarchiver.unarchiveObjectWithData(data!) as? [DiaryObject]
            diaries?.removeLast()
            let data2 = NSKeyedArchiver.archivedDataWithRootObject(diaries!)
            store.setObject(data2, forKey: "diaries")
            store.synchronize()
        }
        if touch?.view!.tag == 2{
            animateChara(false)
            charaImg.stopAnimating()
            charaImg.image = UIImage(named: "normal.png")
            charaTouched = false
            
            if touchUp {
                presentDiaryController()
                touchUp = false
            }
        }
    }
    
    func blinkChara(){
        if !charaTouched{
            blinkIndex += 1
            if blinkIndex >= 15 {
                blinkIndex = 0
                charaImg.image = UIImage(named: "blink.png")
            }else{
                charaImg.image = UIImage(named: "normal.png")
            }
        }
    }
    
    func animateChara(shrink: Bool){
        let animeArr : [UIImage]
        if (shrink){
            animeArr = [UIImage(named: "stroke.png")!, UIImage(named: "stroke2.png")!, UIImage(named: "stroke3.png")!]
        }else{
            animeArr = [UIImage(named: "stroke3.png")!, UIImage(named: "stroke2.png")!, UIImage(named: "stroke.png")!/*, UIImage(named: "normal.png")!*/]
        }
        charaImg.animationImages = animeArr
        charaImg.animationDuration = 0.2
        
        charaImg.startAnimating()
    }
    
    func distanceBetweenPoints(point1: CGPoint, point2: CGPoint) -> Float {
        let powX = powf(Float(point1.x - point2.x), 2.0)
        let powY = powf(Float(point1.y - point2.y), 2.0)
        let dist = powf(powX + powY, 0.5)
        
        return dist
    }
}

