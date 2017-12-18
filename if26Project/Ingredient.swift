//
//  Ingredient.swift
//  if26Project
//
//  Created by if26-grp2 on 12/12/2017.
//  Copyright © 2017 if26-grp2. All rights reserved.
//

import Foundation

public class Ingredient  {
    var id: Int
    var ingredient: String
    
    init(id: Int, ingredient: String) {
        self.id = id
        self.ingredient = ingredient
    }
    
    public var descriptor: String {
        return "Ingredient(\(id),\(ingredient))"
    }
}
