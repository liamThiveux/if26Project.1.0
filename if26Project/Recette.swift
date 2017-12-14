//
//  Recette.swift
//  if26Project
//
//  Created by if26-grp2 on 12/12/2017.
//  Copyright © 2017 if26-grp2. All rights reserved.
//

import Foundation

public class Recette  {
    var id: Int
    var titre: String
    var etapes: String
    var photo: String
    
    init(id: Int, titre: String, etapes: String, photo: String) {
        self.id = id
        self.titre = titre
        self.etapes = etapes
        self.photo = photo
    }
    
    public var descriptor: String {
        return "Recette (\(id),\(titre),\(etapes),\(photo))"
    }
}

