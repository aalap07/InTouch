//
//  SettingsController.swift
//  InTouch
//
//  Created by Aalap Patel on 5/4/17.
//  Copyright © 2017 Aalap Patel. All rights reserved.
//

import UIKit
import UserNotifications

class SettingsController: UIViewController, UIScrollViewDelegate, UITextViewDelegate {
  
    let width = Int(UIScreen.main.bounds.width)
    let height = Int(UIScreen.main.bounds.height)
    let settingHeight = 49
    let breakHeight = 30
    let defaults = UserDefaults.standard
    let appBlue = UIColor(hexString: "2C6ED9")
    let messageText = UITextView()
    let toolbar = UIToolbar()
    let messageLabel = UILabel()
    let settingsLabel = UILabel()
    
    var scrollView: UIScrollView!
    var containerView = UIView()
    var bottomView = UIView()
    
    var reminderTimeLabel = UIButton()
    var reminderSwitch: UISwitch!
    var timeButton: UIButton!
    var timePickerView = UIView()
    var dateFormatter = DateFormatter()
    var timePicker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Sets up the subviews, header, and background
        self.view.backgroundColor = UIColor.white
        let headerBottomBorder = UIView(frame: CGRect(x: 0.0, y: 63.5, width: Double(width), height: 0.5))
        headerBottomBorder.backgroundColor = UIColor.lightGray
        self.view.addSubview(headerBottomBorder)
        
        scrollView = UIScrollView()
        scrollView.delegate = self
        scrollView.contentSize = CGSize(width: self.width, height: self.height-64-49+1)
        containerView = UIView()
        scrollView.addSubview(containerView)
        self.view.addSubview(scrollView)
        
