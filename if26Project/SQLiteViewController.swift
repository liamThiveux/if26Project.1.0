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

    var database : Connection!
    
    // Table recette
    let recetteTable = Table("recettes")
    let id = Expression<Int>("id")
    let titre = Expression<String>("titre")
    let photo = Expression<String>("photo")
    let etapes = Expression<String>("etapes")


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
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        do {
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor : nil, create: true)
            let fileUrl = documentDirectory.appendingPathComponent("recette").appendingPathExtension("sqlite3")
            let database = try Connection(fileUrl.path)
            self.database = database
            instanciationBase()
        }
        catch {
            print(error)
        }
    }
    
    func instanciationBase() {
        print("Dans l'instanciation")
        addRecette(id: 1, titre: "Boeuf bourguignon", etapes: "Tout cuire à feu doux", photo: "url/url/url")
        addRecette(id: 2, titre: "Poulet Curry", etapes: "Tout Mijoter ensemble", photo: "/url/url/url")
        
        addIngredient(id: 1, ingredient: "Sel")
        addIngredient(id: 2, ingredient: "Poivre")
        addIngredient(id: 3, ingredient: "Oignon")
        addIngredient(id: 4, ingredient: "Beurre")
        addIngredient(id: 5, ingredient: "Bouquet garni")
        addIngredient(id: 6, ingredient: "Vin rouge")
        addIngredient(id: 7, ingredient: "Carotte")
        addIngredient(id: 8, ingredient: "Boeuf")
        addIngredient(id: 9, ingredient: "Lardon")

        addLink(idRecette: 1, idIng: 1)
        addLink(idRecette: 1, idIng: 2)
        addLink(idRecette: 1, idIng: 3)
        addLink(idRecette: 1, idIng: 4)
        addLink(idRecette: 1, idIng: 5)
        addLink(idRecette: 1, idIng: 6)
        addLink(idRecette: 1, idIng: 7)
        addLink(idRecette: 1, idIng: 8)
        addLink(idRecette: 1, idIng: 9)

        print("C'est fait")

    }
    
    @IBAction func createFrigoTable(_ sender: UIButton) {
        print("Asking to create FRIGO TABLE")
        
        let createTable = self.frigoTable.create { (table) in
            table.column(self.idfrigo, primaryKey: true)
            table.column(self.ingredientFrigo, unique : true)
        }
        do {
            try self.database.run(createTable)
            print("successfully created")
        }
        catch {
            print(error)
        }
    }
    
    @IBAction func createLinkTable(_ sender: UIButton) {
        print("Asking to create Link table")
        
        let createTable = self.linkTable.create { (table) in
            table.column(self.idRecette)
            table.column(self.idIngredient)
            table.primaryKey(self.idRecette, self.idIngredient)
            table.foreignKey(self.idRecette, references: recetteTable, id)
            table.foreignKey(self.idIngredient, references: ingredientTable, idIng)
        }

        
        do {
            try self.database.run(createTable)
            print("successfully created")
        }
        catch {
            print(error)
        }

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
    
    @IBAction func insertRecette(_ sender: UIButton) {
        print   ("Bouton   insert")
        let   alert   =   UIAlertController(title:   "Insert   Recette",   message:   nil,   preferredStyle:   .alert)
        alert.addTextField   {   (tf)   in   tf.placeholder   =   "Titre recette"}
        alert.addTextField   {   (tf)   in   tf.placeholder   =   "Etapes"}
        alert.addTextField   {   (tf)   in   tf.placeholder   =   "photoUrl"}
        let   action   =   UIAlertAction(title:   "Submit",   style:   .default)   {   (_)   in
            guard let   name   =   alert.textFields?.first?.text,
                let   email   = alert.textFields![1].text,
                let photo =   alert.textFields?.last?.text
                else   {   return   }
            print   (name)
            print   (email)
            print   (photo)
            
            let insertUser  = self.recetteTable.insert(self.titre <- name, self.etapes <-  email, self.photo <- photo)
            
            do {
                try self.database.run(insertUser)
                print("Recette inserted")
            }
            catch {
                print(error)
            }
        }
        alert.addAction(action)
        present(alert,   animated:   true,   completion:   nil)
    }
    
    @IBAction func listRecette(_ sender: UIButton) {
    print   ("Bouton   LIST")
        do {
            let users = try self.database.prepare(self.recetteTable)
            for user in users{
                print("Recette: \(user[self.id]), Titre : \(user[self.titre]), Etapes : \(user[self.etapes]), Photo : \(user[self.photo])")
            }
            let ingredients = try self.database.prepare(self.ingredientTable)
            for ing in ingredients{
                print("ID: \(ing[self.idIng]), ingredient : \(ing[self.titreIng])")
            }
            let link = try self.database.prepare(self.linkTable)
            for l in link {
                print("id recette \(l[self.idRecette]), id ingredient : \(l[self.idIngredient])")
            }
        }
        catch {
            print(error)
        }
    }
    
    @IBAction func createIngredientTable(_ sender: UIButton) {
        print("Asking to create Ingredient table")
        
        let createTable = self.ingredientTable.create { (table) in
            table.column(self.idIng, primaryKey: true)
            table.column(self.titreIng, unique: true)
        }
        
        do {
            try self.database.run(createTable)
            print("successfully created")
        }
        catch {
            print(error)
        }

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func createTable(_ sender: UIButton) {
        print("Asking to create table")
        
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
