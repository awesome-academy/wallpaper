//
//  CoreData.swift
//  WallPaper_Project1
//
//  Created by DuyThai on 31/01/2023.
//

import Foundation
import UIKit
import CoreData

struct LocalData: CoreDataRepositoryType {
    static let shared = LocalData()

    private let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "WallPaper_Project1")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    func addToCoreData(data: CoreDataObject?, nameEntity: String, completion: @escaping (Error?) -> Void) {
        let managedContext = persistentContainer.viewContext
        guard let  entity = NSEntityDescription.entity(forEntityName: nameEntity, in: managedContext) else {
            return
        }
        let dataEntity = NSManagedObject(entity: entity, insertInto: managedContext)
        dataEntity.setValue(data?.id, forKey: "id")
        dataEntity.setValue(data?.width, forKey: "width")
        dataEntity.setValue(data?.height, forKey: "height")
        dataEntity.setValue(data?.url, forKey: "url")
        dataEntity.setValue(data?.photographer, forKey: "photographer")
        dataEntity.setValue(data?.photographerId, forKey: "photographerId")
        dataEntity.setValue(data?.avgColor, forKey: "avgColor")
        dataEntity.setValue(data?.isVideo, forKey: "isVideo")

        do {
            try managedContext.save()
        } catch let error {
            completion(error)
        }
    }

    func removeCoreData(id: Int, nameEntity: String, completion: @escaping (Error?) -> Void) {
        let managedContext = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: nameEntity)
        fetchRequest.includesPropertyValues = false
        do {
            let items = try managedContext.fetch(fetchRequest)
            for item in items where (item.value(forKey: "id") as? Int == id) {
                managedContext.delete(item)
            }
        } catch let error {
            completion(error)
            return
        }
        do {
            try managedContext.save()
        } catch let error {
            completion(error)
        }
    }

    func getDataFromCoreData(nameEntity: String, completion: @escaping ([NSManagedObject], Error?) -> (Void)) {
        let managedContext = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: nameEntity)
        fetchRequest.includesPropertyValues = false
        do {
            let items = try managedContext.fetch(fetchRequest)
            completion(items, nil)
        } catch let error as NSError {
            completion([], error)
        }

    }

    func checkInCoreData(id: Int, nameEntity: String) -> Bool {
        let managedContext = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: nameEntity)
        fetchRequest.includesPropertyValues = false
        do {
            let items = try managedContext.fetch(fetchRequest)
            for item in items {
                if (item.value(forKey: "id") as? Int == id) {
                    return true
                }
            }
        } catch  {
            return false
        }
        return false
    }
}
