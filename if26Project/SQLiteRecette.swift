//
//  SQLite.swift
//  if26Project
//
//  Created by if26-grp2 on 30/11/2017.
//  Copyright © 2017 if26-grp2. All rights reserved.
//

import Foundation
import SQLite3

class SQLiteRecette  {

let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
    .appendingPathComponent("recetteEtIngredient.sqlite")

// open database
var db: OpaquePointer?

func openDb(){
    if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
        print("error opening database")
    }
}

func createDb(){
    if sqlite3_exec(db, "create table if not exists recetteEtIngredient (titre text primary key, etapes text, photo text, ingredient1 text, ingredient2 text, ingredient3 text, ingredient4 text, ingredient5 text, ingredient6 text, ingredient7 text)", nil, nil, nil) != SQLITE_OK {
        let errmsg = String(cString: sqlite3_errmsg(db)!)
        print("error creating table: \(errmsg)")
    }
    else{
        print("Table créée")
    }
}

var statement: OpaquePointer?

func insert(){

    if sqlite3_prepare_v2(db, "insert into recetteEtIngredient (titre) values (?)", -1, &statement, nil) != SQLITE_OK {
        let errmsg = String(cString: sqlite3_errmsg(db)!)
        print("error preparing insert: \(errmsg)")
    }
    if sqlite3_bind_text(statement, 1, "foo", -1, SQLITE_TRANSIENT) != SQLITE_OK {
        let errmsg = String(cString: sqlite3_errmsg(db)!)
        print("failure binding foo: \(errmsg)")
    }
    if sqlite3_step(statement) != SQLITE_DONE {
        let errmsg = String(cString: sqlite3_errmsg(db)!)
        print("failure inserting foo: \(errmsg)")
    }
}

internal let SQLITE_STATIC = unsafeBitCast(0, to: sqlite3_destructor_type.self)
internal let SQLITE_TRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type.self)

func reset(){
if sqlite3_reset(statement) != SQLITE_OK {
    let errmsg = String(cString: sqlite3_errmsg(db)!)
    print("error resetting prepared statement: \(errmsg)")
}

if sqlite3_bind_null(statement, 1) != SQLITE_OK {
    let errmsg = String(cString: sqlite3_errmsg(db)!)
    print("failure binding null: \(errmsg)")
}

if sqlite3_step(statement) != SQLITE_DONE {
    let errmsg = String(cString: sqlite3_errmsg(db)!)
    print("failure inserting null: \(errmsg)")
}
}

func finalize() {
    if sqlite3_finalize(statement) != SQLITE_OK {
    let errmsg = String(cString: sqlite3_errmsg(db)!)
    print("error finalizing prepared statement: \(errmsg)")
    }

    statement = nil
}

func getRecette(){
    if sqlite3_prepare_v2(db, "select * from recetteEtIngredient", -1, &statement, nil) != SQLITE_OK {
        let errmsg = String(cString: sqlite3_errmsg(db)!)
        print("error preparing select: \(errmsg)")
}

    while sqlite3_step(statement) == SQLITE_ROW {
        let titre = sqlite3_column_int64(statement, 0)
        print("recette = \(titre); ", terminator: "")
    
        if let cString = sqlite3_column_text(statement, 1) {
            let etapes = String(cString: cString)
            print("etapes = \(etapes)")
        } else {
            print("recette not found")
        }
}
    if sqlite3_finalize(statement) != SQLITE_OK {
        let errmsg = String(cString: sqlite3_errmsg(db)!)
        print("error finalizing prepared statement: \(errmsg)")
}

    statement = nil
}

func closeDb(){
    if sqlite3_close(db) != SQLITE_OK {
    print("error closing database")
    }
    db = nil
}
    
}
