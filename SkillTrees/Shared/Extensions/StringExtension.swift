//
//  StringExtension.swift
//  SkillTrees
//
//  Created by Lucas Pennice on 13/08/2024.
//

import Foundation
import UIKit

extension String {
   func sizeOfString() -> CGSize {
       let fontAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .regular)]
        let size = self.size(withAttributes: fontAttributes)
        return size
    }
}
