//
//  OggettoViaggiante+CoreDataProperties.swift
//  tirocinio
//
//  Created by Salvatore Apicella on 31/05/22.
//
//

import Foundation
import CoreData


extension OggettoViaggiante {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<OggettoViaggiante> {
        return NSFetchRequest<OggettoViaggiante>(entityName: "OggettoViaggiante")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var oggettoRef: Oggetto?
    @NSManaged public var viaggioRef: Viaggio?

}

extension OggettoViaggiante : Identifiable {

}
