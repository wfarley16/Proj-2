//
//  ListVC.swift
//  RecipeBook
//
//  Created by William Farley on 4/22/17.
//  Copyright © 2017 William Farley. All rights reserved.
//

import UIKit

class ListVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var recipesArray = [Recipes]()
    var index = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("List VC Loaded. recipesArray.count = \(recipesArray.count)")
        
        if recipesArray.count == 0 {
            performSegue(withIdentifier: "ToAddVC", sender: nil)
        } else {
            for i in recipesArray {
                print(i)
            }
        }
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func saveUserDefaults() {
        var recipesDefaultsArray = [RecipesUserDefaults]()
        recipesDefaultsArray = recipesArray
        let recipeData = NSKeyedArchiver.archivedData(withRootObject: recipesDefaultsArray)
        UserDefaults.standard.set(recipeData, forKey: "recipeData")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToAddVC" {
            let destVC = segue.destination as! UINavigationController
            let targetVC = destVC.topViewController as! AddVC
            
            if index == -1 {
                if let selectedRow = tableView.indexPathForSelectedRow {
                    tableView.deselectRow(at: selectedRow, animated: true)
                }
                targetVC.recipeToImport.title = ""
            } else {
                targetVC.recipeToImport = recipesArray[index]
            }
        }
        
    }
    
    @IBAction func unwindFromAddVC(sender: UIStoryboardSegue) {
        let sourceVC = sender.source as! AddVC
        
        let newRecipe = Recipes()
        newRecipe.title = sourceVC.recipeToImport.title
        newRecipe.ingredients = sourceVC.recipeToImport.ingredients
        newRecipe.imageURL = sourceVC.recipeToImport.imageURL
        
        if newRecipe.imageURL.characters.count == 0 {
            newRecipe.imageURL = "defaultImage"
        }
        
        print("New Recipe Title: \(newRecipe.title)")
        
        if let selectedRow = tableView.indexPathForSelectedRow {
            recipesArray[selectedRow.row] = newRecipe
            tableView.deselectRow(at: selectedRow, animated: true)
        } else {
            recipesArray.append(newRecipe)
        }
        
        saveUserDefaults()
        
        tableView.reloadData()
    }

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "ToAddVC", sender: nil)
    }
}

extension ListVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! RecipeCell
        cell.configureRecipeCell(title: recipesArray[indexPath.row].title, ingredients: recipesArray[indexPath.row].ingredients, imageURL: recipesArray[indexPath.row].imageURL)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        index = indexPath.row
        performSegue(withIdentifier: "ToAddVC", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.recipesArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            saveUserDefaults()
        }
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let recipeToMove = recipesArray[sourceIndexPath.row]
        recipesArray.remove(at: sourceIndexPath.row)
        recipesArray.insert(recipeToMove, at: destinationIndexPath.row)
        saveUserDefaults()
    }
    
}
