//
//  InfoController.swift
//  InTouch
//
//  Created by Aalap Patel on 6/13/17.
//  Copyright © 2017 Aalap Patel. All rights reserved.
//

import UIKit

class InfoController: UIViewController{
    
    let width = Int(UIScreen.main.bounds.width)
    let height = Int(UIScreen.main.bounds.height)
    
    
    let settingHeight = 350

    override func viewDidLoad() {
        view.addSubview(createSetting(yVal: settingHeight, text: "Send feedback or suggestions", selector: #selector(self.sendEmail(_:))))
        view.addSubview(createSetting(yVal: 400, text: "Contact the developer", selector: #selector(self.sendEmail(_:))))
        super.viewDidLoad()
    }
    
    
    
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
        view.addSubview(settingButton)
        
        if selector != nil {
            settingButton.addTarget(self, action: selector!, for: .touchUpInside)
            settingButton.addSubview(makeArrow(selector: selector!))
        }
        
        return settingButton
    }

    func sendEmail(_ sender: UIButton) {
        if let emailURL: NSURL = NSURL(string: "mailto:aalappatel07@gmail.com") {
            if UIApplication.shared.canOpenURL(emailURL as URL) {
                UIApplication.shared.open(emailURL as URL)
            }
        }
    }
    func makeArrow(selector: Selector) -> UIButton {
        let image = UIImage(named: "SlimForward.png")?.withRenderingMode(.alwaysTemplate)
        let button = UIButton(type: UIButtonType.custom)
        button.frame = CGRect(x: self.width-50, y: 15, width: 20, height: 20)
        button.setImage(image, for: .normal)
        button.tintColor = UIColor.lightGray
        button.addTarget(self, action: selector, for: .touchUpInside)
        return button
    }

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
