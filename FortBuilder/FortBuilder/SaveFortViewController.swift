//
//  SaveFortViewController.swift
//  FortBuilder
//
//  Created by Mitchell Myers on 7/11/18.
//  Copyright © 2018 BreMy Software. All rights reserved.
//

import Foundation
import UIKit

class SaveFortViewController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var fortNameTextField: UITextField!
    @IBOutlet weak var screenNameTextField: UITextField!
    @IBOutlet weak var privacySegmentControl: UISegmentedControl!
    @IBOutlet weak var saveFortButton: UIButton!
    
    var privacy = "Private"
    var currentFort : Fort?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        saveFortButton.isEnabled = false
        fortNameTextField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        screenNameTextField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fortNameTextField.becomeFirstResponder()
        NotificationCenter.default.addObserver(self, selector:#selector(keyboardWillAppear), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
    }
    
    
    @IBAction func saveFort(_ sender: UITapGestureRecognizer) {
        print(currentFort?.getFortBlocks() ?? "AINT NONE")
    }
    
    @objc func textFieldChanged(_ target:UITextField) {
        let fortName = fortNameTextField.text
        let screenName = screenNameTextField.text
        let formFilled = fortName != nil && screenName != nil && fortName != "" && screenName != ""
        if formFilled {
            saveFortButton.isEnabled = true
        }
    }
    
    @objc func keyboardWillAppear(notification: NSNotification){
        
        let info = notification.userInfo!
        let _: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
    }
    
    
    @IBAction func closeKeyboard(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @IBAction func segmentControlIndexChange(_ sender: Any) {
        switch privacySegmentControl.selectedSegmentIndex
        {
        case 0:
            privacy = "Private"
        case 1:
            privacy = "Public"
        default:
            break
        }
        print(privacy)
    }
    
    
}
