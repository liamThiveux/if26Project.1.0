//
//  sqlClass.swift
//  if26Project
//
//  Created by if26-grp2 on 11/01/2018.
//  Copyright © 2018 if26-grp2. All rights reserved.
//

import Foundation
import SQLite

public class sqlClass {
    
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
    
    init() {
    }
    
    public func connect() {
        do {
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor : nil, create: true)
            let fileUrl = documentDirectory.appendingPathComponent("recette").appendingPathExtension("sqlite3")
            let database = try Connection(fileUrl.path)
            self.database = database
        }
        catch {
            print(error)
        }
    }
    
    public func instanciationBase() {
        
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
        
        print("Dans l'instanciation")
        addRecette(id: 1, titre: "Boeuf Bourguignon", etapes: "Tout cuire à feu doux", photo: "http://img-3.journaldesfemmes.com/rU_bebejJYXENTWkWfEkrgwFcB0=/750x/smart/d6db2baa728b47f8adbf30b99a957dc0/recipe-jdf/10002051.jpg")
        addRecette(id: 2, titre: "Poulet Curry", etapes: "Tout Mijoter ensemble", photo: "http://static.cuisineaz.com/610x610/i1494-curry-de-poulet-a-la-noix-de-coco.jpg")
        addRecette(id: 3, titre: "Pâtes Carbonara", etapes: "Cuire les pâtes.Pendant ce temps, faire dorer les lardons dans une poêle à sec.Lorsqu'ils sont dorés, ajouter la crème et laisser mijoter durant 10 minutes.Egoutter les pâtes, les verser dans la sauce, ajouter l'oeuf battu, mélanger et servir saupoudrer de fromage", photo: "http://static.750g.com/images/622-auto/f6ad72f2ac5f330143bd9bc27566dee6/comment-realiser-des-pates-carbonara-comme-en-italie.jpg")
        addRecette(id: 4, titre: "Spaghetti Bolognaise", etapes: "Rincer puis coupez les carottes et le cèleri en petits cubes. Réserver.Eplucher l’oignon et la gousse d’ail. Faire revenir l’ail et l’oignon hachés dans une poêle antiadhésive avec un peu d’huile d’olive pendant quelques minutes.Ajouter le céleri, la carotte, et faire revenir quelques minutes puis augmenter le feu. Ajouter la viande hachée, faire brunir en veillant à bien détacher la viande.Rajouter la sauce tomate Tomacouli, le concentré de tomates (ou les tomates), le thym et le laurier. Saler, poivrer et laisser mijoter la bolognese à feu doux pendant 10 minutes en remuant régulièrement.Cuire les spaghetti selon les indications de l’emballage, et servir avec un peu de parmesan et quelques feuilles de basilic frais .", photo: "http://static.cuisineaz.com/610x610/i84653-spaghettis-bolognaise-rapides.jpg")
        addRecette(id: 5, titre: "Canard à l'orange", etapes: "Presser 6 oranges.Dissoudre le bouillon cube dans un verre d'eau bouillante.Farcir le canard avec des quartiers d'orange et des zestes, en répartir également sur le canard et dans le plat.Arroser de jus d'orange, d'un bon verre de vin blanc et du bouillon cube dissous; saler et poivrer.Enfourner à 240°C (Th 8) pendant 18 min (pour 500 g).Arroser de temps en temps et retourner en milieu de cuisson.", photo: "https://www.atelierdeschefs.com/media/recette-e17754-canard-a-l-orange-express.jpg" )
        
        addIngredient(id: 1, ingredient: "Sel")
        addIngredient(id: 2, ingredient: "Poivre")
        addIngredient(id: 3, ingredient: "Oignon")
        addIngredient(id: 4, ingredient: "Beurre")
        addIngredient(id: 5, ingredient: "Bouquet garni")
        addIngredient(id: 6, ingredient: "Vin rouge")
        addIngredient(id: 7, ingredient: "Carotte")
        addIngredient(id: 8, ingredient: "Boeuf")
        addIngredient(id: 9, ingredient: "Lardon")
        addIngredient(id: 10, ingredient: "Céleri")
        addIngredient(id: 11, ingredient: "Boeuf haché")
        addIngredient(id: 12, ingredient: "Concentré de tomate")
        addIngredient(id: 13, ingredient: "Gousse d'ail")
        addIngredient(id: 14, ingredient: "Huile d'olive")
        addIngredient(id: 15, ingredient: "Origan")
        addIngredient(id: 16, ingredient: "Spaghetti")
        addIngredient(id: 17, ingredient: "Sauce tomate")
        addIngredient(id: 18, ingredient: "Tagliatelle")
        addIngredient(id: 19, ingredient: "Oeuf")
        addIngredient(id: 20, ingredient: "Crème fraîche")
        addIngredient(id: 21, ingredient: "Gruyère")
        addIngredient(id: 22, ingredient: "Blancs de poulet")
        addIngredient(id: 23, ingredient: "Curry")
        addIngredient(id: 24, ingredient: "Cumin")
        addIngredient(id: 25, ingredient: "Piment")
        addIngredient(id: 26, ingredient: "Canette")
        addIngredient(id: 27, ingredient: "Orange")
        addIngredient(id: 28, ingredient: "Vin blanc")
        addIngredient(id: 29, ingredient: "Bouillon cube")
        
        
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
        addLink(idRecette: 2, idIng: 3)
        addLink(idRecette: 2, idIng: 20)
        addLink(idRecette: 2, idIng: 22)
        addLink(idRecette: 2, idIng: 23)
        addLink(idRecette: 2, idIng: 24)
        addLink(idRecette: 2, idIng: 25)
        
        
        addLink(idRecette: 3, idIng: 1)
        addLink(idRecette: 3, idIng: 2)
        addLink(idRecette: 3, idIng: 9)
        addLink(idRecette: 3, idIng: 18)
        addLink(idRecette: 3, idIng: 19)
        addLink(idRecette: 3, idIng: 20)
        addLink(idRecette: 3, idIng: 21)
        
        addLink(idRecette: 4, idIng: 3)
        addLink(idRecette: 4, idIng: 7)
        addLink(idRecette: 4, idIng: 10)
        addLink(idRecette: 4, idIng: 11)
        addLink(idRecette: 4, idIng: 12)
        addLink(idRecette: 4, idIng: 13)
        addLink(idRecette: 4, idIng: 14)
        addLink(idRecette: 4, idIng: 15)
        addLink(idRecette: 4, idIng: 16)
        addLink(idRecette: 4, idIng: 17)
        
        addLink(idRecette: 5, idIng: 1)
        addLink(idRecette: 5, idIng: 2)
        addLink(idRecette: 5, idIng: 26)
        addLink(idRecette: 5, idIng: 27)
        addLink(idRecette: 5, idIng: 28)
        addLink(idRecette: 5, idIng: 29)
        
        print("C'est fait")
        
    }
    public var createFrigoTable: Void {
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
    
    public var createLinkTable: Void {
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
    
    public func addRecette(id: Int, titre: String, etapes: String, photo: String){
        let insertRecette = self.recetteTable.insert(self.id <- id, self.titre <-  titre, self.etapes <- etapes, self.photo <- photo)
        do {
            try database.run(insertRecette)
            print("Recette inserted successfully")
        }
        catch {
            print(error)
        }
    }
    
    public func addIngredient(id: Int, ingredient: String){
        let insertUser  = self.ingredientTable.insert(self.idIng <- id, self.titreIng <-  ingredient)
        do {
            try self.database.run(insertUser)
            print("Ingredient inserted successfully")
        }
        catch {
            print(error)
        }
    }
    
    public func addLink(idRecette: Int, idIng: Int){
        let insertLink = self.linkTable.insert(self.idRecette <- idRecette, self.idIngredient <- idIng  )
        do {
            try self.database.run(insertLink)
            print("Link inserted successfully")
        }
        catch {
            print(error)
        }
    }
        
    public func listRecette() {
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
    
    public func createIngredientTable() {
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

    
    public func createTable() {
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
    
    public func getRecetteById(idR: Int) -> Recette{
        
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
    
    public func getIdRecetteByName(intituleRecette: String) -> Recette{
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

    public func deleteLink(idDel: Int){
        print   ("Bouton   DELETE")
        let ingToDel = self.linkTable.filter(self.idRecette == idDel)
        let deleteIng = ingToDel.delete()
        do {
            try self.database.run(deleteIng)
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
