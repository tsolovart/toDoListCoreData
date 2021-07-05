//
//  TableViewController.swift
//  toDoListCoreData
//
//  Created by Zaoksky on 05.07.2021.
//

import UIKit
import CoreData

class TableViewController: UITableViewController {
    
    var tasks: [Tasks] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated )
        
        // путь до контекста NSPersistentContainer
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        // запрос на данные
        let fetchRequest: NSFetchRequest<Tasks> = Tasks.fetchRequest()
        
        do {
            tasks = try context.fetch(fetchRequest)
        } catch let error as NSError{
            print(error.localizedDescription)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // метод добавляения данных в CoreData
    func saveTask(withTitle title: String) {
        // путь до контекста NSPersistentContainer
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        guard let entity = NSEntityDescription.entity(forEntityName: "Tasks", in: context) else { return }
        let taskObject = Tasks(entity: entity, insertInto: context)
        taskObject.title = title
        
        // запись контекста
        do {
            try context.save()
            // добавление в []
            tasks.append(taskObject)
        } catch let error as NSError{
            print(error.localizedDescription)
        }
    }
    
    @IBAction func addTask(_ sender: UIBarButtonItem) {
        let ac = UIAlertController(title: "New task", message: "Enter the task", preferredStyle: .alert)
        let saveTask = UIAlertAction(title: "Save", style: .default) { action in
            let tf = ac.textFields?.first
            if let newTask = tf?.text {
                // добавление новых элементов в []
                self.saveTask(withTitle: newTask)
                // перезагрузка tf
                self.tableView.reloadData()
            }
        }
        ac.addTextField { _ in }
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        
        ac.addAction(saveTask)
        ac.addAction(cancelAction)
        present(ac, animated: true, completion: nil)
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let task = tasks[indexPath.row]
        cell.textLabel?.text = task.title
        return cell
    }
}
