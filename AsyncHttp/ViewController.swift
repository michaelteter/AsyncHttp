//
//  ViewController.swift
//  AsyncHttp
//
//  Created by Michael Teter on 2016-09-08.
//  Copyright © 2016 Michael Teter. All rights reserved.
//

import UIKit
import Foundation

class ViewController: UIViewController {
    @IBOutlet weak var txtUrl:     UITextField!
    @IBOutlet weak var btnGo:      UIButton!
    @IBOutlet weak var lblElapsed: UILabel!
    @IBOutlet weak var lblResult:  UILabel!

    var startTime: Date!

    let defaultSession = URLSession(configuration: URLSessionConfiguration.default)
    var dataTask: URLSessionDataTask?
    
    func markStartTime() { startTime = Date() }
    func elapsedSeconds() -> TimeInterval { return Date().timeIntervalSince(startTime) }
    func updateElapsed() { lblElapsed.text = String(format: "%.2f seconds", elapsedSeconds()) }
    
    @IBAction func btnGoPressed(_ sender: UIButton) {
        if isRequestRunning() {
            cancelRequest()
            lblResult.text = "Request canceled"
        } else {
            setupRequest()
            lblResult.text = "Request sent... waiting for response"
            doRequest()
        }
    }

    func isRequestRunning() -> Bool {
        if let task = dataTask {
            switch task.state {
            case .running:
                print("task is .running")
                return true
            case .completed:
                print("task is .completed")
                return false
            case .canceling:
                print("task is .canceling")
                return false
            case .suspended:
                print("task is .suspended")
                return false
            }
        }
        return false
    }
    
    func cancelRequest() { if dataTask != nil { dataTask?.cancel() } }
    
    func setupRequest() {
        guard txtUrl.text != nil else { return }
        
        cancelRequest()
        
        let url = URL(string: txtUrl.text!)
        
        dataTask = defaultSession.dataTask(with: url!) { data, response, error in
            DispatchQueue.main.async {
                //UIApplication.shared.isNetworkActivityIndicatorVisible = false
                
                guard error == nil else {
                    print(error!.localizedDescription)
                    return
                }
                
                guard let responseData = data else {
                    print("Error: did not receive data")
                    return
                }
                
                do {
                    guard let json = try NSJSONSerialization.JSONObjectWithData(responseData, options: []) as? [String: Any] else {
                        print("Error trying to convert data to json")
                        return
                    }
                    
                    print(json.description)
                    self.lblResult.text = json.description
                }
            }
        }
    }

    func doRequest() {
        if let task = dataTask {
            lblElapsed.text = "... running ..."
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            markStartTime()
            task.resume()
        }

        while isRequestRunning() {
            updateElapsed()
        }
    }
}

