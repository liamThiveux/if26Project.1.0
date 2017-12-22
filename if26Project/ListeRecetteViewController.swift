//
//  ListeRecetteViewController.swift
//  if26Project
//
//  Created by if26-grp2 on 29/11/2017.
//  Copyright © 2017 if26-grp2. All rights reserved.
//

import UIKit
import SQLite

class ListeRecetteViewController: UITableViewController {

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
    
    let identifiantRecetteCellule = "celulleRecette"

    let URL_IMAGE = URL(string: "http://img-3.journaldesfemmes.com/rU_bebejJYXENTWkWfEkrgwFcB0=/750x/smart/d6db2baa728b47f8adbf30b99a957dc0/recipe-jdf/10002051.jpg")

    override func viewDidLoad() {
        super.viewDidLoad()
        imageArr = ["http://img-3.journaldesfemmes.com/rU_bebejJYXENTWkWfEkrgwFcB0=/750x/smart/d6db2baa728b47f8adbf30b99a957dc0/recipe-jdf/10002051.jpg","http://static.cuisineaz.com/610x610/i1494-curry-de-poulet-a-la-noix-de-coco.jpg"]
        do {
        let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor : nil, create: true)
        let fileUrl = documentDirectory.appendingPathComponent("recette").appendingPathExtension("sqlite3")
        let database = try Connection(  fileUrl.path)
        self.database = database
        let recettes = try self.database.prepare(recetteTable)
        for recette in recettes{
            print("Recette: \(recette[self.id]), Titre : \(recette[self.titre]), Etapes : \(recette[self.etapes]), Photo : \(recette[self.photo])")
            recettesSize = recettesSize + 1
            print("Recette size: \(recettesSize)")
            recetteNameArr.append(recette[self.titre])
            etapesArr.append(recette[self.etapes])
          //imageArr.append(recette[self.photo])
            }
        }
        catch {
            print(error)
        }
        instanciationBase()
        /*let getRecette : Recette = getIdRecetteByName(intituleRecette: "Boeuf bourguignon")
        print("Retour fonction getId \(getRecette.descriptor)")
        let getIngredientRecette = getIngredientByIdRecette(idR: 1)
        for ing in getIngredientRecette{
            print("getIngredient by Id \(ing.descriptor)")
        }*/
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return recettesSize
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("row selected: \(indexPath.row)")
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
        let myVC = storyboard?.instantiateViewController(withIdentifier: "MealViewController") as! MealViewController
        let ingR = getIngredientByIdRecette(idR: getIdRecetteByName(intituleRecette: recetteNameArr[indexPath.row]).id)
        print("IngRR id \(getIdRecetteByName(intituleRecette: recetteNameArr[indexPath.row]).id)")

        print("IngRR \(ingR)")
        myVC.ingPassed = ingR
        myVC.stringPassed = (recetteNameArr[indexPath.row])
        myVC.theImagePassed = (imageArr[indexPath.row])
        myVC.etapesPassed = (etapesArr[indexPath.row])
        //self.present(myVC, animated: true, completion: nil)
        navigationController?.pushViewController(myVC, animated: true)
        print("Done")
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
        /*do {
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor : nil, create: true)
            let fileUrl = documentDirectory.appendingPathComponent("recette").appendingPathExtension("sqlite3")
            let database = try Connection(fileUrl.path)
            self.database = database
            let recettes = try self.database.prepare(recetteTable)
            for recette in recettes{
                let recetteNew : Recette = Recette.init(id: recette[self.id], titre: recette[self.titre], etapes: recette[self.etapes], photo: recette[self.photo])
                arrayRecette.append(recetteNew)
                print("Recette new: \(recetteNew)")
                print("Recette array: \(arrayRecette[0].descriptor)")
            }
        }
        catch{
            print(error)
        }
        cell.intituleRecette.text! =   "\(arrayRecette[indexPath.row].titre)"*/
        cell.intituleRecette.text! = recetteNameArr[indexPath.row] as! String
        let session = URLSession(configuration: .default)
        
