//
//  Recipes.swift
//  RecipeBook
//
//  Created by William Farley on 4/22/17.
//  Copyright © 2017 William Farley. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class RecipesUserDefaults: NSObject, NSCoding {
    var title = ""
    var ingredients = ""
    var imageURL = ""
    var href = ""
    
    var availableIngredients = [String]()
    
    override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        title = aDecoder.decodeObject(forKey: "title") as! String
        ingredients = aDecoder.decodeObject(forKey: "ingredients") as! String
        imageURL = aDecoder.decodeObject(forKey: "imageURL") as! String
        href = aDecoder.decodeObject(forKey: "href") as! String
        availableIngredients = aDecoder.decodeObject(forKey: "availableIngredients") as! [String]
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(title, forKey: "title")
        aCoder.encode(ingredients, forKey: "ingredients")
        aCoder.encode(imageURL, forKey: "imageURL")
        aCoder.encode(href, forKey: "href")
        aCoder.encode(availableIngredients, forKey: "availableIngredients")
    }
    
}

class Recipes: RecipesUserDefaults {

        
    struct GenericRecipe {
        var title: String
        var ingredients: String
        var thumbnail: String
        var href: String
    }
    
    var searchArray = [GenericRecipe]()
    
    func getRecipe(ingredients: String, type: String, page: Int, completed: @escaping () -> ()) {
        let baseURL = "http://www.recipepuppy.com/api/?"
        var fullURL = ""
        
        if ingredients != "" {
            fullURL = baseURL + "i=" + ingredients
            if type != "" {
                fullURL = fullURL + "&q=" + type
            }
        } else {
            if type != "" {
                fullURL = baseURL + "q=" + type
            }
        }
        fullURL += "&p=\(page)"
        
        print(fullURL)
        
        Alamofire.request(fullURL).responseJSON {
            response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                
                self.searchArray = []
                
                print("********************")
                if json["results"].count > 0 {
                    for i in 0...json["results"].count-1 {
                        let title = json["results"][i]["title"].stringValue
                        let ingredients = json["results"][i]["ingredients"].stringValue
                        let thumbnail = json["results"][i]["thumbnail"].stringValue
                        let href = json["results"][i]["href"].stringValue
                        self.searchArray.append(GenericRecipe(title: title, ingredients: ingredients, thumbnail: thumbnail, href: href))
                    }
                }
            case .failure(let error):
                print(error)
            }
            completed()
        }
    }
}
