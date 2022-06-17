//
//  OggettoInValigia+CoreDataProperties.swift
//  tirocinio
//
//  Created by Cristian Cerasuolo on 17/06/22.
//
//

import Foundation
import CoreData


extension OggettoInValigia {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<OggettoInValigia> {
        return NSFetchRequest<OggettoInValigia>(entityName: "OggettoInValigia")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var quantitaInValigia: Int32
    @NSManaged public var contenitore: ValigiaViaggiante?
    @NSManaged public var oggettoViaggianteRef: OggettoViaggiante?
    @NSManaged public var viaggioRef: Viaggio?

}

extension OggettoInValigia : Identifiable {

}
