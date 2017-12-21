//
//  SqliteClass.swift
//  if26Project
//
//  Created by if26-grp2 on 21/12/2017.
//  Copyright © 2017 if26-grp2. All rights reserved.
//

import Foundation
import SQLite

public class SqliteClass  {

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
    
    func ConnectionDB()
    {
        do{
    let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor : nil, create: true)
    let fileUrl = documentDirectory.appendingPathComponent("recette").appendingPathExtension("sqlite3")
    let database = try Connection(fileUrl.path)
    self.database = database
        }
    catch{
            print(error)
        }
    }

    
    func instanciationBase() {
        print("Dans l'instanciation")
        ConnectionDB()
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
    
func createFrigoTable() {
    ConnectionDB()
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
    
func createLinkTable() {
    ConnectionDB()
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
        ConnectionDB()
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
        ConnectionDB()
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
        ConnectionDB()
        let insertLink = self.linkTable.insert(self.idRecette <- idRecette, self.idIngredient <- idIng  )
        do {
            try self.database.run(insertLink)
            print("Link inserted successfully")
        }
        catch {
            print(error)
        }
    }
    
    
func listRecette() {
    ConnectionDB()
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
    
 func createIngredientTable() {
    ConnectionDB()
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

    
func createTable() {
    ConnectionDB()
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
    
    func getIdRecetteByName(intituleRecette: String) -> Recette{
        ConnectionDB()
        
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
        ConnectionDB()
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
    }
}
