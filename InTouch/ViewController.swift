//
//  ViewController.swift
//  InTouch
//
//  Created by Aalap Patel on 5/4/17.
//  Copyright © 2017 Aalap Patel. All rights reserved.
//

import UIKit
import LocalAuthentication
import MessageUI


class ViewController: UIViewController, MFMessageComposeViewControllerDelegate ,UITextFieldDelegate {
    
    @IBOutlet weak var default1: UIButton!
    @IBOutlet weak var default2: UIButton!
    @IBOutlet weak var default3: UIButton!
    @IBOutlet weak var topLabel: UILabel!
    let defaults = UserDefaults.standard
    let toolbar = UIToolbar()

    @IBOutlet weak var clearDefault: UIButton!
    @IBOutlet weak var saveFirst: UIButton!
    @IBOutlet weak var saveSecond: UIButton!
    @IBOutlet weak var saveThird: UIButton!
    var number1: String = ""
    var number2: String = ""
    var number3: String = ""
    var defaultNum: String = ""
    

    @IBOutlet weak var firstPhone: UITextField!
    
    @IBOutlet weak var secondPhone: UITextField!
    
    @IBOutlet weak var thirdPhone: UITextField!
    
    let width = Int(UIScreen.main.bounds.width)
    let height = Int(UIScreen.main.bounds.height)
    let center = Int(UIScreen.main.bounds.height/2)
    
    static var appColor = UIColor(hexString: "#4F91FF")

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        makeButton(fileName: "Settings.png", frame: CGRect(x: width-53, y: 30, width: 35, height: 35), selector: #selector(self.settingsPressed(_:)))
        firstPhone.delegate = self
        secondPhone.delegate = self
        thirdPhone.delegate = self
        
        toolbar.sizeToFit()
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(self.doneClicked(_:)))
       
        toolbar.setItems([flexibleSpace, doneButton], animated: false)
        
        
        firstPhone.inputAccessoryView = toolbar
        secondPhone.inputAccessoryView = toolbar
        thirdPhone.inputAccessoryView = toolbar
        
        let defaults = UserDefaults.standard
        if let firstValue = defaults.string(forKey: "firstNumber") {
            firstPhone.text = firstValue
        }
        if let secondValue = defaults.string(forKey: "secondNumber") {
            secondPhone.text = secondValue
        }
        if let thirdValue = defaults.string(forKey: "thirdNumber") {
            thirdPhone.text = thirdValue
        }
        
        if var phone = defaults.string(forKey: "numberToUse"){
            phone = defaultNum
        }

    
    }

 

    
    
    @IBAction func default1Clicked(_ sender: UIButton) {
        
        default1.isEnabled = false
        default2.isEnabled = true
        default3.isEnabled = true
        number1 = firstPhone.text!
        defaultNum = firstPhone.text!
        
        defaults.setValue(defaultNum, forKey: "numberToUse")
    }
    
    @IBAction func default2Clicked(_ sender: UIButton) {
        default2.isEnabled = false
        default1.isEnabled = true
        default3.isEnabled = true
        number2 = secondPhone.text!
        defaultNum = secondPhone.text!
        defaults.setValue(defaultNum, forKey: "numberToUse")

    }

    @IBAction func default3Clicked(_ sender: UIButton) {
        default3.isEnabled = false
        default2.isEnabled = true
        default1.isEnabled = true
        number3 = thirdPhone.text!
        defaultNum = thirdPhone.text!
        defaults.setValue(defaultNum, forKey: "numberToUse")

        
    }

