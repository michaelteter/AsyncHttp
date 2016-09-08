//
//  ViewController.swift
//  AsyncHttp
//
//  Created by Michael Teter on 2016-09-08.
//  Copyright © 2016 Michael Teter. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var txtUrl:     UITextField!
    @IBOutlet weak var btnGo:      UIButton!
    @IBOutlet weak var lblElapsed: UILabel!
    @IBOutlet weak var lblResult:  UILabel!

    var waiting = false
    var startTime: Date!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    func startClock() {
        startTime = Date()
    }
    
    func elapsedSeconds() -> TimeInterval {
        return Date().timeIntervalSince(startTime)
    }
    
    @IBAction func btnGoPressed(_ sender: UIButton) {
        if waiting {
            // cancel request
            lblResult.text = "Request canceled"
            lblElapsed.text = String(format: "%.2f seconds", elapsedSeconds())
            waiting = false
        } else {
            lblResult.text = "Request sent... waiting for response"
            waiting = true
            startClock()
        }
    }

    func doRequest() {
        if let url = URL(string: txtUrl.text!), txtUrl.text != nil {
            let req = NSMutableURLRequest(url: url)
            var session = URLSession.shared
            req.httpMethod = "GET"

//            req.httpBody = try? JSONSerialization.data(withJSONObject: <#T##Any#>, options: <#T##JSONSerialization.WritingOptions#>)
//            req.HTTPBody = try? NSJSONSerialization.dataWithJSONObject(params, options: [])
            
            req.addValue("application/json", forHTTPHeaderField: "Content-Type")
            req.addValue("application/json", forHTTPHeaderField: "Accept")
            
            var task = session.dataTask(with: url, completionHandler: <#T##(Data?, URLResponse?, Error?) -> Void#>)
            var task = session.dataTaskWithRequest(req, completionHandler: {data, response, error -> Void in
                print("Response: \(response)")})
            
            task.resume()
            
    }
}

