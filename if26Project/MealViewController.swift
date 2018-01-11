//
//  MealViewController.swift
//  if26Project
//
//  Created by if26-grp2 on 18/12/2017.
//  Copyright © 2017 if26-grp2. All rights reserved.
//

import UIKit
import SQLite

class MealViewController: UIViewController{

    @IBOutlet weak var intituleRecette: UILabel!
    @IBOutlet weak var photoRecette: UIImageView!
    @IBOutlet weak var etapesRecette: UILabel!
    
    var database : Connection!
    var recetteNameArr: [String] = []
    var imageArr: [String] = []
    var etapesArr: [String] = []
    var ingArr: [Ingredient] = []
    
    var stringPassed = ""
    var theImagePassed = ""
    var etapesPassed = ""
    var ingPassed : [Ingredient] = []
    var URL_IMAGE = URL(string: "http://img-3.journaldesfemmes.com/rU_bebejJYXENTWkWfEkrgwFcB0=/750x/smart/d6db2baa728b47f8adbf30b99a957dc0/recipe-jdf/10002051.jpg")
    
    
    override func viewDidLoad() {
    
        super.viewDidLoad()
        
        //Connexion base
        do {
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor : nil, create: true)
            let fileUrl = documentDirectory.appendingPathComponent("recette").appendingPathExtension("sqlite3")
            let database = try Connection(fileUrl.path)
            self.database = database
            //instanciationBase()
        }
        catch {
            print(error)
        }
        var yPos : Int = 300
        if (stringPassed != ""){
        print("ingPassed \(ingPassed)")

        var i = 1
        for ing in ingPassed{
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 21))
            label.center = CGPoint(x: 120, y: yPos)
            label.textAlignment = .left
            label.text = "\(i) - \(ing.ingredient)"
            label.font = UIFont(name: label.font.fontName, size: 14)
            self.view.addSubview(label)
            yPos = yPos + 20;
            i = i+1
        }
        print("String passed \(stringPassed) ")
        intituleRecette.text = stringPassed
        print("Etapes passed \(etapesPassed) ")
        etapesRecette.text = etapesPassed
        yPos = yPos + 80
        print("Ypos taille \(yPos)")
        etapesRecette.center = CGPoint(x: 200, y: yPos)
        let URLTEST = URL(string: theImagePassed)
        if (theImagePassed != ""){
            URL_IMAGE = URLTEST
            }   
            
        }
        else {
            let db = sqlClass()
            db.connect()
            let listIdPossible = db.getIdRecettePossible()
            if (listIdPossible.count > 0){
            let size = UInt32(listIdPossible.count)
            let choix = Int(arc4random_uniform(size))
            print("Nombre de choix : \(choix)")
            let recetteChoisie = listIdPossible[choix]
            print("Recette choisie : \(recetteChoisie)")
            let recetteDuJour = db.getRecetteById(idR: recetteChoisie)
            print("Recette du jour : \(recetteDuJour.descriptor)")
            intituleRecette.text = recetteDuJour.titre
            etapesRecette.text = recetteDuJour.etapes
            let ingredientRecette = db.getIngredientByIdRecette(idR: recetteDuJour.id)
            var i = 1
            for ing in ingredientRecette {
                let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 21))
                label.center = CGPoint(x: 120, y: yPos)
                label.textAlignment = .left
                label.text = "\(i) - \(ing.ingredient)"
                label.font = UIFont(name: label.font.fontName, size: 14)
                self.view.addSubview(label)
                yPos = yPos + 20;
                i = i+1
            }
            let URLRANDOM = URL(string: recetteDuJour.photo)
                URL_IMAGE = URLRANDOM
                yPos = yPos + 80
                print("Ypos taille \(yPos)")
                etapesRecette.center = CGPoint(x: 200, y: yPos)
            }
        }
        print("url image : \(URL_IMAGE)")
        let session = URLSession(configuration: .default)
        
        //creating a dataTask

        let getImageFromUrl = session.dataTask(with: URL_IMAGE!) { (data, response, error) in
            //if there is any errorif
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
