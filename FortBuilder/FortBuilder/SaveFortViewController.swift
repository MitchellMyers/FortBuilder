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
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        saveFortButton.isEnabled = false
        fortNameTextField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        screenNameTextField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        let userID = Auth.auth().currentUser?.uid
        ref.child("users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            let username = value?["username"] as? String ?? ""
            self.screenNameTextField.text = username
        }) { (error) in
            print(error.localizedDescription)
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
        fortNameTextField.becomeFirstResponder()
        NotificationCenter.default.addObserver(self, selector:#selector(keyboardWillAppear), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
    }
    
    
    @IBAction func saveFort(_ sender: UITapGestureRecognizer) {
        let creatorEmail = Auth.auth().currentUser?.email
        self.ref.child("forts").child(UUID().uuidString).setValue(["fort_name": self.fortNameTextField.text!, "creator_username": self.screenNameTextField.text!, "creator_email": creatorEmail!, "location" : "\(currUserLocation.latitude),\(currUserLocation.longitude)", "privacy" : privacy, "blocks": currentFort!.getFortBlockDict()])
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
    
    
}
