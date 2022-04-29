//
//  Valigia+CoreDataProperties.swift
//  tirocinio
//
//  Created by Cristian Cerasuolo on 29/04/22.
//
//

import Foundation
import CoreData


extension Valigia {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Valigia> {
        return NSFetchRequest<Valigia>(entityName: "Valigia")
    }

    @NSManaged public var categoria: String?
    @NSManaged public var lunghezza: Int32
    @NSManaged public var larghezza: Int32
    @NSManaged public var profondita: Int32
    @NSManaged public var volume: Int32
    @NSManaged public var tara: Int32
    @NSManaged public var id: UUID?
    @NSManaged public var nome: String?
    @NSManaged public var utilizzato: Bool
    @NSManaged public var oggetticontenuti: NSSet?
    @NSManaged public var utilizzoviaggio: NSSet?

}

// MARK: Generated accessors for oggetticontenuti
extension Valigia {

    @objc(addOggetticontenutiObject:)
    @NSManaged public func addToOggetticontenuti(_ value: Oggetto)

    @objc(removeOggetticontenutiObject:)
    @NSManaged public func removeFromOggetticontenuti(_ value: Oggetto)

    @objc(addOggetticontenuti:)
    @NSManaged public func addToOggetticontenuti(_ values: NSSet)

    @objc(removeOggetticontenuti:)
    @NSManaged public func removeFromOggetticontenuti(_ values: NSSet)

}

// MARK: Generated accessors for utilizzoviaggio
extension Valigia {

    @objc(addUtilizzoviaggioObject:)
    @NSManaged public func addToUtilizzoviaggio(_ value: Viaggio)

    @objc(removeUtilizzoviaggioObject:)
    @NSManaged public func removeFromUtilizzoviaggio(_ value: Viaggio)

    @objc(addUtilizzoviaggio:)
    @NSManaged public func addToUtilizzoviaggio(_ values: NSSet)

    @objc(removeUtilizzoviaggio:)
    @NSManaged public func removeFromUtilizzoviaggio(_ values: NSSet)

}

extension Valigia : Identifiable {

}
