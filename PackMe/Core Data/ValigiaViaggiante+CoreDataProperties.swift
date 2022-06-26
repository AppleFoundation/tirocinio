//
//  ValigiaViaggiante+CoreDataProperties.swift
//  tirocinio
//
//  Created by Cristian Cerasuolo on 17/06/22.
//
//

import Foundation
import CoreData


extension ValigiaViaggiante {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<ValigiaViaggiante> {
        return NSFetchRequest<ValigiaViaggiante>(entityName: "ValigiaViaggiante")
    }
    
    @NSManaged public var id: UUID?
    @NSManaged public var pesoAttuale: Int32
    @NSManaged public var pesoMassimo: Int32
    @NSManaged public var volumeAttuale: Int32
    @NSManaged public var contenuto: NSSet?
    @NSManaged public var valigiaRef: Valigia?
    @NSManaged public var viaggioRef: Viaggio?
    
}

// MARK: Generated accessors for contenuto
extension ValigiaViaggiante {
    
    @objc(addContenutoObject:)
    @NSManaged public func addToContenuto(_ value: OggettoInValigia)
    
    @objc(removeContenutoObject:)
    @NSManaged public func removeFromContenuto(_ value: OggettoInValigia)
    
    @objc(addContenuto:)
    @NSManaged public func addToContenuto(_ values: NSSet)
    
    @objc(removeContenuto:)
    @NSManaged public func removeFromContenuto(_ values: NSSet)
    
}

extension ValigiaViaggiante : Identifiable {
    
}
