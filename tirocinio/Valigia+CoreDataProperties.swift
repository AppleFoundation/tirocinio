//
//  Valigia+CoreDataProperties.swift
//  tirocinio
//
//  Created by Cristian Cerasuolo on 17/06/22.
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
    @NSManaged public var valigiaInViaggio: NSSet?
    
}

// MARK: Generated accessors for valigiaInViaggio
extension Valigia {
    
    @objc(addValigiaInViaggioObject:)
    @NSManaged public func addToValigiaInViaggio(_ value: ValigiaViaggiante)
    
    @objc(removeValigiaInViaggioObject:)
    @NSManaged public func removeFromValigiaInViaggio(_ value: ValigiaViaggiante)
    
    @objc(addValigiaInViaggio:)
    @NSManaged public func addToValigiaInViaggio(_ values: NSSet)
    
    @objc(removeValigiaInViaggio:)
    @NSManaged public func removeFromValigiaInViaggio(_ values: NSSet)
    
}

extension Valigia : Identifiable {
    
}
