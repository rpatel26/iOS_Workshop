//
//  AlarmTableViewController.swift
//  AlarmClock
//
//  Created by Ravi Patel on 4/13/19.
//  Copyright © 2019 iOS_Tutorial. All rights reserved.
//

import UIKit
import UserNotifications

struct Alarm: Codable{
    var title = "Alarm Title"
    var time = ""
    var state = false
    var date: Date = Date()
}

var alarm_list = [Alarm]()

func save_alarm_list() {
    // user default to save date in case app terminates...
    UserDefaults.standard.set(try? PropertyListEncoder().encode(alarm_list), forKey: "alarm_list")
    
    // to enable push notification when app isn't running
    for i in alarm_list {
        if i.state == true {
            let content = UNMutableNotificationContent()
            content.title = i.title
            content.body = i.time
            content.sound = UNNotificationSound.default

            var date = DateComponents()
            let calendar = Calendar.current
            date.hour = calendar.component(.hour, from: i.date)
            date.minute = calendar.component(.minute, from: i.date)
            let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: true)

            let requtes = UNNotificationRequest(identifier: i.title, content: content, trigger: trigger)

            UNUserNotificationCenter.current().add(requtes, withCompletionHandler: nil)
        }
        else {
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [i.title])
        }
    }
}

func load_alarm_list() {
    // user default to load date when app terminated...
    if let data = UserDefaults.standard.value(forKey:"alarm_list") as? Data {
        alarm_list = try! PropertyListDecoder().decode(Array<Alarm>.self, from: data)
    }
}

func delete_alarm_list() {
    UserDefaults.standard.removeObject(forKey: "alarm_list")
}

class AlarmTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        delete_alarm_list()
        
        Timer.scheduledTimer(withTimeInterval: 30, repeats: true) { (timer) in
            
            let current_time = self.get_current_time()
            for i in alarm_list {
                if i.state == true {
                    if i.time == current_time {
                        let alert = UIAlertController(title: i.title, message: i.time, preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Exit", style: .cancel, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            }
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        load_alarm_list()
        self.tableView.reloadData()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return alarm_list.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AlarmCell", for: indexPath) as! AlarmCell
        
        let alarm = alarm_list[indexPath.row]
        cell.alarm_title.text = alarm.title
        cell.alarm_time.text = alarm.time
        cell.alarm_switch.setOn(alarm.state, animated: false)
        cell.alarm_switch.tag = indexPath.row
        cell.alarm_switch.addTarget(self, action: #selector(switch_toogled), for: .valueChanged)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("selected row...", indexPath.row)
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            print("Deleted")
            alarm_list.remove(at: indexPath.row)
            self.tableView.beginUpdates()
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            self.tableView.endUpdates()
            save_alarm_list()
        }
    }

    @objc func switch_toogled(sender: UISwitch) {        
        // switch is toogled on
        if sender.isOn {
            alarm_list[sender.tag].state = true
        }
        // switch is toogled off
        else{
            alarm_list[sender.tag].state = false
        }
        
        save_alarm_list()
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

}
