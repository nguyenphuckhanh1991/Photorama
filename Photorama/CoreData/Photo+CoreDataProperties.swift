//
//  Photo+CoreDataProperties.swift
//  Photorama
//
//  Created by nguyen.phuc.khanh on 11/6/17.
//  Copyright © 2017 nguyen.phuc.khanh. All rights reserved.
//
//

import Foundation
import CoreData


extension Photo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Photo> {
        return NSFetchRequest<Photo>(entityName: "Photo")
    }

    @NSManaged public var photoID: String?
    @NSManaged public var title: String?
    @NSManaged public var remoteURL: NSObject?

}
