//
//  Viaggio+CoreDataProperties.swift
//  tirocinio
//
//  Created by Cristian Cerasuolo on 15/06/22.
//
//

import Foundation
import CoreData


extension Viaggio {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Viaggio> {
        return NSFetchRequest<Viaggio>(entityName: "Viaggio")
    }

    @NSManaged public var data: Date?
    @NSManaged public var id: UUID?
    @NSManaged public var nome: String?

}

extension Viaggio : Identifiable {

}
