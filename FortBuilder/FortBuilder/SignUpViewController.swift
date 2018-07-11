//
//  SignUpViewController.swift
//  FortBuilder
//
//  Created by Samuel Alexander Bretz on 7/10/18.
//  Copyright © 2018 BreMy Software. All rights reserved.
//

import UIKit
import Firebase


class SignUpViewController: UIViewController, UITextFieldDelegate {
    
    

    @IBOutlet weak var PasswordTextField: UITextField!
    @IBOutlet weak var EmailTextField: UITextField!
    @IBOutlet weak var UsernameTextField: UITextField!
    @IBOutlet weak var ContinueButton: UIButton!
    
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        ContinueButton.setTitle("Continue",for: .normal)
        setContinueButton(enabled: false)
        ContinueButton.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        
        UsernameTextField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        EmailTextField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        PasswordTextField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)

        ref = Database.database().reference()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setContinueButton(enabled:Bool) {
        if enabled {
            ContinueButton.alpha = 1.0;
            ContinueButton.isEnabled = true;
        } else {
            ContinueButton.alpha = 0.5;
            ContinueButton.isEnabled = false;
        }
    }
    
    @objc func handleSignUp() {
        guard let username = UsernameTextField.text else { return }
        guard let email = EmailTextField.text else { return }
        guard let pass = PasswordTextField.text else { return }
        
        setContinueButton(enabled: false)
        
        Auth.auth().createUser(withEmail: email, password: pass) { user, error in
            if error == nil && user != nil {
                self.ref.child("users").child((user?.user.uid)!).setValue(["username": username, "email": email])
                print("User created!")
                self.performSegue(withIdentifier: "toNavFromSignUp", sender: self)
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UsernameTextField.becomeFirstResponder()
        NotificationCenter.default.addObserver(self, selector:#selector(keyboardWillAppear), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
    }
    
    @objc func keyboardWillAppear(notification: NSNotification){
        
        let info = notification.userInfo!
        let keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        ContinueButton.center = CGPoint(x: view.center.x,
                                        y: view.frame.height - keyboardFrame.height - 16.0 - ContinueButton.frame.height / 2)
    }
    
    @objc func handleDismissButton(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UsernameTextField.resignFirstResponder()
        EmailTextField.resignFirstResponder()
        PasswordTextField.resignFirstResponder()
        
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func textFieldChanged(_ target:UITextField) {
        let username = UsernameTextField.text
        let email = EmailTextField.text
        let password = PasswordTextField.text
        let formFilled = username != nil && username != "" && email != nil && email != "" && password != nil && password != ""
        setContinueButton(enabled: formFilled)
    }
    
    @IBAction func closeKeyboard(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
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
