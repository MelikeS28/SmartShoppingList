//
//  DetailsViewModel.swift
//  SmartShoppingList
//
//  Created by Melike on 2.07.2026.
//

import Foundation
import UIKit
import CoreData

protocol DetailsViewModelDelegate: AnyObject {
    func didSaveNewProduct()
}

class DetailsViewModel {
    
    var chosenShoppingItem: Shopping?
    
    weak var delegate: DetailsViewModelDelegate?
    
    var isViewingMode: Bool {
        return chosenShoppingItem != nil
    }
    
    func saveProduct(name:  String?, price: String?, size: String?, image: UIImage?) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let newShoppingItem = NSEntityDescription.insertNewObject(forEntityName: "Shopping", into: context)
        
        if let priceString = price, let priceInt = Int16(priceString) {
            newShoppingItem.setValue(priceInt, forKey: "price")
        }
        if let nameString = name {
            newShoppingItem.setValue(nameString, forKey: "name")
        }
        if let sizeString = size {
            newShoppingItem.setValue(sizeString, forKey: "size")
        }
        if let currentImage = image {
            if let imageData = currentImage.jpegData(compressionQuality: 0.5) {
                newShoppingItem.setValue(imageData, forKey: "image")
            }
        }
        
        do {
            try context.save()
            print("Product successfully saved to Core Data!")
            delegate?.didSaveNewProduct()
        } catch {
            print("Core Data saving error: \(error.localizedDescription)")
        }
    }

}
