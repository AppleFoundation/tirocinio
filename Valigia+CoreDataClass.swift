//
//  Valigia+CoreDataClass.swift
//  tirocinio
//
//  Created by Cristian Cerasuolo on 29/04/22.
//
//

import Foundation
import CoreData

@objc(Valigia)
public class Valigia: NSManagedObject {
    
    override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
            super.init(entity: entity, insertInto: context)
        }
    
    
}
