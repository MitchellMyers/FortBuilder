//
//  SaveFortViewController.swift
//  FortBuilder
//
//  Created by Mitchell Myers on 7/11/18.
//  Copyright © 2018 BreMy Software. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import CoreLocation

class SaveFortViewController: UIViewController, UITextFieldDelegate, CLLocationManagerDelegate {
    
    
    @IBOutlet weak var fortNameTextField: UITextField!
    @IBOutlet weak var screenNameTextField: UITextField!
    @IBOutlet weak var privacySegmentControl: UISegmentedControl!
    @IBOutlet weak var saveFortButton: UIButton!
    
    let locationManager = CLLocationManager()
    var currUserLocation = CLLocationCoordinate2D()
    var privacy = "Private"
    var currentFort : Fort?
    var editedByUsername : String?
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        saveFortButton.isEnabled = false
        fortNameTextField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        screenNameTextField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        if editedByUsername != nil && editedByUsername! != (currentFort?.getCreatorUsername())! {
            setUpSegmentConrolForPrevFort()
            fortNameTextField.isEnabled = false
            fortNameTextField.text = (currentFort?.getFortName())!
            privacySegmentControl.isEnabled = false
            self.screenNameTextField.text = editedByUsername!
            saveFortButton.isEnabled = true
        } else {
            self.screenNameTextField.text = (currentFort?.getCreatorUsername())!
        }
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if editedByUsername == nil {
            fortNameTextField.becomeFirstResponder()
        } else {
            setUpSegmentConrolForPrevFort()
            fortNameTextField.text = (currentFort?.getFortName())!
            screenNameTextField.becomeFirstResponder()
        }
        NotificationCenter.default.addObserver(self, selector:#selector(keyboardWillAppear), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
    }
    
    
    private func createNewFortDbInstance(_ creatorEmail: String?) {
        self.ref.child("forts").child(currentFort!.getFortId()!).setValue(["fort_name": self.fortNameTextField.text!, "creator_username": self.screenNameTextField.text!, "creator_email": creatorEmail!, "last_edited_by": "", "location" : "\(currUserLocation.latitude),\(currUserLocation.longitude)", "privacy" : privacy, "blocks": currentFort!.getFortBlockDict()])
    }
    
    private func updateFortDbInstance() {
        self.ref.child("forts/\(currentFort!.getFortId()!)/last_edited_by").setValue(self.screenNameTextField.text!)
        self.ref.child("forts/\(currentFort!.getFortId()!)/blocks").setValue(currentFort!.getFortBlockDict())
        if editedByUsername != nil && editedByUsername! == (currentFort?.getCreatorUsername())! {
            self.ref.child("forts/\(currentFort!.getFortId()!)/fort_name").setValue(self.fortNameTextField.text!)
            self.ref.child("forts/\(currentFort!.getFortId()!)/privacy").setValue(privacy)
        }
    }
    
    @IBAction func saveFort(_ sender: UITapGestureRecognizer) {
        let creatorEmail = Auth.auth().currentUser?.email
        if self.editedByUsername != nil {
            updateFortDbInstance()
        } else {
            createNewFortDbInstance(creatorEmail)
        }
        let alert = UIAlertController(title: "Success", message: "Fort successfully saved!", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default) { (action) -> Void in
            self.performSegue(withIdentifier: "finishedSavingFortSegue", sender: self)
        }
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
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
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        currUserLocation = locValue
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
    }
    
    private func setUpSegmentConrolForPrevFort() {
        let currFortPrivacy = currentFort!.getFortPrivacy()
        switch currFortPrivacy {
            case "Public":
                self.privacySegmentControl.selectedSegmentIndex = 1
                self.privacy = "Public"
            case "Private":
                self.privacySegmentControl.selectedSegmentIndex = 0
                self.privacy = "Private"
            default:
                self.privacySegmentControl.selectedSegmentIndex = 0
                self.privacy = "Private"
        }
    }
    
    
}
