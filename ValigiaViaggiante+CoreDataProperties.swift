//
//  ValigiaViaggiante+CoreDataProperties.swift
//  tirocinio
//
//  Created by Salvatore Apicella on 11/06/22.
//
//

import Foundation
import CoreData


extension ValigiaViaggiante {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ValigiaViaggiante> {
        return NSFetchRequest<ValigiaViaggiante>(entityName: "ValigiaViaggiante")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var valigiaRef: Valigia?
    @NSManaged public var viaggioRef: Viaggio?

}

extension ValigiaViaggiante : Identifiable {

}