func makeLabel(label: UILabel, text: String, rect: CGRect, font: UIFont) {
    label.frame = rect
    label.text = text
    label.font = font
    label.textColor = UIColor.black
    label.textAlignment = NSTextAlignment.center
   self.view.addSubview(label)
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

func settingsPressed(_ sender: UIButton!) {
 performSegue(withIdentifier: "toSettings", sender: self)
    
}
    
    
func messageComposeViewController(_ controller: MFMessageComposeViewController,
                                      didFinishWith result: MessageComposeResult) {
        // Check the result or perform other tasks.
        
        // Dismiss the message compose view controller.
        controller.dismiss(animated: true, completion: nil)
    
    }
    func authenticateUser(){
        
        let authenticationContext = LAContext()
        var error:NSError?
        
        guard authenticationContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
            
            showAlertViewIfNoBiometricSensorHasBeenDetected()
            return
            
        }
        
        authenticationContext.evaluatePolicy(
            .deviceOwnerAuthenticationWithBiometrics,
            localizedReason: "Verify your identity.",
            reply: { [unowned self] (success, error) -> Void in
                
                if( success ) {
                    /* 
                     let alertController = UIAlertController(title: "InTouch", message: "Message sent.", preferredStyle: .alert)
                    let cancelAction = UIAlertAction(title: "OK", style: .default ) { action in  }
                    alertController.addAction(cancelAction)
                    self.present(alertController, animated: true) {}
                    
                     */
                    
                    
                    
                    let composeVC = MFMessageComposeViewController()
                    composeVC.messageComposeDelegate = self
                    
                    // Configure the fields of the interface.
                    composeVC.recipients = [self.defaults.string(forKey: "numberToUse")!]
                    composeVC.body = self.defaults.string(forKey: "message")
                    
                    // Present the view controller modally.
                    self.present(composeVC, animated: true, completion: nil)
 
                    
                }else {
                    
                    if let error = error {
                        
                        let message = self.errorMessageForLAErrorCode(error._code)
                        self.showAlertViewAfterEvaluatingPolicyWithMessage(message)
                        
                    }
                    
                }
                
        })
        
    }
    
    
    @IBAction func clearDefaultPressed(_ sender: UIButton) {
        defaultNum = ""
        default1.isEnabled = true
        default2.isEnabled = true
        default3.isEnabled = true
        
        
    }
    
    func doneClicked(_ sender: UIButton!) {
        view.endEditing(true)
    }

   
    @IBAction func testPressed(_ sender: UIButton) {
        
        authenticateUser()
    
       
    }
    
    
    @IBAction func saveFirstPressed(_ sender: UIButton) {
        let defaults = UserDefaults.standard
        defaults.setValue(firstPhone.text, forKey: "firstNumber")
        let alertController = UIAlertController(title: "Save Number", message: "Your number has been saved.", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "OK", style: .default ) { action in  }
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true) {}
        
    }
    
    
    @IBAction func saveSecondPressed(_ sender: UIButton) {
        let defaults = UserDefaults.standard
        defaults.setValue(secondPhone.text, forKey: "secondNumber")
        let alertController = UIAlertController(title: "Save Number", message: "Your number has been saved.", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "OK", style: .default ) { action in print("canceled") }
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true) {}
    }
    
    @IBAction func saveThirdPressed(_ sender: UIButton) {
        let defaults = UserDefaults.standard
        defaults.setValue(thirdPhone.text, forKey: "thirdNumber")
        let alertController = UIAlertController(title: "Save Number", message: "Your number has been saved.", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "OK", style: .default ) { action in print("canceled") }
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true) {}
    }
   
    func showAlertViewIfNoBiometricSensorHasBeenDetected(){
        
        showAlertWithTitle("Error", message: "This device does not have a TouchID sensor.")
        
    }
    
    func showAlertViewAfterEvaluatingPolicyWithMessage( _ message:String ){
        
        showAlertWithTitle("Error", message: message)
        
    }
    
   
    func showAlertWithTitle( _ title:String, message:String ) {
        
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertVC.addAction(okAction)
        
        DispatchQueue.main.async { () -> Void in
            
            self.present(alertVC, animated: true, completion: nil)
            
        }
        
    }
    
      func errorMessageForLAErrorCode( _ errorCode:Int ) -> String{
        
        var message = ""
        
        switch errorCode {
            
        case LAError.Code.appCancel.rawValue:
            message = "Authentication was cancelled by application"
            
        case LAError.Code.authenticationFailed.rawValue:
            message = "The user failed to provide valid credentials"
            
        case LAError.Code.invalidContext.rawValue:
            message = "The context is invalid"
            
        case LAError.Code.passcodeNotSet.rawValue:
            message = "Passcode is not set on the device"
            
        case LAError.Code.systemCancel.rawValue:
            message = "Authentication was cancelled by the system"
            
        case LAError.Code.touchIDLockout.rawValue:
            message = "Too many failed attempts."
            
        case LAError.Code.touchIDNotAvailable.rawValue:
            message = "Touch ID is not available on the device"
            
        case LAError.Code.userCancel.rawValue:
            message = "User cancelled authentication."
            
        case LAError.Code.userFallback.rawValue:
            message = "The user chose to use the fallback"
            
        default:
            message = "Did not find error code on LAError object"
            
        }
        
        return message
        
    }

    }
    
   

private var __maxLengths = [UITextField: Int]()
extension UITextField {
    @IBInspectable var maxLength: Int {
        get {
            guard let l = __maxLengths[self] else {
                return 150
            }
            return l
        }
        set {
            __maxLengths[self] = newValue
            addTarget(self, action: #selector(fix), for: .editingChanged)
        }
    }
    func fix(textField: UITextField) {
        let t = textField.text
        textField.text = t?.safelyLimitedTo(length: maxLength)
    }
}

extension String
{
    func safelyLimitedTo(length n: Int)->String {
        let c = self.characters
        if (c.count <= n) { return self }
        return String( Array(c).prefix(upTo: n) )
    }
}


extension UIColor {
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt32()
        Scanner(string: hex).scanHexInt32(&int)
        let a, r, g, b: UInt32
        switch hex.characters.count {
        case 3: (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default: (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}
