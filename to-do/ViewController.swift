//
//  ViewController.swift
//  to-do
//
//  Created by user236106 on 3/19/24.
//

import UIKit


class ViewController: UIViewController {

    @IBOutlet private var table: UITableView!
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    var todoItems = [String]()

        override func viewDidLoad() {
            super.viewDidLoad()
            self.todoItems = UserDefaults.standard.stringArray(forKey: "todoItems") ?? []
            title = "To Do List"
            table.dataSource = self
            table.delegate = self
            table.register(UITableViewCell.self, forCellReuseIdentifier: "todoCell")
        }
        
        @IBAction private func didTapAdd(){
            let alert = UIAlertController(title: "New Item", message: "Enter New To Do List", preferredStyle: .alert)
            alert.addTextField {
                field in
                field.placeholder = "Enter list....."
            }
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            
            alert.addAction(UIAlertAction(title: "Done", style: .default, handler:
            {
                [weak self] (_) in
                if let field = alert.textFields?.first{
                    if let listitem = field.text, !listitem.isEmpty{
                        DispatchQueue.main.async {
                            var currentItems = UserDefaults.standard.stringArray(forKey: "todoItems") ?? []
                            currentItems.append(listitem)
            
                            UserDefaults.standard.setValue(currentItems, forKey: "todoItems")
                            self?.todoItems.append(listitem)
                            self?.table.reloadData()
                        }
                    }
                }
                
            }))
            
            present(alert, animated: true)
        }
    }

    extension ViewController: UITableViewDataSource {
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return todoItems.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "todoCell", for: indexPath)
            cell.textLabel?.text = todoItems[indexPath.row]
            return cell
        }
        
        func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            if editingStyle == .delete {
                todoItems.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        }
    }

    extension ViewController: UITableViewDelegate {
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            tableView.deselectRow(at: indexPath, animated: true)

        }
    }




