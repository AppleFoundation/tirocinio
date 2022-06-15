//
//  OggettoViaggiante+CoreDataProperties.swift
//  tirocinio
//
//  Created by Cristian Cerasuolo on 15/06/22.
//
//

import Foundation
import CoreData


extension OggettoViaggiante {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<OggettoViaggiante> {
        return NSFetchRequest<OggettoViaggiante>(entityName: "OggettoViaggiante")
    }

    @NSManaged public var allocato: Bool
    @NSManaged public var id: UUID?
    @NSManaged public var quantitaInViaggio: Int32
    @NSManaged public var contenitore: ValigiaViaggiante?
    @NSManaged public var oggettoRef: Oggetto?
    @NSManaged public var viaggioRef: Viaggio?

}

extension OggettoViaggiante : Identifiable {

}
