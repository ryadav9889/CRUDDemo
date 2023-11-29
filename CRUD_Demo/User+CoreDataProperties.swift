//
//  User+CoreDataProperties.swift
//  CRUD_Demo
//
//  Created by Vijay's Braintech on 06/11/23.
//
//

import Foundation
import CoreData
import UIKit


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var user_id: String?
    @NSManaged public var name: String?
    @NSManaged public var email: String?
    @NSManaged public var password: String?
    @NSManaged public var image: Data?

}

extension User : Identifiable {

}