        reminderTimeLabel = createSetting(yVal: breakHeight + settingHeight, text: "Reminder time")
        reminderTimeLabel.addTarget(self, action: #selector(self.toggleTimePicker(_:)), for: .touchUpInside)
        containerView.addSubview(reminderTimeLabel)
        let dailyReminder = createSetting(yVal: breakHeight, text: "Daily reminder")
        containerView.addSubview(dailyReminder)
        
        bottomView.frame = CGRect(x: 0, y: settingHeight*2 + breakHeight*2, width: self.width, height: 1000)
        containerView.addSubview(bottomView)
       
        bottomView.addSubview(createSetting(yVal: settingHeight, text: "Send feedback or suggestions", selector: #selector(self.sendEmail(_:))))
        bottomView.addSubview(createSetting(yVal: settingHeight*2, text: "Contact the developer", selector: #selector(self.sendEmail(_:))))
        
        
        makeLabel(label: messageLabel, text: "Message", rect: CGRect(x: width/2 - 65, y: 140, width: 130, height: 50 ), font: UIFont(name: "HelveticaNeue-Thin", size: 25)!)
        
        reminderSwitch = UISwitch(frame: CGRect(x: self.width-65, y: (50-31)/2, width: 0, height: 0))
        reminderSwitch.setOn(User.sharedUser.hasReminder, animated: false)
        reminderSwitch.tintColor = UIColor.lightGray
        reminderSwitch.addTarget(self, action: #selector(self.switchToggled(_:)), for: .touchUpInside)
        dailyReminder.addSubview(reminderSwitch)
        
        if !reminderSwitch.isOn {
            self.bottomView.frame.origin.y -= reminderTimeLabel.frame.height
            self.reminderTimeLabel.alpha = 0
        }
        
        makeButton(fileName: "Back", frame: CGRect(x: 25, y: 80, width: 35, height: 35), selector: #selector(self.backPressed(_:)))
        
        
        messageText.frame = CGRect(x: 30, y: 200, width: 250, height: 100)
        messageText.textAlignment = .center
        messageText.layer.borderColor = appBlue.cgColor
        messageText.layer.borderWidth = 1
        messageText.layer.cornerRadius = 20
        messageText.clipsToBounds = true
        messageText.font = UIFont(name: "HelveticaNeue", size: 18)
        messageText.delegate = self

        view.addSubview(messageText)
        
        makeLabel(label: settingsLabel, text: "Settings", rect: CGRect(x: width/2 - 100, y: 70, width: 200, height: 60), font: UIFont(name: "HelveticaNeue-Thin", size: 45)!)
        let defaults = UserDefaults.standard
        if let message = defaults.string(forKey: "message") {
            messageText.text = message
        }
        
        toolbar.sizeToFit()
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(self.doneClicked(_:)))
        
        makeButtonText(title: "Save", font: "HelveticaNeue", fontSize: 20, frame: CGRect(x: 280, y: 225, width: 100, height: 50), selector: #selector(self.saveClicked(_:)))
       
        
        toolbar.setItems([flexibleSpace, doneButton], animated: false)
        messageText.inputAccessoryView = toolbar
        

        timeButton = UIButton(frame: CGRect(x: self.width-100, y: 0, width: 100, height: 50))
        timeButton.setTitleColor(UIColor.gray, for: .normal)
        timeButton.titleLabel?.font = UIFont(name:"HelveticaNeue-Light", size: 20)
        timeButton.addTarget(self, action: #selector(self.toggleTimePicker(_:)), for: .touchUpInside)
        reminderTimeLabel.addSubview(timeButton)
        
        timePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        timePicker.frame.origin.x = (UIScreen.main.bounds.width-timePicker.frame.width)/2
        timePickerView = UIView(frame: CGRect(x: 0, y: settingHeight*2+breakHeight+1, width: 0, height: 0))
        timePickerView.frame.size = CGSize(width: UIScreen.main.bounds.width, height: timePicker.frame.height)
        timePicker.datePickerMode = .time
        timePicker.addTarget(self, action: #selector(self.valueChanged(_:)), for: .valueChanged)
        dateFormatter.dateFormat = "h:mm a"
        
        var components = DateComponents()
        let prevTime = User.sharedUser.reminderTime
        if prevTime == "" {
            timeButton.setTitle("9:00 PM", for: .normal)
            components.hour = 21
            components.minute = 0
        } else {
            timeButton.setTitle(User.sharedUser.reminderTime, for: .normal)
            var i = 2
            if prevTime.characters.count == 7 {
                i = 1
            }
            var hourNum = Int(String(prevTime.characters.prefix(i)))!
            if prevTime.hasSuffix("PM") {
                hourNum += 12
            }
            components.hour = hourNum
            components.minute = Int(String(prevTime.characters.dropFirst(i+1).dropLast(3)))
        }
        
        
        let timePickerDate = Calendar.current.date(from: components)
        timePicker.setDate(timePickerDate!, animated: false)
        
        timePickerView.backgroundColor = UIColor.white
        timePickerView.addSubview(timePicker)
        containerView.addSubview(timePickerView)
        
        timePickerView.isHidden = true
        timePickerView.alpha = 0
  
    }
    
    // Readjusts the UIScrollView
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        scrollView.frame = CGRect(x: 0, y: 300, width: self.width, height: self.height-64-49)
        containerView.frame = CGRect(x: 0, y: 0, width: scrollView.contentSize.width, height: scrollView.contentSize.height)
  
    }
    
    
    // Creates a setting button
    func createSetting(yVal: Int, text: String, selector: Selector? = nil) -> UIButton {
       
        let settingButton = UIButton(frame: CGRect(x: 0, y: yVal, width: self.width, height: 50))
        settingButton.backgroundColor = UIColor.white
        settingButton.contentHorizontalAlignment = .left
        settingButton.setTitle("   " + text, for: .normal)
        settingButton.setTitleColor(UIColor.black, for: .normal)
        settingButton.titleLabel?.font = UIFont(name:"HelveticaNeue-Light", size: 18)
        settingButton.layer.borderWidth = 1
        settingButton.layer.borderColor = UIColor.lightGray.cgColor
        settingButton.addTarget(self, action: #selector(self.touchDown(_:)), for: .touchDown)
        containerView.addSubview(settingButton)
        
        if selector != nil {
            settingButton.addTarget(self, action: selector!, for: .touchUpInside)
            settingButton.addSubview(makeArrow(selector: selector!))
        }
        
        return settingButton
    }
    
    func backPressed(_ sender: UIButton!) {
        
        self.performSegue(withIdentifier: "settingsToHome", sender: self)
   
    }
    
    func makeLabel(label: UILabel, text: String, rect: CGRect, font: UIFont) {
        label.frame = rect
        label.text = text
        label.font = font
        label.textColor = UIColor.black
        label.textAlignment = NSTextAlignment.center
        self.view.addSubview(label)
    }

    
    func doneClicked(_ sender: UIButton!) {
        view.endEditing(true)
    }
    
    func saveClicked(_ sender: UIButton!) {
        defaults.setValue(messageText.text, forKey: "message")
        let alertController = UIAlertController(title: "Save Message", message: "Your message has been saved.", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "OK", style: .default ) { action in  }
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true) {}
    }


    
    // Creates an arrow icon on the far right of a settingButton
    func makeArrow(selector: Selector) -> UIButton {
        let image = UIImage(named: "SlimForward.png")?.withRenderingMode(.alwaysTemplate)
        let button = UIButton(type: UIButtonType.custom)
        button.frame = CGRect(x: self.width-50, y: 15, width: 20, height: 20)
        button.setImage(image, for: .normal)
        button.tintColor = UIColor.lightGray
        button.addTarget(self, action: selector, for: .touchUpInside)
        return button
    }
    
    // Called when the "Daily Reminder" switch is toggled
    func switchToggled(_ sender: UISwitch) {
        var y = 1
        if !reminderSwitch.isOn {
            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
            y = -1
            if !timePickerView.isHidden {
                UIView.animate(withDuration: 0.3, delay: 0, options: [], animations: {
                    self.bottomView.frame.origin.y -= self.timePickerView.frame.height
                    self.scrollView.contentSize.height -= self.timePickerView.frame.height
                    self.timePickerView.alpha = 0 },
                               completion: {
                                (value: Bool) in
                                self.timePickerView.isHidden = true
                })
            }
        } else {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
                if granted {
                    self.setUpNotification()
                } else {
                    
                    
                    let alertController = UIAlertController(title: "Press \"OK\" to turn on notifications for this app", message: "", preferredStyle: .alert)
                    let cancel = UIAlertAction(title: "Cancel", style: .default ) { action in
                        self.reminderSwitch.setOn(false, animated: false)
                        self.switchToggled(self.reminderSwitch)
                    }
                    let okAction = UIAlertAction(title: "OK", style: .default ) { action in
                        UIApplication.shared.open(URL(string: UIApplicationOpenSettingsURLString)!)
                        self.reminderSwitch.setOn(false, animated: false)
                        self.switchToggled(self.reminderSwitch)
                    }
                    alertController.addAction(cancel)
                    alertController.addAction(okAction)
                    
                    
                    self.present(alertController, animated: true) {}
                }
            }
        }
        UIView.animate(withDuration: 0.3) {
            self.bottomView.frame.origin.y += CGFloat(y)*self.reminderTimeLabel.frame.height
            self.reminderTimeLabel.alpha = CGFloat(y)
        }
        User.sharedUser.hasReminder = reminderSwitch.isOn
    }
    
    func makeButton(fileName: String, frame: CGRect, selector: Selector) {
        let image = UIImage(named: fileName)?.withRenderingMode(.alwaysTemplate)
        let button = UIButton(type: UIButtonType.custom)
        button.frame = frame
        button.setImage(image, for: .normal)
        button.tintColor = ViewController.appColor
        button.addTarget(self, action: selector, for: .touchUpInside)
        self.view.addSubview(button)
    }
    
    
    func makeButtonText(title: String, font: String, fontSize: Int, frame: CGRect, selector: Selector) {
        
        let button = UIButton(type: UIButtonType.custom)
        button.frame = frame
        button.titleLabel?.font = UIFont(name: font, size: CGFloat(fontSize))
        button.setTitle(title, for: .normal)
        button.addTarget(self, action: selector, for: .touchUpInside)
        button.setTitleColor(UIColor(hexString: "157EFB"), for: .normal)

        self.view.addSubview(button)
    }

    
   
    // Shows a UIDatePicker when the "Reminder Time" setting is pressed
    func toggleTimePicker(_ sender: UIButton) {
        if timePickerView.isHidden {
            timePickerView.isHidden = false
            UIView.animate(withDuration: 0.3) {
                self.bottomView.frame.origin.y += self.timePickerView.frame.height
                self.scrollView.contentSize.height += self.timePickerView.frame.height
                self.timePickerView.alpha = 1
            }
        } else if self.bottomView.frame.origin.y > CGFloat(settingHeight*2 + breakHeight*2) {
            UIView.animate(withDuration: 0.3, delay: 0, options: [], animations: {
                self.bottomView.frame.origin.y -= self.timePickerView.frame.height
                self.scrollView.contentSize.height -= self.timePickerView.frame.height
                self.timePickerView.alpha = 0 },
                           completion: {
                            (value: Bool) in
                            self.timePickerView.isHidden = true
            })
        }
    }
    
    // Called when the UIDatePicker's time is changed
    func valueChanged(_ sender: UIDatePicker) {
        let dateStr = dateFormatter.string(from: sender.date)
        timeButton.setTitle(dateStr, for: .normal)
        User.sharedUser.reminderTime = dateStr
        setUpNotification()
    }
    
    // Opens an email to the developer
    func sendEmail(_ sender: UIButton) {
        if let emailURL: NSURL = NSURL(string: "mailto:aalappatel07@gmail.com") {
            if UIApplication.shared.canOpenURL(emailURL as URL) {
                UIApplication.shared.open(emailURL as URL)
            }
        }
    }
    
  

    
    // Creates a daily notification for the user based on the UIDatePicker's time
    func setUpNotification() {
        let content = UNMutableNotificationContent()
        content.body = NSString.localizedUserNotificationString(forKey: "Send your message now!", arguments: nil)
        content.sound = UNNotificationSound.default()
        
        let dateInfo = Calendar.current.dateComponents([.hour, .minute], from: timePicker.date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateInfo, repeats: true)
        
        // Create the request object.
        let request = UNNotificationRequest(identifier: "Main", content: content, trigger: trigger)
        
        // Schedule the request.
        let center = UNUserNotificationCenter.current()
        center.add(request) { (error : Error?) in
            if let theError = error {
                print(theError.localizedDescription)
            }
        }
    }
    
    // Turns the background of the button to gray briefly when tapped
    func touchDown(_ sender: UIButton) {
        UIView.animate(withDuration: 0.2, delay: 0, options: [], animations: {
            sender.backgroundColor = UIColor.lightGray },
                       completion: {
                        (value: Bool) in
                        UIView.animate(withDuration: 0.2) {
                            sender.backgroundColor = UIColor.white
                        }
        })
    }
    
}


