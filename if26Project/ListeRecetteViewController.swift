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
    
    // Table recette
    let recetteTable = Table("recettes")
    let id = Expression<Int>("id")
    let titre = Expression<String>("titre")
    let photo = Expression<String>("photo")
    let etapes = Expression<String>("etapes")
    var recettesSize : Int = 0
    var   arrayRecette:   [Recette]   =   []
    
    let identifiantRecetteCellule = "celulleRecette"

    
    override func viewDidLoad() {
        super.viewDidLoad()
        do {
        let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor : nil, create: true)
        let fileUrl = documentDirectory.appendingPathComponent("recette").appendingPathExtension("sqlite3")
        let database = try Connection(fileUrl.path)
        self.database = database
        let recettes = try self.database.prepare(recetteTable)
        for recette in recettes{
            print("Recette: \(recette[self.id]), Titre : \(recette[self.titre]), Etapes : \(recette[self.etapes]), Photo : \(recette[self.photo])")
            recettesSize = recettesSize + 1
            print("Recette size: \(recettesSize)")
            }
        }
        catch {
            print(error)
        }
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
    

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifiantRecetteCellule, for: indexPath)
        do {
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
        cell.textLabel?.text   =   "\(arrayRecette[indexPath.row].titre)"
        cell.detailTextLabel?.text = "\(arrayRecette[indexPath.row].photo)"
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

}
