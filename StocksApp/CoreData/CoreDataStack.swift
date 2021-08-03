//
//  CoreDatasTag.swift
//  StocksApp
//
//  Created by Офелия on 13.07.2021.
//

import Foundation
import CoreData

class CoreDataStack {
    
    private let modelName: String
    
    init(modelName: String) {
        self.modelName = modelName
    }
    //NSManagedObject возвращает кордата по нашему запросу
    //класс описывает модель данных - загружается первой при иниц NSManagedObjectmodel
    //coordinator достает данные из NSManagedObjectmodel и передает в контекст
    //persistent store хоанит данные
    //Context служит для получения/хранения/изменения объектов из хранилища контекст сохраняет копии из координатора и потом нужно сделать save
    
    //контекст которому принадлежит сущность
    lazy var managedContext: NSManagedObjectContext = {
        return self.storeContainer.viewContext
    }()
    
   
    lazy var backgroundContext: NSManagedObjectContext = {
        return self.storeContainer.newBackgroundContext()
    }()
    
    //контейнер-хранилище которе сохраняет данные между запусками приложениями
   private lazy var storeContainer: NSPersistentContainer = {
        //создает быстро стэк
        let container = NSPersistentContainer(name: self.modelName)
        //открывает файл базы данных self.modelName
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                print("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    func saveContext () {
        guard managedContext.hasChanges else { return }
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Unresolved error \(error), \(error.userInfo)")
        }
    }
}