        //creating a dataTask
        let URLRECETTE = URL(string: imageArr[indexPath.row] as! String)
        let getImageFromUrl = session.dataTask(with: URLRECETTE!) { (data, response, error) in
            
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
                            cell.photoRecette.image = image
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
        return cell
    }
    

    
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    func getIdRecetteByName(intituleRecette: String) -> Recette{
        var recetteNew : Recette = Recette.init(id: 0, titre: "", etapes: "", photo: "")
        let getRecette = recetteTable.where(titre == intituleRecette)
        do {
            let testR = try self.database.prepare(getRecette)
            print("testR \(testR)")
            for test in testR {
                recetteNew = Recette.init(id: test[self.id], titre: intituleRecette, etapes: test[self.etapes], photo: test[self.photo])
            }
        }
        catch{
            print(error)
            
        }
        print("RecetteNew \(recetteNew)")

        return recetteNew
        
        
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
    
    func addRecette(id: Int, titre: String, etapes: String, photo: String){
        let insertRecette = self.recetteTable.insert(self.id <- id, self.titre <-  titre, self.etapes <- etapes, self.photo <- photo)
        do {
            try database.run(insertRecette)
            print("Recette inserted successfully")
        }
        catch {
            print(error)
        }
    }
    
    func addIngredient(id: Int, ingredient: String){
        let insertUser  = self.ingredientTable.insert(self.idIng <- id, self.titreIng <-  ingredient)
        do {
            try self.database.run(insertUser)
            print("Ingredient inserted successfully")
        }
        catch {
            print(error)
        }
    }
    
    func addLink(idRecette: Int, idIng: Int){
        let insertLink = self.linkTable.insert(self.idRecette <- idRecette, self.idIngredient <- idIng  )
        do {
            try self.database.run(insertLink)
            print("Link inserted successfully")
        }
        catch {
            print(error)
        }
    }
    
    func instanciationBase() {
        print("Dans l'instanciation")
        addRecette(id: 1, titre: "Boeuf bourguignon", etapes: "Tout cuire à feu doux", photo: "http://img-3.journaldesfemmes.com/rU_bebejJYXENTWkWfEkrgwFcB0=/750x/smart/d6db2baa728b47f8adbf30b99a957dc0/recipe-jdf/10002051.jpg")
        addRecette(id: 2, titre: "Poulet Curry", etapes: "Tout Mijoter ensemble", photo: "http://static.cuisineaz.com/610x610/i1494-curry-de-poulet-a-la-noix-de-coco.jpg")
        
        addIngredient(id: 1, ingredient: "Sel")
        addIngredient(id: 2, ingredient: "Poivre")
        /*addIngredient(id: 3, ingredient: "Oignon")
         addIngredient(id: 4, ingredient: "Beurre")
         addIngredient(id: 5, ingredient: "Bouquet garni")
         addIngredient(id: 6, ingredient: "Vin rouge")
         addIngredient(id: 7, ingredient: "Carotte")
         addIngredient(id: 8, ingredient: "Boeuf")
         addIngredient(id: 9, ingredient: "Lardon")*/
        addIngredient(id: 10, ingredient: "Blanc de poulet")
        addIngredient(id: 11, ingredient: "Crème fraiche")
        addIngredient(id: 12, ingredient: "Curry")
        addIngredient(id: 13, ingredient: "Cumin")
        addIngredient(id: 14, ingredient: "Riz thai")
        addIngredient(id: 15, ingredient: "Piment")
        
        
        /*addLink(idRecette: 1, idIng: 1)
         addLink(idRecette: 1, idIng: 2)
         addLink(idRecette: 1, idIng: 3)
         addLink(idRecette: 1, idIng: 4)
         addLink(idRecette: 1, idIng: 5)
         addLink(idRecette: 1, idIng: 6)
         addLink(idRecette: 1, idIng: 7)
         addLink(idRecette: 1, idIng: 8)
         addLink(idRecette: 1, idIng: 9)
         addLink(idRecette: 2, idIng: 1)
         addLink(idRecette: 2, idIng: 2)*/
        addLink(idRecette: 2, idIng: 10)
        addLink(idRecette: 2, idIng: 11)
        addLink(idRecette: 2, idIng: 12)
        addLink(idRecette: 2, idIng: 13)
        addLink(idRecette: 2, idIng: 14)
        addLink(idRecette: 2, idIng: 15)
        
        
        print("C'est fait")
        
    }
}
