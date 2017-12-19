//
//  MealViewController.swift
//  if26Project
//
//  Created by if26-grp2 on 18/12/2017.
//  Copyright © 2017 if26-grp2. All rights reserved.
//

import UIKit

class MealViewController: UIViewController {

    @IBOutlet weak var intituleRecette: UILabel!
    @IBOutlet weak var photoRecette: UIImageView!
    @IBOutlet weak var etapesRecette: UILabel!
    
    var stringPassed = ""
    var theImagePassed = ""
    let URL_IMAGE = URL(string: "http://img-3.journaldesfemmes.com/rU_bebejJYXENTWkWfEkrgwFcB0=/750x/smart/d6db2baa728b47f8adbf30b99a957dc0/recipe-jdf/10002051.jpg")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("String passed \(stringPassed) ")
        intituleRecette.text = stringPassed
        let URLTEST = URL(string: theImagePassed)
        let session = URLSession(configuration: .default)
        
        //creating a dataTask
        let getImageFromUrl = session.dataTask(with: URL_IMAGE!) { (data, response, error) in
            
            //if there is any error
            if let e = error {
                //displaying the message
                print("Error Occurred: \(e)")
                
            } else {
                //in case of now error, checking wheather the response is nil or not
                if (response as? HTTPURLResponse) != nil {
                    
                    //checking if the response contains an image
                    if let imageData = data {
                        
                        //getting the image
                        let image = UIImage(data: imageData)
                        
                        DispatchQueue.main.async {
                            //displaying the image
                            self.photoRecette.image = image
                        }   
                    } else {
                        print("Image file is currupted")
                    }
                } else {
                    print("No response from server")
                }
            }
        }
        
        //starting the download task
        getImageFromUrl.resume()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
