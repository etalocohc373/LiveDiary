//
//  PageViewController.swift
//  LiveDiary
//
//  Created by Minami Aramaki on 2016/08/31.
//  Copyright © 2016年 Minami Aramaki. All rights reserved.
//

import UIKit

class PageViewController: UIPageViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setViewControllers([getFirst()], direction: .Forward, animated: true, completion: nil)
        self.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getFirst() -> CalendarViewController {
        return storyboard!.instantiateViewControllerWithIdentifier("calendar") as! CalendarViewController
    }
    
    func getSecond() -> GraphViewController {
        return storyboard!.instantiateViewControllerWithIdentifier("graph") as! GraphViewController
    }

}

extension PageViewController : UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 2
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        if viewController.isKindOfClass(GraphViewController) {
            // 3 -> 2
            return getFirst()
        } else {
            // 1 -> end of the road
            return nil
        }
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        if viewController.isKindOfClass(CalendarViewController) {
            // 1 -> 2
            return getSecond()
        } else {
            // 3 -> end of the road
            return nil
        }
    }
    
}
