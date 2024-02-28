//
//  CategoryViewController.swift
//  Todoey
//
//  Created by ANSH on 23/02/24.
//  Copyright © 2024 App Brewery. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift
import SwipeCellKit

import ChameleonFramework

class CategoryViewController: SwipeTableViewController {
    let realm = try! Realm()
    
    var categories : Results<Category>?
    
    //let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 80.0
        tableView.separatorColor = .none
        
        loadCategory()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        guard let navBar = navigationController?.navigationBar else{
            fatalError("error")}
        
        navBar.backgroundColor = UIColor(hexString: "1D9BF6")
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if let category = categories?[indexPath.row]{
            cell.textLabel?.text = category.name
            
            
            guard let categoryColor = UIColor(hexString: category.Color)else{
                fatalError("error")
            }
            cell.backgroundColor = categoryColor
            cell.textLabel?.textColor = ContrastColorOf(categoryColor, returnFlat: true)
        }
        return cell
        
        //        cell.accessoryType = itemArray[indexPath.row].done ? .checkmark : .none
        //        alternatuve above
        //        if itemArray[indexPath.row].done == true{
        //            cell.accessoryType = .checkmark
        //        }
        //        else{
        //            cell.accessoryType = .none
        //        }
    }
    override func updateModel(at indexPath: IndexPath) {
        if let categoryForDeletion = self.categories?[indexPath.row]{
            do{
                try self.realm.write{
                    self.realm.delete(categoryForDeletion)
                }
            }catch{
                print(error)
            }
            
        }
    }
    //MARK: - delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        performSegue(withIdentifier: "goToItem", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoeyViewController
        
        if let indexPath = tableView.indexPathForSelectedRow{
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
    //MARK: - add button
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default){ (action) in
            
            let newItem = Category()
            newItem.name = textField.text!
            newItem.Color = UIColor.randomFlat().hexValue()
            //            newItem.done = false
            
           // self.categories.append(newItem)
            self.save(category : newItem)
            
            
            
            //
        }
        
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "create new item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true,completion: nil)
    }
    
    func save(category : Category ){
        
        do{
            try realm.write{
                realm.add(category)
            }
            
        }catch{
            print(error)
        }
        tableView.reloadData()
    }
    func loadCategory(){
        
        categories = realm.objects(Category.self)
        tableView.reloadData()
        
    }
    
}
    
    
    //extension CategoryViewController : UISearchBarDelegate{
    //    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    //        let request : NSFetchRequest<Item> = Item.fetchRequest()
    //
    //        request.predicate  = NSPredicate(format: "title CONTAINS[cd] %@",searchBar.text!)
    //
    //
    //
    //        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
    //
    //
    //        loadItems(with: request)
    //
    //    }
    //    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    //        if(searchBar.text!.count == 0){
    //            loadItems()
    //            DispatchQueue.main.async{
    //                searchBar.resignFirstResponder()
    //            }
    //        }
    //    }
    //}

	
