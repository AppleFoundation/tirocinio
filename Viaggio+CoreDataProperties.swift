//
//  Viaggio+CoreDataProperties.swift
//  tirocinio
//
//  Created by Cristian Cerasuolo on 29/04/22.
//
//

import Foundation
import CoreData


extension Viaggio {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Viaggio> {
        return NSFetchRequest<Viaggio>(entityName: "Viaggio")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var nome: String?
    @NSManaged public var data: Date?
    @NSManaged public var utilizzovaligia: NSSet?

}

// MARK: Generated accessors for utilizzovaligia
extension Viaggio {

    @objc(addUtilizzovaligiaObject:)
    @NSManaged public func addToUtilizzovaligia(_ value: Valigia)

    @objc(removeUtilizzovaligiaObject:)
    @NSManaged public func removeFromUtilizzovaligia(_ value: Valigia)

    @objc(addUtilizzovaligia:)
    @NSManaged public func addToUtilizzovaligia(_ values: NSSet)

    @objc(removeUtilizzovaligia:)
    @NSManaged public func removeFromUtilizzovaligia(_ values: NSSet)

}

extension Viaggio : Identifiable {

}
