//
//  Valigia+CoreDataProperties.swift
//  tirocinio
//
//  Created by Cristian Cerasuolo on 31/05/22.
//
//

import Foundation
import CoreData


extension Valigia {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Valigia> {
        return NSFetchRequest<Valigia>(entityName: "Valigia")
    }

    @NSManaged public var categoria: String?
    @NSManaged public var id: UUID?
    @NSManaged public var larghezza: Int32
    @NSManaged public var lunghezza: Int32
    @NSManaged public var nome: String?
    @NSManaged public var profondita: Int32
    @NSManaged public var tara: Int32
    @NSManaged public var utilizzato: Bool
    @NSManaged public var volume: Int32
    @NSManaged public var valigiainviaggio: NSSet?

}

// MARK: Generated accessors for valigiainviaggio
extension Valigia {

    @objc(addValigiainviaggioObject:)
    @NSManaged public func addToValigiainviaggio(_ value: ValigiaViaggiante)

    @objc(removeValigiainviaggioObject:)
    @NSManaged public func removeFromValigiainviaggio(_ value: ValigiaViaggiante)

    @objc(addValigiainviaggio:)
    @NSManaged public func addToValigiainviaggio(_ values: NSSet)

    @objc(removeValigiainviaggio:)
    @NSManaged public func removeFromValigiainviaggio(_ values: NSSet)

}

extension Valigia : Identifiable {

}
