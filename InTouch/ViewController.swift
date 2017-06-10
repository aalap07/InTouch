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
    
    @IBOutlet weak var default1: UIButton! //Sets the default for the first number
    @IBOutlet weak var default2: UIButton! //Sets the default for the second number
    @IBOutlet weak var default3: UIButton! //Sets the default for the third number
    @IBOutlet weak var topLabel: UILabel!
    let defaults = UserDefaults.standard  //Defaults set used for NSCoding
    let toolbar = UIToolbar()

    @IBOutlet weak var clearDefault: UIButton! //Clears the default value of the number
    @IBOutlet weak var saveFirst: UIButton! //Saves the first phone number
    @IBOutlet weak var saveSecond: UIButton!  //Saves the second phone number
    @IBOutlet weak var saveThird: UIButton!  //Saves the third phone number
    var number1: String = "" //Takes the phone number as a string
    var number2: String = "" //Takes the phone number as a string
    var number3: String = "" //Takes the phone number as a string
    var defaultNum: String = "" //Uses one of the phone strings to construct a default string
    

    
    //Text fields for each of the phone numbers
    @IBOutlet weak var firstPhone: UITextField!
    
    @IBOutlet weak var secondPhone: UITextField!
    
    @IBOutlet weak var thirdPhone: UITextField!
    
    
    //Constant variables for later reference in programmatic placement of objects
    let width = Int(UIScreen.main.bounds.width)
    let height = Int(UIScreen.main.bounds.height)
    let center = Int(UIScreen.main.bounds.height/2)
    
    
    //Constant color to be used throughout the app using extension of type UIColor
    static var appColor = UIColor(hexString: "#4F91FF")

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        makeButton(fileName: "Settings.png", frame: CGRect(x: width-53, y: 30, width: 35, height: 35), selector: #selector(self.settingsPressed(_:))) //Constructs the setting button
        
        firstPhone.delegate = self //Sets each of the delegates to self to provide customizability
        secondPhone.delegate = self
        thirdPhone.delegate = self
        
        
        //Adds a done button to the number pad for each UITextField mechanism
        toolbar.sizeToFit()
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(self.doneClicked(_:)))
       
        toolbar.setItems([flexibleSpace, doneButton], animated: false)
        
        
        //Sets up each textfield as having an accessory of name toolbar
        firstPhone.inputAccessoryView = toolbar
        secondPhone.inputAccessoryView = toolbar
        thirdPhone.inputAccessoryView = toolbar
        
        
        //Declares UserDefaults and sets up the keys firstnumber, secondnumber, and thirdnumber to be encoded throughout the app, regardless of screens
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
        
        //Declares the numbertouse key for the app to know which number has been set as default
        if var phone = defaults.string(forKey: "numberToUse"){
            phone = defaultNum
        }

    
    }

 

    
    
    @IBAction func default1Clicked(_ sender: UIButton) {
        
        //Disables the default button and encodes the number to be used as the first number
        default1.isEnabled = false
        default2.isEnabled = true
        default3.isEnabled = true
        number1 = firstPhone.text!
        defaultNum = firstPhone.text!
        
        defaults.setValue(defaultNum, forKey: "numberToUse")
    }
    
    @IBAction func default2Clicked(_ sender: UIButton) {
        //Disables the default button and encodes the number to be used as the second number

        default2.isEnabled = false
        default1.isEnabled = true
        default3.isEnabled = true
        number2 = secondPhone.text!
        defaultNum = secondPhone.text!
        defaults.setValue(defaultNum, forKey: "numberToUse")

    }

    @IBAction func default3Clicked(_ sender: UIButton) {
        //Disables the default button and encodes the number to be used as the third number

        default3.isEnabled = false
        default2.isEnabled = true
        default1.isEnabled = true
        number3 = thirdPhone.text!
        defaultNum = thirdPhone.text!
        defaults.setValue(defaultNum, forKey: "numberToUse")

        
    }

func makeLabel(label: UILabel, text: String, rect: CGRect, font: UIFont) {
    //Simple function that combines all of the necessary elements needed to programmatically add a label to save time and code space
    label.frame = rect
    label.text = text
    label.font = font
    label.textColor = UIColor.black
    label.textAlignment = NSTextAlignment.center
   self.view.addSubview(label)
}

    
func makeButton(fileName: String, frame: CGRect, selector: Selector) {
    //Used to programmatically add a button with an image
    let image = UIImage(named: fileName)?.withRenderingMode(.alwaysTemplate)
    let button = UIButton(type: UIButtonType.custom)
    button.frame = frame
    button.setImage(image, for: .normal)
    button.tintColor = ViewController.appColor
    button.addTarget(self, action: selector, for: .touchUpInside)
    self.view.addSubview(button)
}

