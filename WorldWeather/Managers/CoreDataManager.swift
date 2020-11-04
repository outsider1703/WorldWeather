//
//  CoreDataManager.swift
//  WorldWeather
//
//  Created by Macbook on 02.11.2020.
//  Copyright © 2020 Igor Simonov. All rights reserved.
//

import CoreData

class CoreDataManager {
    
    static let shared = CoreDataManager()
    private init() {}
    
    private var viewContext: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "WorldWeatherData")
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                print(error.localizedDescription)
            }
        })
        return container
    }()
    
    func saveContext() {
        if viewContext.hasChanges {
            do {
                try viewContext.save()
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }
    
    func getDataFromFile() {
        guard let pathToFile = Bundle.main.path(forResource: "CityData", ofType: "plist"),
              let dataArray = NSArray(contentsOfFile: pathToFile) else { return }
        
        for dictionary in dataArray {
            guard let entityDescription = NSEntityDescription.entity(forEntityName: "Place",
                                                                     in: viewContext) else { return }
            guard let placeItem = NSManagedObject(entity: entityDescription,
                                                  insertInto: viewContext) as? Place else { return }
            
            let placeDictionary = dictionary as! [String: AnyObject]
            
            placeItem.cityName = placeDictionary["name"] as? String
            
            let attractionArray = placeDictionary["attractions"] as! Array<Any>
            let newTimeSetForTask = placeItem.attractions?.mutableCopy() as? NSMutableOrderedSet
            
            for attractionDictionaryItem in attractionArray {
                guard let entityDescription = NSEntityDescription.entity(forEntityName: "Attraction",
                                                                         in: viewContext) else { return }
                guard let attractionItem = NSManagedObject(entity: entityDescription,
                                                           insertInto: viewContext) as? Attraction else { return }
                
                let attractionsDictionary = attractionDictionaryItem as! [String: AnyObject]
                
                attractionItem.name = attractionsDictionary["name"] as? String
                attractionItem.image = attractionsDictionary["image"] as? String
                attractionItem.lat = attractionsDictionary["lat"] as? String
                attractionItem.lon = attractionsDictionary["lon"] as? String
                attractionItem.desc = attractionsDictionary["desc"] as? String
                attractionItem.descFull = attractionsDictionary["descFull"] as? String
                
                newTimeSetForTask?.add(attractionItem)
            }
            placeItem.attractions = newTimeSetForTask
        }
        saveContext()
    }
    func filterFetchFor(city: String) -> [Place] {
        let fetchRequest: NSFetchRequest<Place> = Place.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "ANY cityName = %@", city)

        var tasks = [Place]()

        do {
            tasks = try viewContext.fetch(fetchRequest)
        } catch let error {
            print(error)
        }
        return tasks
    }
    
    func fetchData() -> [Place] {
        let fetchRequest: NSFetchRequest<Place> = Place.fetchRequest()
        var tasks = [Place]()
        do {
            tasks = try viewContext.fetch(fetchRequest)
        } catch let error {
            print(error)
        }
        return tasks
    }
    
    func delete(_ deleteTask: Place) {
        viewContext.delete(deleteTask)
        saveContext()
    }
    
}
