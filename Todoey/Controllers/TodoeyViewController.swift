//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class TodoeyViewController: SwipeTableViewController {
    
    var toDoItems : Results<Item>?
    let realm = try! Realm()

    var selectedCategory : Category? {
        didSet{
          loadItems()
            tableView.rowHeight = 80.0
        }
    }
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        //        print(dataFilePath)
     //   print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        
        
        
        //        if let items = defaults.array(forKey: "ToDoListArray") as? [String]{
        //            toDoItems = items
        //        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let colourHex = selectedCategory?.Color{
            title = selectedCategory!.name
            guard let navBar = navigationController?.navigationBar else{
                fatalError("error")}
            if let navBarColor = UIColor(hexString: colourHex){
                navBar.backgroundColor = navBarColor
                
                navBar.tintColor = ContrastColorOf(navBarColor, returnFlat: true)
                searchBar.barTintColor = navBarColor
                
                navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : ContrastColorOf(navBarColor, returnFlat: true)]
            }
        }
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoItems?.count ?? 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = toDoItems?[indexPath.row]{
            cell.textLabel?.text = item.title
            
            if let colour = UIColor(hexString: selectedCategory!.Color)?.darken(byPercentage: CGFloat(indexPath.row)/CGFloat(toDoItems!.count)){
                cell.backgroundColor = colour
                cell.textLabel?.textColor =  ContrastColorOf(colour, returnFlat: true)
            }
            
            cell.accessoryType = item.done ?  .checkmark : .none
        }
        else{
            cell.textLabel?.text = "No Items added"
        }
        //        alternatuve above
        //        if toDoItems[indexPath.row].done == true{
        //            cell.accessoryType = .checkmark
        //        }
        //        else{
        //            cell.accessoryType = .none
        //        }
        
        return cell
    }
    
    override func updateModel(at indexPath: IndexPath) {
        if let itemForDeletion = toDoItems?[indexPath.row]{
            do{
                try realm.write{
                    realm.delete(itemForDeletion)
                }
            }catch{
                print(error)
            }
            
        }
    }
    //MARK: - delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let item = toDoItems?[indexPath.row]{
            do{
                try realm.write{
                    item.done = !item.done
//                    realm.delete(item)
                }
            }catch{
                print(error)
            }
        }
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    //MARK: - add button
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default){ (action) in
            if let currentCategory = self.selectedCategory{
                do{
                    try self.realm.write{
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.dateCreated = Date()
                        currentCategory.items.append(newItem)
                        
                    }
                }catch{
                    print(error)
                }
                
              
            }
            self.tableView.reloadData()
            
        }
        
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "create new item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true,completion: nil)
    }
    
   
    func loadItems(){
            toDoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
            tableView.reloadData()
        }
}
    //
    //
extension TodoeyViewController : UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        toDoItems = toDoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
           
        }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            if searchBar.text?.count == 0 {
                        loadItems()
    
                        DispatchQueue.main.async {
                            searchBar.resignFirstResponder()
                        }
    
                    }
        }
    }
//}
