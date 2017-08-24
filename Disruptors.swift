//
//  DisruptorsEntity+CoreDataClass.swift
//  
//
//  Created by Javid Poornasir on 8/15/17.
//
//

import Foundation
import CoreData


class Disruptors: NSManagedObject {
    @NSManaged public var delayInterval: Int16
    @NSManaged public var name: String?
    @NSManaged public var type: String?
    @NSManaged public var timeStamp: NSDate?
}
