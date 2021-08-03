//
//  FavoritesViewController.swift
//  StocksApp
//
//  Created by Офелия on 05.07.2021.
//

import UIKit
import CoreData

var persistentContainer: NSPersistentContainer = {
    let container = NSPersistentContainer(name:"Model")
    container.loadPersistentStores(completionHandler: { (storeDescription, error) in
        if let error = error {
            fatalError("Unresolved error, \((error as NSError).userInfo)")
        }
    })
    return container
}()

func saveContext() {
    let context = persistentContainer.viewContext
    do {
        try context.save()
    } catch {
        let nserror = error as NSError
        fatalError("\(nserror), \(nserror.userInfo)")
    }
}

class FavoritesViewController: UIViewController {
    
    lazy private var tableView : UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    var fetchResultController: NSFetchedResultsController<StockBD>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        navigationItem.title = "Favorite ❤️"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(removeAll))
        self.navigationItem.rightBarButtonItem?.tintColor = .black

    }
    
    @objc func removeAll() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "StockBD")
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let results = try persistentContainer.viewContext.fetch(fetchRequest)
            for object in results {
                guard let objectData = object as? NSManagedObject else {continue}
                persistentContainer.viewContext.delete(objectData)
                saveContext()
            }
        } catch let error {
            print("Detele all data in error :", error)
        }
    }
    
    //MARK: - настройка таблицы
    func configureTableView() {
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(StockTableViewCell.self, forCellReuseIdentifier: StockTableViewCell.cellId)
        tableView.separatorStyle = .none
    }
    override func viewDidLayoutSubviews() {
        tableView.frame = view.bounds
    }
    
    func loadData(){
        let fetchRequest: NSFetchRequest<StockBD> = NSFetchRequest(entityName: String(describing: StockBD.self)
        )
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.fetchBatchSize = 20
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchResultController.delegate = self
        do {
            try! fetchResultController.performFetch()
            tableView.reloadData()
        } catch {
            print("Fetch failed")
        }
    }
}

extension FavoritesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchResultController.fetchedObjects?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: StockTableViewCell.cellId, for: indexPath) as! StockTableViewCell
        
        //получили модель из кор даты
        let rslt = self.fetchResultController.object(at: indexPath)
        
        // взяли значения из кордаты и установили в фейворит ячейку
        cell.configure(rslt, index: indexPath.row)
        
        //тапнули на феворит ячейку по звездочке
        cell.didFavoriteTapped = { [weak self] in
            guard let self = self else { return }
            
            let rslt = self.fetchResultController.object(at: indexPath)
            
            //удалили ячейку
            persistentContainer.viewContext.performAndWait {
                persistentContainer.viewContext.delete(rslt)
            }
            saveContext()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return StockTableViewCell.cellHeight
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let rslt = self.fetchResultController.object(at: indexPath)
            persistentContainer.viewContext.delete(rslt)
            saveContext()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        loadData()
    }
}

extension FavoritesViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .automatic)
        case .update:
            tableView.reloadRows(at: [indexPath!], with: .automatic)
        case .move:
            tableView.deleteRows(at: [indexPath!], with: .automatic)
            tableView.insertRows(at: [newIndexPath!], with: .automatic)
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .automatic)
        default:
            break
        }
        self.tableView.reloadData()
    }
}
