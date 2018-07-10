//
//  NavigationViewController.swift
//  FortBuilder
//
//  Created by Samuel Alexander Bretz on 7/10/18.
//  Copyright © 2018 BreMy Software. All rights reserved.
//

import UIKit
import Firebase

class NavigationViewController: UIViewController {

    @IBOutlet weak var LogoutButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func logoutUser(_ sender: UITapGestureRecognizer) {
        try! Auth.auth().signOut()
        performSegue(withIdentifier: "logoutToMenuViewController", sender: self)
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
