//
//  PurchasesDelegateHandler.swift
//  SkillTrees
//
//  Created by Lucas Pennice on 30/08/2024.
//

import Foundation
import RevenueCat

class PurchasesDelegateHandler : NSObject, ObservableObject {
    static let shared = PurchasesDelegateHandler()
}

extension PurchasesDelegateHandler : PurchasesDelegate {
    func purchases(_ purchases: Purchases, receivedUpdated customerInfo: CustomerInfo) {
            /// - handle any changes to the user's CustomerInfo
        }
}
