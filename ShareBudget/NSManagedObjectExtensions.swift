//
// Created by Denys Meloshyn on 25/09/2019.
// Copyright (c) 2019 Denys Meloshyn. All rights reserved.
//

import CoreData

extension NSManagedObject {
    class func find(modelID: Int, managedObjectContext: NSManagedObjectContext) -> Self? {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = self.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "modelID == %i", modelID)
        fetchRequest.fetchLimit = 1

        return try? managedObjectContext.fetch(fetchRequest).first as? Self
    }

    class func findOrCreate(modelID: Int, managedObjectContext: NSManagedObjectContext) -> Self {
        find(modelID: modelID, managedObjectContext: managedObjectContext) ?? self.init(context: managedObjectContext)
    }
}