func settingsPressed(_ sender: UIButton!) {
    //Function that is called when the settings button has been pressed by the user, using action of touch up inside
 performSegue(withIdentifier: "toSettings", sender: self) //Navigates the user to the settings page using the segue identifier declared in Main.storyboard
    
}
    
    
func messageComposeViewController(_ controller: MFMessageComposeViewController,
                                      didFinishWith result: MessageComposeResult) {
    
        // Check the result or perform other tasks.
        
        // Dismiss the message compose view controller.
        controller.dismiss(animated: true, completion: nil) //If the message is composed and complete, the controller will terminate itself
    }
    func authenticateUser(){ //Function used for Touch ID authentication
        
        let authenticationContext = LAContext() //Sets up new Local Authentication Context
        var error:NSError? //Sets up an error to be displayed if something goes wrong
        
        guard authenticationContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
            //Checks if the device has Touch ID capabilities
            
            showAlertViewIfNoBiometricSensorHasBeenDetected()
            return
            
        }
        
        authenticationContext.evaluatePolicy(
            .deviceOwnerAuthenticationWithBiometrics,
            localizedReason: "Verify your identity.", //Text displayed when asking for user authentication
            reply: { [unowned self] (success, error) -> Void in
                
                if( success ) { //Function called upon successful authentication of the user through Touch ID
                    
                    
                    /* 
                     let alertController = UIAlertController(title: "InTouch", message: "Message sent.", preferredStyle: .alert)
                    let cancelAction = UIAlertAction(title: "OK", style: .default ) { action in  }
                    alertController.addAction(cancelAction)
                    self.present(alertController, animated: true) {}
                    
                     */
                    
                    
                    
                    let composeVC = MFMessageComposeViewController() //Sets up the controller for the message
                    composeVC.messageComposeDelegate = self
                    
                    // Configure the fields of the interface.
                    composeVC.recipients = [self.defaults.string(forKey: "numberToUse")!] //Encodes the recipients in the numbertouse key
                    composeVC.body = self.defaults.string(forKey: "message") //Encodes the message to be used in the message key
                    
                    // Present the view controller
                    self.present(composeVC, animated: true, completion: nil)
 
                    
                }else {
                    
                    if let error = error {
                        //If an error occurs, the system will decide which code to display based on the corresponding reason
                        
                        let message = self.errorMessageForLAErrorCode(error._code)
                        self.showAlertViewAfterEvaluatingPolicyWithMessage(message) //Shows the alert
                        
                    }
                    
                }
                
        })
        
    }
    
    
    @IBAction func clearDefaultPressed(_ sender: UIButton) { //Clears the default number and enables all the buttons
        defaultNum = ""
        default1.isEnabled = true
        default2.isEnabled = true
        default3.isEnabled = true
        
        
    }
    
    func doneClicked(_ sender: UIButton!) { //If the done button is pressed, the keyboard will close
        view.endEditing(true)
    }

   
    @IBAction func testPressed(_ sender: UIButton) { //When the send button is pressed, the system will authenticate the user's identity as a process in sending the text message
        
        authenticateUser()
    
       
    }
    
    
    @IBAction func saveFirstPressed(_ sender: UIButton) { //Saves the first number and encodes the data, while alerting the user that the message has been saved
        let defaults = UserDefaults.standard
        defaults.setValue(firstPhone.text, forKey: "firstNumber")
        let alertController = UIAlertController(title: "Save Number", message: "Your number has been saved.", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "OK", style: .default ) { action in  }
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true) {}
        
    }
    
    
    @IBAction func saveSecondPressed(_ sender: UIButton) {
        //Saves the second number and encodes the data, while alerting the user that the message has been saved
        let defaults = UserDefaults.standard
        defaults.setValue(secondPhone.text, forKey: "secondNumber")
        let alertController = UIAlertController(title: "Save Number", message: "Your number has been saved.", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "OK", style: .default ) { action in print("canceled") }
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true) {}
    }
    
    @IBAction func saveThirdPressed(_ sender: UIButton) {
        //Saves the third number and encodes the data, while alerting the user that the message has been saved
        let defaults = UserDefaults.standard
        defaults.setValue(thirdPhone.text, forKey: "thirdNumber")
        let alertController = UIAlertController(title: "Save Number", message: "Your number has been saved.", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "OK", style: .default ) { action in print("canceled") }
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true) {}
    }
   
    func showAlertViewIfNoBiometricSensorHasBeenDetected(){
        //If the device is not compatible with Touch ID biometrics, the user will be informed with an alert
        showAlertWithTitle("Error", message: "This device does not have a TouchID sensor.")
        
    }
    
    func showAlertViewAfterEvaluatingPolicyWithMessage( _ message:String ){
        //The error message will be shown
        showAlertWithTitle("Error", message: message)
        
    }
    
   
    func showAlertWithTitle( _ title:String, message:String ) {
        //Function that allows alerts to be displayed quickly and easily
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertVC.addAction(okAction)
        
        DispatchQueue.main.async { () -> Void in
            
            self.present(alertVC, animated: true, completion: nil)
            
        }
        
    }
    
      func errorMessageForLAErrorCode( _ errorCode:Int ) -> String{
        
        //Set of possible error codes for the touch id authentication
        
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
    
   

private var __maxLengths = [UITextField: Int]() //extension of type uitextfield that limits the phone number fields to only 10 digits and no more
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


extension UIColor { //Extension of type UIColor that lets the programmer use HTML color codes to allow a broader range of colors 
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
