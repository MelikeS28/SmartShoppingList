//
//  viewModel.swift
//  SmartShoppingList
//
//  Created by Melike on 2.07.2026.
//

import Foundation
import UIKit
import CoreData

class ViewModel {
    
    var shoppingItems: [Shopping] = []
    
    func fetchData() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Shopping")
        
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            let results = try context.fetch(fetchRequest)
            self.shoppingItems.removeAll()
            
            for result in results as! [NSManagedObject] {
                if let item = result as? Shopping {
                    self.shoppingItems.append(item)
                }
            }
            print("Data successfully fetched! Total items: \(shoppingItems.count)")
        } catch {
            print("Fetch error: \(error.localizedDescription)")
        }
    }
}

extension ViewModel: DetailsViewModelDelegate {
    func didSaveNewProduct() {
        fetchData()
    }
}
