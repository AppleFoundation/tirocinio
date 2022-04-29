//
//  Oggetto+CoreDataProperties.swift
//  tirocinio
//
//  Created by Cristian Cerasuolo on 29/04/22.
//
//

import Foundation
import CoreData


extension Oggetto {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Oggetto> {
        return NSFetchRequest<Oggetto>(entityName: "Oggetto")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var nome: String?
    @NSManaged public var larghezza: Int32
    @NSManaged public var lunghezza: Int32
    @NSManaged public var profondita: Int32
    @NSManaged public var volume: Int32
    @NSManaged public var peso: Int32
    @NSManaged public var categoria: String?
    @NSManaged public var valigiacontenitore: NSSet?

}

// MARK: Generated accessors for valigiacontenitore
extension Oggetto {

    @objc(addValigiacontenitoreObject:)
    @NSManaged public func addToValigiacontenitore(_ value: Valigia)

    @objc(removeValigiacontenitoreObject:)
    @NSManaged public func removeFromValigiacontenitore(_ value: Valigia)

    @objc(addValigiacontenitore:)
    @NSManaged public func addToValigiacontenitore(_ values: NSSet)

    @objc(removeValigiacontenitore:)
    @NSManaged public func removeFromValigiacontenitore(_ values: NSSet)

}

extension Oggetto : Identifiable {

}
