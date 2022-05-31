//
//  OggettoViaggiante+CoreDataProperties.swift
//  tirocinio
//
//  Created by Cristian Cerasuolo on 31/05/22.
//
//

import Foundation
import CoreData


extension OggettoViaggiante {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<OggettoViaggiante> {
        return NSFetchRequest<OggettoViaggiante>(entityName: "OggettoViaggiante")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var quantity: Int16
    @NSManaged public var oggettoPadre: Oggetto?
    @NSManaged public var valigiaContenitrice: ValigiaViaggiante?

}

extension OggettoViaggiante : Identifiable {

}
