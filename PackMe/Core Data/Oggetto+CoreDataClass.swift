//
//  Oggetto+CoreDataClass.swift
//  tirocinio
//
//  Created by Cristian Cerasuolo on 17/06/22.
//
//

import Foundation
import CoreData


public class Oggetto: NSManagedObject, Comparable {
    public static func < (lhs: Oggetto, rhs: Oggetto) -> Bool {
        return lhs.volume > rhs.volume;
    }
}
