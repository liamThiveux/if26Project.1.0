//
//  DetailTestViewController.swift
//  if26Project
//
//  Created by if26-grp2 on 18/12/2017.
//  Copyright © 2017 if26-grp2. All rights reserved.
//

import UIKit

class DetailTestViewController: UIViewController {

    @IBOutlet weak var detailRecette: UILabel!
    var stringPassed = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
            detailRecette.text = stringPassed
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
