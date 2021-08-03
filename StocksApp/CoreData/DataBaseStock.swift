//
//  DataBaseStock.swift
//  StocksApp
//
//  Created by Офелия on 13.07.2021.
//

import Foundation
import CoreData

protocol DataBaseProtocol {
    func create(_ stock: Stock)
    func remove(_ name: String)
    func removeAll()
    func filter(_ name: String) -> Bool
    
}

class DataBaseStock {
    let backgroundContext: NSManagedObjectContext!
    let context: NSManagedObjectContext!
    
    init(backgroundContext: NSManagedObjectContext?, context: NSManagedObjectContext?) {
        self.backgroundContext = backgroundContext
        self.context = context
    }
    
}

extension DataBaseStock: DataBaseProtocol {
    
    func removeAll() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "StockBD")
        fetchRequest.returnsObjectsAsFaults = false
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try self.backgroundContext.execute(deleteRequest)
            try self.backgroundContext.save()
        } catch let error {
            print("Detele all data in \("StockBD") error :", error)
            
        }
    }
    
    func filter(_ name: String) -> Bool {
        let request: NSFetchRequest<StockBD> = StockBD.fetchRequest()
        request.predicate = NSPredicate(format: "name = %@", name)
        guard let result = try? backgroundContext.fetch(request) else {
            return false
        }
        return result.isEmpty ? false : true
    }
    
    
    func create(_ model: Stock) {
        let entity = StockBD.find(byUid: model.name, context: backgroundContext)
        entity.name = model.name
        entity.amount = (model.price?.amount ?? 0.0)
        entity.percentChange = (model.percentChange)
        entity.volume = Int32(model.volume)
        entity.symbol = model.symbol
        do {
            try backgroundContext.save()
        } catch let error {
            print(error)
        }
    }
    func remove(_ name: String) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "StockBD")
        //let request: NSFetchRequest<StockBD> = StockBD.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name = %@", name)
        let delete = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try self.backgroundContext.execute(delete)
            try self.backgroundContext.save()
        } catch let error {
            print("Detele all data in \("StockBD") error :", error)
        }
    }
    
    //func fetch() -> [Stock] {
    //        let fetchRequest: NSFetchRequest<StockBD> = NSFetchRequest(entityName: String(describing: StockBD.self)
    //        )
    //        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
    //        fetchRequest.fetchBatchSize = 20
    //        fetchRequest.sortDescriptors = [sortDescriptor]
    //        fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
    //        fetchResultController.delegate = self
    //        do {
    //            try! fetchResultController.performFetch()
    //
    //        } catch {
    //            print("Fetch failed")
    //        }
    // }
}
