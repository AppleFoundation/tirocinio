//
//  Viaggio+CoreDataProperties.swift
//  tirocinio
//
//  Created by Cristian Cerasuolo on 04/05/22.
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
    @NSManaged public var valigieinviaggio: NSSet?

}

// MARK: Generated accessors for valigieinviaggio
extension Viaggio {

    @objc(addValigieinviaggioObject:)
    @NSManaged public func addToValigieinviaggio(_ value: ValigiaViaggiante)

    @objc(removeValigieinviaggioObject:)
    @NSManaged public func removeFromValigieinviaggio(_ value: ValigiaViaggiante)

    @objc(addValigieinviaggio:)
    @NSManaged public func addToValigieinviaggio(_ values: NSSet)

    @objc(removeValigieinviaggio:)
    @NSManaged public func removeFromValigieinviaggio(_ values: NSSet)

}

extension Viaggio : Identifiable {

}
