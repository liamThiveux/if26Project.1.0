//
//  SQLiteViewController.swift
//  if26Project
//
//  Created by if26-grp2 on 30/11/2017.
//  Copyright © 2017 if26-grp2. All rights reserved.
//

import UIKit
import SQLite

class SQLiteViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
            print("test sqlClass")
            let db = sqlClass()
            db.connect()
            db.instanciationBase()
            print("test passé")
    }
    
    /*func instanciationBase() {
        print("Dans l'instanciation")
        
        let createTable = self.recetteTable.create { (table) in
            table.column(self.id, primaryKey: true)
            table.column(self.titre, unique: true)
            table.column(self.photo)
            table.column(self.etapes)
        }
        
        do {
            try self.database.run(createTable)
            print("successfully created")
        }
        catch {
            print(error)
        }
        
        let createFrigoTable = self.frigoTable.create { (table) in
            table.column(self.idfrigo, primaryKey: true)
            table.column(self.ingredientFrigo, unique : true)
        }
        do {
            try self.database.run(createFrigoTable)
            print("successfully created")
        }
        catch {
            print(error)
        }
        
        let createLinkTable = self.linkTable.create { (table) in
            table.column(self.idRecette)
            table.column(self.idIngredient)
            table.primaryKey(self.idRecette, self.idIngredient)
            table.foreignKey(self.idRecette, references: recetteTable, id)
            table.foreignKey(self.idIngredient, references: ingredientTable, idIng)
        }
        
        
        do {
            try self.database.run(createLinkTable)
            print("successfully created")
        }
        catch {
            print(error)
        }
        
        let createIngTable = self.ingredientTable.create { (table) in
            table.column(self.idIng, primaryKey: true)
            table.column(self.titreIng, unique: true)
        }
        
        do {
            try self.database.run(createIngTable)
            print("successfully created")
        }
        catch {
            print(error)
        }
        
        addRecette(id: 1, titre: "Boeuf bourguignon", etapes: "Tout cuire à feu doux", photo: "http://img-3.journaldesfemmes.com/rU_bebejJYXENTWkWfEkrgwFcB0=/750x/smart/d6db2baa728b47f8adbf30b99a957dc0/recipe-jdf/10002051.jpg")
        addRecette(id: 2, titre: "Poulet Curry", etapes: "Tout Mijoter ensemble", photo: "http://static.cuisineaz.com/610x610/i1494-curry-de-poulet-a-la-noix-de-coco.jpg")
        
        addIngredient(id: 1, ingredient: "Sel")
        addIngredient(id: 2, ingredient: "Poivre")
        addIngredient(id: 3, ingredient: "Oignon")
        addIngredient(id: 4, ingredient: "Beurre")
        addIngredient(id: 5, ingredient: "Bouquet garni")
        addIngredient(id: 6, ingredient: "Vin rouge")
        addIngredient(id: 7, ingredient: "Carotte")
        addIngredient(id: 8, ingredient: "Boeuf")
        addIngredient(id: 9, ingredient: "Lardon")
        addIngredient(id: 10, ingredient: "Blanc de poulet")
        addIngredient(id: 11, ingredient: "Crème fraiche")
        addIngredient(id: 12, ingredient: "Curry")
        addIngredient(id: 13, ingredient: "Cumin")
        addIngredient(id: 14, ingredient: "Riz thai")
        addIngredient(id: 15, ingredient: "Piment")


        addLink(idRecette: 1, idIng: 1)
        addLink(idRecette: 1, idIng: 2)
        addLink(idRecette: 1, idIng: 3)
        addLink(idRecette: 1, idIng: 4)
        addLink(idRecette: 1, idIng: 5)
        addLink(idRecette: 1, idIng: 6)
        addLink(idRecette: 1, idIng: 7)
        addLink(idRecette: 1, idIng: 8)
        addLink(idRecette: 1, idIng: 9)
        addLink(idRecette: 2, idIng: 1)
        addLink(idRecette: 2, idIng: 2)
        addLink(idRecette: 2, idIng: 10)
        addLink(idRecette: 2, idIng: 11)
        addLink(idRecette: 2, idIng: 12)
        addLink(idRecette: 2, idIng: 13)
        addLink(idRecette: 2, idIng: 14)
        addLink(idRecette: 2, idIng: 15)

        
        print("C'est fait")

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
    }*/

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
 
    /*func getIdRecetteByName(intituleRecette: String) -> Recette{
     
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
            let testTable = linkTable.join(recetteTable, on: idRecette == id)
            testTable.join(ingredientTable, on: idIngredient == idIng)
            let testIng = try self.database.prepare(testTable)
            for tIng in testIng{
                let ingredientR : Ingredient = Ingredient.init(id: tIng[self.idIng], ingredient: tIng[self.titreIng])
                print("ingredientR \(ingredientR.descriptor)")
                ing.append(ingredientR)
                print("ingredient array \(ing[0].descriptor)")

            }
        
        }
         catch{
         print(error)
         
         }
        return ing
    }*/
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
