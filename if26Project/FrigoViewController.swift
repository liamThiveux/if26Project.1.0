//
//  FrigoViewController.swift
//  if26Project
//
//  Created by if26-grp2 on 29/11/2017.
//  Copyright © 2017 if26-grp2. All rights reserved.
//

import UIKit
import Foundation
import SQLite

class FrigoViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var frigoPicker: UIPickerView!
    @IBOutlet weak var ingredientLabel: UILabel!
    @IBOutlet weak var vousAjoutez: UILabel!
    var values : [String] = []
    var database : Connection!
    var yPosIng : Int = 360
    var nbLabel : Int = 0
    var i = 1

    //Table ingrédient
    let ingredientTable = Table("ingredientsRecette")
    let idIng = Expression<Int>("id")
    let titreIng = Expression<String>("ingredient")
    
    //Table ingrédientPossede
    let frigoTable = Table("frigo")
    let idfrigo = Expression<Int>("id")
    let ingredientFrigo = Expression<String>("ingredient")
    
    
    @IBAction func sendIngDB(_ sender: UIButton) {
        print("Dans le bouton send")
        let labels = self.view.subviews.flatMap { $0 as? UILabel }
        let size = labels.count
        print("nb label : \(size)")
        var ingredientsToAddDB : [Ingredient] = []
        for label in labels {
            let ingredientToAdd = getIdIngByName(name: label.text!)
            ingredientsToAddDB.append(ingredientToAdd)
        }
        for ingredientDB in ingredientsToAddDB {
            if ingredientDB.ingredient != "" {
                addIngredientFrigo(id: ingredientDB.id, ingredient: ingredientDB.ingredient)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        frigoPicker.delegate = self
        frigoPicker.dataSource = self
        do {
        let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor : nil, create: true)
        let fileUrl = documentDirectory.appendingPathComponent("recette").appendingPathExtension("sqlite3")
        let database = try Connection(  fileUrl.path)
            self.database = database}
        catch{
            print(error)
        }
        do {
        let valDB = try self.database.prepare(ingredientTable)
        for val in valDB {
            values.append(val[self.titreIng])
        }
        }
        catch{
            print(error)
        }
        do{
            let frigo = try self.database.prepare(frigoTable)
            var yPos : Int = 150
            for ingFrigo in frigo {
                print("size frigo \(ingFrigo[self.ingredientFrigo])")
                let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 21))
                label.center = CGPoint(x: 120, y: yPos)
                label.textAlignment = .left
                label.text = "\(ingFrigo[self.ingredientFrigo])"
                label.tag = i
                print("label tag + nom \(label.tag) - \(label.text)")
                i = i+1
                self.view.addSubview(label)
                let buttonDel = UIButton(frame: CGRect(x: 100, y: 100, width: 100, height: 20))
                buttonDel.setTitle("Supprimer", for: .normal)
                buttonDel.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
                buttonDel.center = CGPoint(x: 300, y: yPos)
                buttonDel.tag = i
                i = i+1
                yPos = yPos + 20;
                print("bouton to add : \(buttonDel.tag)")
                self.view.addSubview(buttonDel)

            }
            yPos = yPos + 20
            frigoPicker.center = CGPoint(x: 300, y: yPos)
            vousAjoutez.center = CGPoint(x: 120, y: yPos)
            yPosIng = yPos + 20
        }
        catch{
            print(error)
        }
        //var test : SqliteClass?
        //test?.listRecette()
    }

    
    @objc func buttonAction(sender: UIButton!) {
        print("Button tapped")
        print("Sender tag \(sender.tag)")
        var labelText = ""
        let ingToFind = sender.tag-1
        if let theLabel = self.view.viewWithTag(ingToFind) as? UILabel
        {
            labelText = (theLabel.text as! String)
        }
        print("label text \(labelText)")
        let ingToDel = getIdIngByName(name: labelText)
        print("\(ingToDel.descriptor)")
        deleteIng(idDel: ingToDel.id)
        let labelDel = self.view.viewWithTag(sender.tag - 1) as? UILabel
        labelDel?.removeFromSuperview()
        sender.removeFromSuperview()
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
       return 1
    }
    
    //Nombre d'élément
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return values.count
    }
    
    //Peuplement du pickerView
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return values[row]
    }
    
    //Clic sur le pickerView
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let labelIng = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 21))
        labelIng.center = CGPoint(x: 120, y:yPosIng)
        labelIng.textAlignment = .left
        labelIng.text = "\(self.values[row])"
        yPosIng = yPosIng + 20;
        self.view.addSubview(labelIng)
        nbLabel = nbLabel+1
    }

    func addIngredientFrigo(id: Int, ingredient: String){
                do {
                    try database.run(frigoTable.insert(idfrigo <- id, ingredientFrigo <- ingredient))
                    print("Ingredient inserted successfully")
                }
                catch {
                    print(error)
            }
    }
    
    func getIdIngByName(name: String) -> Ingredient{
        var ingNew : Ingredient = Ingredient.init(id: 0, ingredient: "")
        let getIng = ingredientTable.where(titreIng == name)
        do {
            let testR = try self.database.prepare(getIng)
            print("testR \(testR)")
            for test in testR {
                ingNew = Ingredient.init(id: test[self.idIng], ingredient: test[self.titreIng])
            }
        }
        catch{
            print(error)
            
        }
        print("RecetteNew \(ingNew)")
        return ingNew
    }

    func course(){
        addIngredientFrigo(id: 1, ingredient: "Sel")
        addIngredientFrigo(id: 2, ingredient: "Poivre")
        addIngredientFrigo(id: 3, ingredient: "Oignon")
        addIngredientFrigo(id: 4, ingredient: "Beurre")
        addIngredientFrigo(id: 5, ingredient: "Bouquet garni")
        addIngredientFrigo(id: 6, ingredient: "Vin rouge")
        addIngredientFrigo(id: 7, ingredient: "Carotte")
        addIngredientFrigo(id: 8, ingredient: "Boeuf")
        addIngredientFrigo(id: 9, ingredient: "Lardon")
        print("les courses sont faites")
    }
    
    func createFrigoTable() {
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
    func deleteIng(idDel : Int){
    print   ("Bouton   DELETE")
        let ingToDel = self.frigoTable.filter(self.idfrigo == idDel)
        let deleteIng = ingToDel.delete()
        do {
            try self.database.run(deleteIng)
        }
        catch {
            print(error)
        }
    }
    
}





