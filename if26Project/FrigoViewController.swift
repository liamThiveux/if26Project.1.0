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

    @IBOutlet weak var ingredientField: UITextField!
    @IBOutlet weak var frigoPicker: UIPickerView!
    @IBOutlet weak var ingredientLabel: UILabel!
    var values : [String] = []
    var database : Connection!
    var yPosIng : Int = 360

    //Table ingrédient
    let ingredientTable = Table("ingredientsRecette")
    let idIng = Expression<Int>("id")
    let titreIng = Expression<String>("ingredient")
    
    //Table ingrédientPossede
    let frigoTable = Table("frigo")
    let idfrigo = Expression<Int>("id")
    let ingredientFrigo = Expression<String>("ingredient")
    
    /*@IBAction func sendIngDB(_ sender: UIButton) {
     for (nbLabel)
        addIngredientFrigo(id: Int, ingredient: <#T##String#>)
    }*/
    
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
                let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 21))
                label.center = CGPoint(x: 120, y: yPos)
                label.textAlignment = .left
                label.text = "\(ingFrigo[self.ingredientFrigo])"
                yPos = yPos + 20;
                self.view.addSubview(label)
            }
        }
        catch{
            print(error)
        }
        //var test : SqliteClass?
        //test?.listRecette()
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
        self.ingredientField.text = self.values[row]
        let labelIng = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 21))
        labelIng.center = CGPoint(x: 120, y:yPosIng)
        labelIng.textAlignment = .left
        labelIng.text = "\(self.values[row])"
        yPosIng = yPosIng + 20;
        self.view.addSubview(labelIng)
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if textField == self.ingredientField {
        self.frigoPicker.isHidden = false
        textField.endEditing(true)
        }
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
}





