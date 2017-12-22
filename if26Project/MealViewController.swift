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
    @IBOutlet weak var ingRecette: UILabel!
    
    var database : Connection!
    var recetteNameArr: [String] = []
    var imageArr: [String] = []
    var etapesArr: [String] = []
    var ingArr: [Ingredient] = []
    
    // Table recette
    let recetteTable = Table("recettes")
    let id = Expression<Int>("id")
    let titre = Expression<String>("titre")
    let photo = Expression<String>("photo")
    let etapes = Expression<String>("etapes")
    var recettesSize : Int = 0
    var   arrayRecette:   [Recette]   =   []
    
    //Table link
    let linkTable = Table("linkTable")
    let idRecette = Expression<Int>("idRecette")
    let idIngredient = Expression<Int>("idIng")
    
    //Table ingrédient
    let ingredientTable = Table("ingredientsRecette")
    let idIng = Expression<Int>("id")
    let titreIng = Expression<String>("ingredient")
    
    //Table ingrédientPossede
    let frigoTable = Table("frigo")
    let idfrigo = Expression<Int>("id")
    let ingredientFrigo = Expression<String>("ingredient")
    
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
        var yPos : Int = 330
        if (stringPassed != ""){
        print("ingPassed \(ingPassed)")

        for ing in ingPassed{
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 21))
            label.center = CGPoint(x: 120, y: yPos)
            label.textAlignment = .left
            label.text = "\(ing.descriptorForMeal)"
            yPos = yPos + 20;
            self.view.addSubview(label)
        }
        print("String passed \(stringPassed) ")
        intituleRecette.text = stringPassed
        print("Etapes passed \(etapesPassed) ")
        etapesRecette.text = etapesPassed
        let URLTEST = URL(string: theImagePassed)
        if (theImagePassed != ""){
            URL_IMAGE = URLTEST
            }
            
        }
        else {
            let listIdPossible = getIdRecettePossible()
            let size = UInt32(listIdPossible.count)
            let choix = Int(arc4random_uniform(size))
            print("Nombre de choix : \(choix)")
            let recetteChoisie = listIdPossible[choix]
            print("Recette choisie : \(recetteChoisie)")
            let recetteDuJour = getRecetteById(idR: recetteChoisie)
            print("Recette du jour : \(recetteDuJour.descriptor)")
            intituleRecette.text = recetteDuJour.titre
            etapesRecette.text = recetteDuJour.etapes
            let ingredientRecette = getIngredientByIdRecette(idR: recetteDuJour.id)
            for ing in ingredientRecette {
                let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 21))
                label.center = CGPoint(x: 120, y: yPos)
                label.textAlignment = .left
                label.text = "\(ing.descriptorForMeal)"
                yPos = yPos + 20;
                self.view.addSubview(label)
            }
            /*let URLTEST = URL(string: theImagePassed)
            if (theImagePassed != ""){
                URL_IMAGE = URLTEST
            }*/
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
    
    func getIngredientByIdRecette(idR: Int) -> [Ingredient] {
        var ing : [Ingredient] = []
        do {
            let testTable = linkTable.join(ingredientTable, on: linkTable[idIngredient] == ingredientTable[idIng]).filter(linkTable[idRecette] == idR)
            print("Join sans soucis")
            let testIng = try self.database.prepare(testTable)
            print("prepared sans soucis")
            for tIng in testIng{
                let ingredientR : Ingredient = Ingredient.init(id: tIng[self.idIng], ingredient: tIng[self.titreIng])
                print("ingredientR \(ingredientR.descriptor)")
                ing.append(ingredientR)
            }
            
        }
        catch{
            print(error)
            
        }
        return ing
    }


    func getIdRecettePossible() -> [Int] {
        var idPossible : [Int] = []
        do {
        let allRecette = try self.database.prepare(self.recetteTable)
        let ingredientFrigo = try self.database.prepare(self.frigoTable)
        var idIngredientPossede : [Int] = []
        for frigo in ingredientFrigo {
            idIngredientPossede.append(frigo[self.idfrigo])
        }
        for recette in allRecette{
            let ingredientRecette = getIngredientByIdRecette(idR: recette[self.id])
            var idIngredientR : [Int] = []
            for ingredientR in ingredientRecette{
                idIngredientR.append(ingredientR.id)
            }
            // On test si une liste contient l'autre pour savoir si on a tous les ingredients
            let areAllPresent = Set(idIngredientPossede).isSuperset(of: Set(idIngredientR))
            print("\(idIngredientPossede) contains ? \(idIngredientR)")
            if (areAllPresent == true){
                print("\(recette[self.id]) - \(recette[self.titre]) faisable")
                idPossible.append(recette[self.id])
            }
            }
        }
        catch{
            print(error)
        }
        print("\(idPossible)")
        return idPossible
    }
    
    func getRecetteById(idR: Int) -> Recette{
        
        var recetteNew : Recette = Recette.init(id: 0, titre: "", etapes: "", photo: "")
        let getRecette = recetteTable.where(id == idR)
        do {
            let testR = try self.database.prepare(getRecette)
            print("testR \(testR)")
            for test in testR {
                recetteNew = Recette.init(id: idR, titre: test[self.titre], etapes: test[self.etapes], photo: test[self.photo])
            }
        }
        catch{
            print(error)
            
        }
        print("RecetteNew \(recetteNew)")
        
        return recetteNew
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
