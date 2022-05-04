//
//  ValigiaViaggiante+CoreDataProperties.swift
//  tirocinio
//
//  Created by Cristian Cerasuolo on 04/05/22.
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
    @NSManaged public var oggettiviaggio: NSSet?
    @NSManaged public var viaggioriferimento: Viaggio?

}

// MARK: Generated accessors for oggettiviaggio
extension ValigiaViaggiante {

    @objc(addOggettiviaggioObject:)
    @NSManaged public func addToOggettiviaggio(_ value: Oggetto)

    @objc(removeOggettiviaggioObject:)
    @NSManaged public func removeFromOggettiviaggio(_ value: Oggetto)

    @objc(addOggettiviaggio:)
    @NSManaged public func addToOggettiviaggio(_ values: NSSet)

    @objc(removeOggettiviaggio:)
    @NSManaged public func removeFromOggettiviaggio(_ values: NSSet)

}

extension ValigiaViaggiante : Identifiable {

}
