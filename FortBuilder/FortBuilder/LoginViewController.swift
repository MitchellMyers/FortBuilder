//
//  LoginViewController.swift
//  FortBuilder
//
//  Created by Samuel Alexander Bretz on 7/10/18.
//  Copyright © 2018 BreMy Software. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var EmailTextField: UITextField!
    @IBOutlet weak var ContinueButton: UIButton!
    @IBOutlet weak var PasswordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setContinueButton(enabled: false)
        ContinueButton.addTarget(self, action: #selector(handleSignIn), for: .touchUpInside)
        EmailTextField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        PasswordTextField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        EmailTextField.becomeFirstResponder()
        NotificationCenter.default.addObserver(self, selector:#selector(keyboardWillAppear), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
    }
    
    @objc func handleSignIn() {
        guard let email = EmailTextField.text else { return }
        guard let pass = PasswordTextField.text else { return }
        
        setContinueButton(enabled: false)
        Auth.auth().signIn(withEmail: email, password: pass) { user, error in
            if error == nil && user != nil {
                print("User logged in!")
                self.performSegue(withIdentifier: "toNavFromLogin", sender: self)
            } else {
                print("Error: \(error!.localizedDescription)")
                //Tells the user that there is an error and then gets firebase to tell them the error
                let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    @objc func keyboardWillAppear(notification: NSNotification){
        
        let info = notification.userInfo!
        let _: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
    }
    
    @objc func textFieldChanged(_ target:UITextField) {
        let email = EmailTextField.text
        let password = PasswordTextField.text
        let formFilled = email != nil && email != "" && password != nil && password != ""
        setContinueButton(enabled: formFilled)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setContinueButton(enabled: Bool) {
        if enabled {
            ContinueButton.alpha = 1.0;
            ContinueButton.isEnabled = true;
        } else {
            ContinueButton.alpha = 0.5;
            ContinueButton.isEnabled = false;
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
