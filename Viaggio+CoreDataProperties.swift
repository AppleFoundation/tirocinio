//
//  Viaggio+CoreDataProperties.swift
//  tirocinio
//
//  Created by Salvatore Apicella on 11/06/22.
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
    @NSManaged public var oggetti: NSSet?
    @NSManaged public var valigie: NSSet?

}

// MARK: Generated accessors for oggetti
extension Viaggio {

    @objc(addOggettiObject:)
    @NSManaged public func addToOggetti(_ value: OggettoViaggiante)

    @objc(removeOggettiObject:)
    @NSManaged public func removeFromOggetti(_ value: OggettoViaggiante)

    @objc(addOggetti:)
    @NSManaged public func addToOggetti(_ values: NSSet)

    @objc(removeOggetti:)
    @NSManaged public func removeFromOggetti(_ values: NSSet)

}

// MARK: Generated accessors for valigie
extension Viaggio {

    @objc(addValigieObject:)
    @NSManaged public func addToValigie(_ value: ValigiaViaggiante)

    @objc(removeValigieObject:)
    @NSManaged public func removeFromValigie(_ value: ValigiaViaggiante)

    @objc(addValigie:)
    @NSManaged public func addToValigie(_ values: NSSet)

    @objc(removeValigie:)
    @NSManaged public func removeFromValigie(_ values: NSSet)

}

extension Viaggio : Identifiable {

}
