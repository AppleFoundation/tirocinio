//
//  Oggetto+CoreDataClass.swift
//  tirocinio
//
//  Created by Cristian Cerasuolo on 15/06/22.
//
//

import Foundation
import CoreData

@objc(Oggetto)
public class Oggetto: NSManagedObject , Comparable{
    public static func < (lhs: Oggetto, rhs: Oggetto) -> Bool {
        return lhs.volume > rhs.volume;
    }
}
