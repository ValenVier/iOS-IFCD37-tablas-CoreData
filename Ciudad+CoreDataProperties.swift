//
//  Ciudad+CoreDataProperties.swift
//  tablas-CoreData
//
//  Created by Javier Rodríguez Valentín on 30/09/2021.
//
//

import Foundation
import CoreData


extension Ciudad {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Ciudad> {
        return NSFetchRequest<Ciudad>(entityName: "Ciudad")
    }

    @NSManaged public var nombre: String?

}

extension Ciudad : Identifiable {

}
