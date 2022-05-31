//
//  Oggetto+CoreDataProperties.swift
//  tirocinio
//
//  Created by Cristian Cerasuolo on 31/05/22.
//
//

import Foundation
import CoreData


extension Oggetto {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Oggetto> {
        return NSFetchRequest<Oggetto>(entityName: "Oggetto")
    }

    @NSManaged public var categoria: String?
    @NSManaged public var id: UUID?
    @NSManaged public var larghezza: Int32
    @NSManaged public var lunghezza: Int32
    @NSManaged public var nome: String?
    @NSManaged public var peso: Int32
    @NSManaged public var profondita: Int32
    @NSManaged public var volume: Int32

}

extension Oggetto : Identifiable {

}
