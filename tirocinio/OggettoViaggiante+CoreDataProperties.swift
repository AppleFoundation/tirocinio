//
//  OggettoViaggiante+CoreDataProperties.swift
//  tirocinio
//
//  Created by Cristian Cerasuolo on 17/06/22.
//
//

import Foundation
import CoreData


extension OggettoViaggiante {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<OggettoViaggiante> {
        return NSFetchRequest<OggettoViaggiante>(entityName: "OggettoViaggiante")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var quantitaAllocata: Int32
    @NSManaged public var quantitaInViaggio: Int32
    @NSManaged public var istanzaInValigia: NSSet?
    @NSManaged public var oggettoRef: Oggetto?
    @NSManaged public var viaggioRef: Viaggio?

}

// MARK: Generated accessors for istanzaInValigia
extension OggettoViaggiante {

    @objc(addIstanzaInValigiaObject:)
    @NSManaged public func addToIstanzaInValigia(_ value: OggettoInValigia)

    @objc(removeIstanzaInValigiaObject:)
    @NSManaged public func removeFromIstanzaInValigia(_ value: OggettoInValigia)

    @objc(addIstanzaInValigia:)
    @NSManaged public func addToIstanzaInValigia(_ values: NSSet)

    @objc(removeIstanzaInValigia:)
    @NSManaged public func removeFromIstanzaInValigia(_ values: NSSet)

}

extension OggettoViaggiante : Identifiable {

}
