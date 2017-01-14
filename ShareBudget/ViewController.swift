//
//  ViewController.swift
//  ShareBudget
//
//  Created by Denys Meloshyn on 13.01.17.
//  Copyright © 2017 Denys Meloshyn. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let task = UserAPI.create("1", "2", "ned1988@gmail.com", "1") { (data, response, error) -> (Void) in
            if let data = data as? Data {
                let str = String(data: data, encoding: .utf8)
                print(str)
            }
            
            print(response.debugDescription, error.debugDescription)
        }
        task?.resume()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

