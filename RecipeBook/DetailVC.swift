//
//  DetailVC.swift
//  RecipeBook
//
//  Created by William Farley on 4/22/17.
//  Copyright © 2017 William Farley. All rights reserved.
//

import UIKit

class DetailVC: UIViewController {
    
    var pickerIndex = 0
    var recipesArray = [Recipes]()

    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var ingredientsLabel: UILabel!
    @IBOutlet weak var recipePicker: UIPickerView!
    
    var defaultsData = UserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("Detail VC Loaded. recipesArray.count = \(recipesArray.count)")
                
        if recipesArray.count == 0 {
            performSegue(withIdentifier: "ToListVC", sender: nil)
        } else {
            refreshUI()
        }
        
        recipePicker.delegate = self
        recipePicker.dataSource = self
    }
    
    func refreshUI() {
        recipeImage.image = UIImage(named: recipesArray[pickerIndex].imageURL)
        
        if recipesArray[pickerIndex].imageURL.contains("http://") {
            let imageURL = URL(string: recipesArray[pickerIndex].imageURL)
            let data = try? Data(contentsOf: imageURL!)
            recipeImage.image = UIImage(data: data!)
        } else {
            if recipesArray[pickerIndex].imageURL == "defaultImage" {
                recipeImage.image = UIImage(named: recipesArray[pickerIndex].imageURL)
            } else {
                print("Here is where you'd fetch an image from your directory that was stored locally.")
            }
        }
        
        titleLabel.text = recipesArray[pickerIndex].title
        ingredientsLabel.text = recipesArray[pickerIndex].ingredients
        
        recipePicker.reloadAllComponents()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToListVC" {
            let destVC = segue.destination as! UINavigationController
            let targetVC = destVC.topViewController as! ListVC
            targetVC.recipesArray = recipesArray
        }
    }
    
    @IBAction func unwindFromListVC(sender: UIStoryboardSegue) {
        let sourceVC = sender.source as! ListVC
        recipesArray = sourceVC.recipesArray
        refreshUI()
    }

}

extension DetailVC: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return recipesArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return recipesArray[row].title
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pickerIndex = row
        refreshUI()
    }
}






