//
//  StockBD+CoreDataProperties.swift
//  StocksApp
//
//  Created by Офелия on 12.07.2021.
//
//

import Foundation
import CoreData


extension StockBD {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<StockBD> {
        return NSFetchRequest<StockBD>(entityName: "StockBD")
    }

    @NSManaged public var amount: Double
    @NSManaged public var name: String?
    @NSManaged public var percentChange: Double
    @NSManaged public var symbol: String?
    @NSManaged public var volume: Int32

}

extension StockBD : Identifiable {
        static func find(byUid name: String, context: NSManagedObjectContext) -> StockBD {
            let request: NSFetchRequest<StockBD> = StockBD.fetchRequest()
            request.predicate = NSPredicate(format: "name = %@", name)
            guard let result = try? context.fetch(request)
                else { return StockBD(context: context) }
            return result.first ?? StockBD(context: context)
        }
}
