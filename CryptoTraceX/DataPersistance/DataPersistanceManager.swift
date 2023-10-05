//
//  DataPersistanceManager.swift
//  CryptoTraceX
//
//  Created by Mac Book Air M1 on 01.10.2023.
//

import UIKit
import CoreData

final class DataPersistanceManager {
    
    // MARK: - DataBaseError
    
    enum DataBaseError : Error {
        case failedToSaveData
        case failedToFetchData
        case failedToDeleteData
    }
    
    // MARK: - Text
    
    private enum Text {
        static let saved: String = "saved"
        static let deleted: String = "deleted"
        static let nsPredicateFormater: String = "name == %@"
    }
    
    static let shared = DataPersistanceManager()
    
    // MARK: - Methods
    
    func saveCoinWith(model: CoinDetailModel, id: String, completion: @escaping(Result<Void, Error>) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let context = appDelegate.persistentContainer.viewContext
        let item = CoinItem(context: context)
        item.name = model.name
        item.large = model.image.large
        item.id = id
        
        do {
            try context.save()
            completion(.success(()))
            NotificationCenter.default.post(name: NSNotification.Name(Text.saved), object: nil)
        } catch {
            completion(.failure(DataBaseError.failedToSaveData))
        }
    }
    
    func fetchingCoinsFromDataBase(completion : @escaping (Result<[CoinItem],Error>) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let context = appDelegate.persistentContainer.viewContext
        let request: NSFetchRequest<CoinItem>
        request = CoinItem.fetchRequest()
        
        do {
            let coins = try context.fetch(request)
            completion(.success(coins))
        } catch {
            completion(.failure(DataBaseError.failedToFetchData))
        }
    }
    
    func deleteCoinItem(withName name: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<CoinItem> = CoinItem.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: Text.nsPredicateFormater, name)
        
        do {
            let results = try context.fetch(fetchRequest)
            if let coinItem = results.first {
                context.delete(coinItem)
                try context.save()
                NotificationCenter.default.post(name: NSNotification.Name(Text.deleted), object: nil)
            }
        } catch {
        }
    }
    
    func isCoinSaved(withName name: String, completion: @escaping (Bool) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            completion(false)
            return
        }
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<CoinItem> = CoinItem.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: Text.nsPredicateFormater, name)
        
        do {
            let results = try context.fetch(fetchRequest)
            completion(!results.isEmpty)
        } catch {
            completion(false)
        }
    }
}

