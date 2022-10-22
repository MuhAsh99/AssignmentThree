//
//  ViewController.swift
//  AssignmentThree
//
//  Created by Muhammad Ashraf on 10/18/22.
//



import UIKit
import CoreMotion


class ViewController: UIViewController {



    @IBOutlet weak var lbCounter: UILabel!
    
    @IBOutlet weak var activityMode: UILabel!
    
    let activityManager = CMMotionActivityManager()
    let pedoMeter = CMPedometer();
    var currActivity = ""
    
    let customQ = OperationQueue()

    override func viewDidLoad() {
        
        Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(self.updateActivity), userInfo: nil, repeats: true)
        super.viewDidLoad()
        
        if CMMotionActivityManager.isActivityAvailable(){
            self.activityManager.startActivityUpdates(to: customQ)
            { (activity: CMMotionActivity?) -> Void in
//                var test = ""
                
                
                print(activity!.description)
                
//
                if activity!.running {
                    self.currActivity = "Running"

                    }else if activity!.walking{
                        self.currActivity = "Walking"

                    }else if activity!.cycling {
                        self.currActivity = "Cycling"

                
                    }else if activity!.automotive {
                        self.currActivity = "Automotive"

                
                    }else if activity!.stationary {
                        self.currActivity = "Stationary"

                    
                    }else if activity!.unknown {
                        self.currActivity = "Unknown"
                
                }
            }

        }

        if CMPedometer.isPaceAvailable(){
            self.pedoMeter.startUpdates(from: Date()) { (data, error) in
                if error == nil {
                    if let response = data {
                        DispatchQueue.main.async {
                            print("Number Of Steps == \(response.numberOfSteps)")

//                            self.lbCounter.text = "Step Counter : \(response.numberOfSteps)"
                        }
                    }
                }
            }
        }
        
        queryFromYes()
        queryFromTod()
        queryFromPast7()
    }
    
    @objc
    func updateActivity() {
        self.activityMode.text = "Current Activity: \(currActivity)"
    }
    
    // query steps from date
    func queryFromTod(){
        
        let now = Date()
        let cal = Calendar(identifier: .gregorian)
        let endOfYes = cal.startOfDay(for: now)
        
//        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: )!
        
        self.pedoMeter.queryPedometerData(from: endOfYes as Date, to: now as Date){
            (pedData:CMPedometerData?, error: Error?) -> Void in
            let aggregated_string = "Steps: \(pedData!.numberOfSteps) \n Floors: \(pedData!.floorsAscended!.intValue)"
            
            DispatchQueue.main.async {
//                self.lbCounter.text = aggregated_string
            }
        }
        
    }
    
    func queryFromYes(){
        
        let now = Date()
        let cal = Calendar(identifier: .gregorian)
        let endOfYes = cal.startOfDay(for: now)
        let begin = Calendar.current.date(byAdding: .hour, value: -24, to: endOfYes)
        
//        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: )!
        
        self.pedoMeter.queryPedometerData(from: begin! as Date, to: endOfYes as Date){
            (pedData:CMPedometerData?, error: Error?) -> Void in
            let aggregated_string = "Steps: \(pedData!.numberOfSteps) \n Floors: \(pedData!.floorsAscended!.intValue)"
            
            DispatchQueue.main.async {
//                self.lbCounter.text = aggregated_string
            }
        }
        
    }
    
    func queryFromPast7(){
        
        let now = Date()
        let cal = Calendar(identifier: .gregorian)
        let begin = Calendar.current.date(byAdding: .hour, value: -24*7, to: now)
        
//        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: )!
        
        self.pedoMeter.queryPedometerData(from: begin! as Date, to: now as Date){
            (pedData:CMPedometerData?, error: Error?) -> Void in
            let aggregated_string = "Steps: \(pedData!.numberOfSteps) \n Floors: \(pedData!.floorsAscended!.intValue)"
            
            DispatchQueue.main.async {
                self.lbCounter.text = aggregated_string
            }
        }
    
        
    }
    
    
}

