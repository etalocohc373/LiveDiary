//
//  GraphViewController.swift
//  LiveDiary
//
//  Created by Minami Aramaki on 2016/08/31.
//  Copyright © 2016年 Minami Aramaki. All rights reserved.
//

import UIKit
import Graphs

class GraphViewController: UIViewController {
    @IBOutlet var graphView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = "ぐらふ"
        
        let store = NSUserDefaults.standardUserDefaults()
        let data2 = store.objectForKey("diaries") as? NSData
        let diaries = NSKeyedUnarchiver.unarchiveObjectWithData(data2!) as! [DiaryObject]
        var feelingCount = [0, 0, 0, 0, 0]
        for var diary in diaries {
            feelingCount[Int(diary.feeling)] += 1
        }
        
        var data = [
            Data(key: "にこっ", value: Float(feelingCount[0])),
            Data(key: "ぐすん", value: Float(feelingCount[1])),
            Data(key: "まあまあ", value: Float(feelingCount[2])),
            Data(key: "むかっ", value: Float(feelingCount[3])),
            Data(key: "ほのぼの", value: Float(feelingCount[4])),
        ]
        for (var i = data.count - 1; i >= 0; i -= 1){
            let aData = data[i]
            if aData.value <= 0 {
                data.removeAtIndex(i)
            }
        }
        let view = data.pieGraph() { (unit, totalValue) -> String? in
            return unit.key! + "\n" + String(format: "%.0f%%", unit.value / totalValue * 100.0)
            }.view(graphView.frame)
        view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        
        
        graphView.addSubview(view)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func dismiss(){
        self.dismissViewControllerAnimated(true, completion: nil)
    }

}

struct Data<T: Hashable, U: NumericType>: GraphData {
    typealias GraphDataKey = T
    typealias GraphDataValue = U
    
    private let _key: T
    private let _value: U
    
    init(key: T, value: U) {
        self._key = key
        self._value = value
    }
    
    var key: T { get{ return self._key } }
    var value: U { get{ return self._value } }
}
