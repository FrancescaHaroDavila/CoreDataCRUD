//
//   CustomTextField.swift
//  CoreDataCRUD
//
//  Created by Francesca Valeria Haro Dávila on 1/10/19.
//  Copyright © 2019 Belatrix. All rights reserved.
//

import UIKit

extension UITextField {
  
  open override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
    return (action != #selector(UIResponderStandardEditActions.paste(_:)))
  }
}
