//
//  ViewController.swift
//  AssignmentThree
//
//  Created by Muhammad Ashraf on 10/18/22.
//



import UIKit
import CoreMotion

var availableSteps = 0

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UIScrollViewDelegate {

    @IBOutlet weak var weeklySteps: UILabel!
    @IBOutlet weak var yesterdaysSteps: UILabel!
    @IBOutlet weak var todaysSteps: UILabel!
    @IBOutlet weak var activityMode: UILabel!
    @IBOutlet weak var dailyStepGoal: UILabel!
    @IBOutlet weak var weeklyStepGoal: UILabel!
    
    @IBOutlet weak var selector: UIPickerView!
    
    @IBOutlet weak var dailySlider: UISlider!
    @IBOutlet weak var weeklySlider: UISlider!
    @IBOutlet weak var gameNotify: UILabel!
    
    let defaults = UserDefaults.standard
    
    var pickerData = ["Today's Steps", "Activity Mode", "Yesterday's Steps", "Weekly Steps"]
    var currentPick = "Today's Steps"
    
//    let progressView = CircularProgressView(frame:CGRect(x:0, y: 0, width: 100, height: 100), lineWidth: 15, rounded: false)
    
    
    @IBOutlet weak var progressView: CircularProgressView!
    
    let activityManager = CMMotionActivityManager()
    let pedoMeter = CMPedometer();
    var currActivity = ""
    
    
    var todaySteps: Int = 0
    var yesterdaySteps: Int = 0
    var lastWeekSteps: Int = 0
    var dailyGoal: Int = 9999999
    var weeklyGoal: Int = 9999999
    
    let customQ = OperationQueue()

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        self.currentPick = pickerData[row]
        updateBasedOnPick()
    }
    
    func updateBasedOnPick() {
        if (self.currentPick == "Today's Steps") {
            // hide these
            self.activityMode.isHidden = true
            self.yesterdaysSteps.isHidden = true
            self.weeklySteps.isHidden = true
            self.weeklyStepGoal.isHidden = true
            self.weeklySlider.isHidden = true
            
            // unhide these
            self.todaysSteps.isHidden = false
            self.dailyStepGoal.isHidden = false
            self.dailySlider.isHidden = false
            self.progressView.isHidden = false
        }
        else if (self.currentPick == "Activity Mode") {
            // hide these
            self.yesterdaysSteps.isHidden = true
            self.weeklySteps.isHidden = true
            self.weeklyStepGoal.isHidden = true
            self.weeklySlider.isHidden = true
            self.todaysSteps.isHidden = true
            self.dailyStepGoal.isHidden = true
            self.dailySlider.isHidden = true
            self.progressView.isHidden = true
            
            // unhide these
            self.activityMode.isHidden = false
        }
        else if (self.currentPick == "Yesterday's Steps"){
            // hide these
            self.weeklySteps.isHidden = true
            self.weeklyStepGoal.isHidden = true
            self.weeklySlider.isHidden = true
            self.todaysSteps.isHidden = true
            self.dailyStepGoal.isHidden = true
            self.dailySlider.isHidden = true
            self.progressView.isHidden = true
            self.activityMode.isHidden = true
            
            // unhide these
            self.yesterdaysSteps.isHidden = false
        }
        else if (self.currentPick == "Weekly Steps"){
            // hide these
            self.todaysSteps.isHidden = true
            self.dailyStepGoal.isHidden = true
            self.dailySlider.isHidden = true
            self.activityMode.isHidden = true
            self.yesterdaysSteps.isHidden = true
            
            // unhide these
            self.weeklySteps.isHidden = false
            self.weeklyStepGoal.isHidden = false
            self.weeklySlider.isHidden = false
            self.progressView.isHidden = false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateBasedOnPick()
        self.selector.delegate = self
        self.selector.dataSource = self
        setupSliders()
        
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateActivity), userInfo: nil, repeats: true)
        
        
        Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(self.updateLabels), userInfo: nil, repeats: true)
        
        subscribeToActiveMotion()
        queryFromYes()
        queryFromTod()
        queryFromPast7()
        setupProgressBar()
    }
    
    func setupSliders() {
        dailySlider.maximumValue = 10000
        dailySlider.minimumValue = 0
        
        weeklySlider.maximumValue = 100000
        weeklySlider.minimumValue = 0
    }

    func setupProgressBar() {
//        self.progressView = CircularProgressView(frame:CGRect(x:0, y: 0, width: 50, height: 50), lineWidth: 15, rounded: false)
        self.progressView.progressColor = .blue
        self.progressView.trackColor = .lightGray
        self.progressView.frame = CGRect(x:0, y: 100, width: 100, height: 100)
        self.progressView.lineWidth = 10
        self.progressView.rounded = false
        self.progressView.createProgressView()
        self.progressView.center = view.center
        view.addSubview(progressView)
        self.progressView.progress = (Float(self.todaySteps) / Float(self.dailyGoal))
    }
    
    // Function to subscribe to current motion
    func subscribeToActiveMotion() {
        if CMMotionActivityManager.isActivityAvailable(){
            self.activityManager.startActivityUpdates(to: customQ)
            { (activity: CMMotionActivity?) -> Void in
                
                
                print(activity!.description)
                
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
    }
    
    // Function to subscribe to live step counting
//    func subscribeToPedometer() {
//        if CMPedometer.isPaceAvailable(){
//            self.pedoMeter.startUpdates(from: Date()) { (data, error) in
//                if error == nil {
//                    if let response = data {
//                        DispatchQueue.main.async {
//                            print("Number Of Steps == \(response.numberOfSteps)")
//
//                            self.lbCounter.text = "Step Counter : \(response.numberOfSteps)"
//                        }
//                    }
//                }
//            }
//        }
//    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("we are appearing, and loading: ")
        if let oldWeeklyGoal = defaults.string(forKey: "weeklyGoal") {
            self.weeklyGoal = Int(oldWeeklyGoal)!
            self.weeklySlider.value = Float(self.weeklyGoal)
            print(oldWeeklyGoal)
        }
        if let oldDailyGoal = defaults.string(forKey: "dailyGoal") {
            self.dailyGoal = Int(oldDailyGoal)!
            self.dailySlider.value = Float(self.dailyGoal)
            print(oldDailyGoal)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        print("we are disappearing, and storing: ")
        print(String(self.dailyGoal) + " " + String(self.weeklyGoal))
        self.defaults.set(self.dailyGoal, forKey: "dailyGoal")
        self.defaults.set(self.weeklyGoal, forKey: "weeklyGoal")
    }
    
    @objc
    func updateLabels() {
        
        self.weeklyGoal = Int(weeklySlider.value)
        self.dailyGoal = Int(dailySlider.value)
        
        
        self.weeklySteps.text = "Weekly: " + String(self.lastWeekSteps)
        self.yesterdaysSteps.text = "Yesterday: " + String(self.yesterdaySteps)
        self.todaysSteps.text = "Today: " + String(self.todaySteps)
        self.dailyStepGoal.text = "Daily Goal: " + String(self.dailyGoal)
        self.weeklyStepGoal.text = "Weekly Goal: " + String(self.weeklyGoal)
        
        // Update the Graph for the goals
        if (self.currentPick == "Weekly Steps") {
            self.progressView.progress = (Float(self.lastWeekSteps) / Float(self.weeklyGoal))
        }
        else if (self.currentPick == "Today's Steps") {
            self.progressView.progress = (Float(self.todaySteps) / Float(self.dailyGoal))
        }
    }
    
    // Function to update the activity label
    @objc
    func updateActivity() {
        self.activityMode.text = "Current Activity: \(currActivity)"
        if (self.yesterdaySteps >= self.dailyGoal) {
            metStepGoal = true
            self.gameNotify.alpha = 1
            availableSteps = self.yesterdaySteps
        }
        else {
            metStepGoal = false
            self.gameNotify.alpha = 0
        }
    }
    
    // Returns the steps taken today
    func queryFromTod(){
        
        let now = Date()
        let cal = Calendar(identifier: .gregorian)
        let endOfYes = cal.startOfDay(for: now)
        
        self.pedoMeter.queryPedometerData(from: endOfYes as Date, to: now as Date){
            (pedData:CMPedometerData?, error: Error?) -> Void in
            
            DispatchQueue.global().async {
                self.todaySteps = Int(truncating: pedData!.numberOfSteps)
            }
        }
        
    }
    
    // Returns the steps from yesterday, check step goal and setup for game
    func queryFromYes(){
        
        let now = Date()
        let cal = Calendar(identifier: .gregorian)
        let endOfYes = cal.startOfDay(for: now)
        let begin = Calendar.current.date(byAdding: .hour, value: -24, to: endOfYes)
        
        
        self.pedoMeter.queryPedometerData(from: begin! as Date, to: endOfYes as Date){
            (pedData:CMPedometerData?, error: Error?) -> Void in
            
            DispatchQueue.global().async {
                self.yesterdaySteps = Int(truncating: pedData!.numberOfSteps)
                

                
            }
        }
        
    }
    
    // Returns the steps from the last 7 days
    func queryFromPast7(){
        
        let now = Date()
        let begin = Calendar.current.date(byAdding: .hour, value: -24*7, to: now)
        
        self.pedoMeter.queryPedometerData(from: begin! as Date, to: now as Date){
            (pedData:CMPedometerData?, error: Error?) -> Void in
            
            DispatchQueue.global().async {
                self.lastWeekSteps = Int(truncating: pedData!.numberOfSteps)
            }
        }
    
        
    }
    
    
}

