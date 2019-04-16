//
//  ViewController.swift
//  AlarmClock
//
//  Created by Ravi Patel on 4/10/19.
//  Copyright © 2019 iOS_Tutorial. All rights reserved.
//

import UIKit
//import AudioToolbox

class ViewController: UIViewController {

    @IBOutlet weak var info_label: UILabel!
    @IBOutlet weak var alarm_title: UITextField!
    @IBOutlet weak var alarm_time: UIDatePicker!
    

    var repetition_days = [String : Bool]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //dismiss keyboard when tapped away
        let tap = UITapGestureRecognizer(target: self.view, action: Selector("endEditing:"))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
        
        self.info_label.text = self.get_current_time()
        
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (timer) in
            self.info_label.text = self.get_current_time()
            
        })
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("alarm title = ", alarm_title.text ?? "")
        print("alarm time = ", get_alarm_time())
    }
    
    func get_alarm_time() -> String {
        let date = alarm_time.date
        let calendar = alarm_time.calendar
        let hour = calendar?.component(.hour, from: date) ?? 12
        let minute = calendar?.component(.minute, from: date) ?? 0
        
        var current_hour = ""
        
        if hour < 10 {
            current_hour = String("0") + String(hour)
        }
        else if hour > 12 {
            current_hour = String(hour - 12)
        }
        else{
            current_hour = String(hour)
        }
        
        let current_minute = minute < 10 ? String("0") + String(minute) : String(minute)
        
        var alarm_time_chosen = ""
        alarm_time_chosen = String(current_hour) + ":" + String(current_minute)
        
        if hour >= 12 {
            alarm_time_chosen = alarm_time_chosen + " PM"
        }
        else{
            alarm_time_chosen = alarm_time_chosen + " AM"
        }
        return alarm_time_chosen
    }
    
    func get_current_time() -> String {
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
//        let seconds = calendar.component(.second, from: date)
        
        var current_hour = ""
        
        if hour < 10 {
            current_hour = String("0") + String(hour)
        }
        else if hour > 12 {
            current_hour = String(hour - 12)
        }
        else{
            current_hour = String(hour)
        }
        
        let current_minute = minutes < 10 ? String("0") + String(minutes) : String(minutes)
//        let current_seconds = seconds < 10 ? String("0") + String(seconds) : String(seconds)
        
//        let current_time = String(current_hour) + ":" + String(current_minute) + ":" + String(current_seconds)
        
        var current_time = ""
        current_time = String(current_hour) + ":" + String(current_minute)
        
        if hour >= 12 {
            current_time = current_time + " PM"
        }
        else{
            current_time = current_time + " AM"
        }
        
        return current_time
    }
    
    @IBAction func set_alarm_clicked(_ sender: Any) {
        var new_alarm = Alarm()
        new_alarm.title = alarm_title.text ?? "Alarm Title"
        new_alarm.time = get_alarm_time()
        new_alarm.state = true
        new_alarm.date = alarm_time.date
        
        alarm_list.append(new_alarm)
        save_alarm_list()
        
    }
}

