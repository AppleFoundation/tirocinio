//
//  ValigiaViaggiante+CoreDataProperties.swift
//  tirocinio
//
//  Created by Cristian Cerasuolo on 31/05/22.
//
//

import Foundation
import CoreData


extension ValigiaViaggiante {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ValigiaViaggiante> {
        return NSFetchRequest<ValigiaViaggiante>(entityName: "ValigiaViaggiante")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var valigiariferimento: Valigia?
    @NSManaged public var viaggioriferimento: Viaggio?
    @NSManaged public var oggettiviaggianti: NSSet?

}

// MARK: Generated accessors for oggettiviaggianti
extension ValigiaViaggiante {

    @objc(addOggettiviaggiantiObject:)
    @NSManaged public func addToOggettiviaggianti(_ value: OggettoViaggiante)

    @objc(removeOggettiviaggiantiObject:)
    @NSManaged public func removeFromOggettiviaggianti(_ value: OggettoViaggiante)

    @objc(addOggettiviaggianti:)
    @NSManaged public func addToOggettiviaggianti(_ values: NSSet)

    @objc(removeOggettiviaggianti:)
    @NSManaged public func removeFromOggettiviaggianti(_ values: NSSet)

}

extension ValigiaViaggiante : Identifiable {

}
