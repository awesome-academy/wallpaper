//
//  CoreDataRepository.swift
//  WallPaper_Project1
//
//  Created by DuyThai on 01/02/2023.
//

import Foundation
import CoreData

protocol CoreDataRepositoryType {
    func addToCoreData(data: CoreDataObject?, nameEntity: String, completion: @escaping (Error?) -> Void)

    func removeCoreData(id: Int, nameEntity: String, completion: @escaping (Error?) -> Void)

    func getDataFromCoreData(nameEntity: String, completion: @escaping ([NSManagedObject], Error?) -> (Void))

    func checkInCoreData(id: Int, nameEntity: String) -> Bool
}
