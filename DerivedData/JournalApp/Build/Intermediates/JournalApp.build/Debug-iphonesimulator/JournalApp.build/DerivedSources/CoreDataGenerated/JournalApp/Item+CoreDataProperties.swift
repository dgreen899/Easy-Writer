//
//  Item+CoreDataProperties.swift
//  
//
//  Created by Dameon Green on 8/22/17.
//
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension Item {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Item> {
        return NSFetchRequest<Item>(entityName: "Item")
    }

    @NSManaged public var date: String?
    @NSManaged public var entry: String?
    @NSManaged public var time: String?

}
