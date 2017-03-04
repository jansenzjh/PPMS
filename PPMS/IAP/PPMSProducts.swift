//
//  PPMSProducts.swift
//  PPMS
//
//  Created by Jansen on 3/3/17.
//  Copyright © 2017 Jansen. All rights reserved.
//

import Foundation

public struct PPMSProducts {
    
    public static let AdRemoveProduct = "com.jzsoft.ppms.adRemove"
    
    fileprivate static let productIdentifiers: Set<ProductIdentifier> = [PPMSProducts.AdRemoveProduct]
    
    public static let store = IAPHelper(productIds: PPMSProducts.productIdentifiers)
}

func resourceNameForProductIdentifier(_ productIdentifier: String) -> String? {
    return productIdentifier.components(separatedBy: ".").last
}
