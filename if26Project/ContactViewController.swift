//
//  ContactViewController.swift
//  if26Project
//
//  Created by if26-grp2 on 08/01/2018.
//  Copyright © 2018 if26-grp2. All rights reserved.
//

import UIKit

class ContactViewController: UIViewController {



    @IBAction func facebook(_ sender: UIButton) {
    let url = URL(string: "https://www.facebook.com/liam.thiveux")
        UIApplication.shared.open(url!, options: [:])
}
    

    @IBAction func twitter(_ sender: UIButton) {
        let url = URL(string: "https://twitter.com/thiveux")
        UIApplication.shared.open(url!, options: [:])
    }

    @IBAction func insta(_ sender: UIButton) {
    let url = URL(string: "https://www.instagram.com/liam.thiveux/")
        UIApplication.shared.open(url!, options: [:])
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
