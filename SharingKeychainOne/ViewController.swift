//
//  ViewController.swift
//  SharingKeychainOne
//
//  Created by Evgenii on 19/12/2015.
//  Copyright © 2015 Evgenii Neumerzhitckii. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    
   
  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    
    
    let itemKey = "My key"
    let itemValue = "My secretive bee 🐝"
    let keychainAccessGroupName = "login-group.com.my-app-bundle-id"
    
    // Delete existing key
    // ----------------

    let queryDelete: [String: AnyObject] = [
      kSecClass as String: kSecClassGenericPassword,
      kSecAttrAccount as String: itemKey,
      kSecAttrAccessGroup as String: keychainAccessGroupName
    ]

    let resultCodeDelete = SecItemDelete(queryDelete as CFDictionaryRef)
    
    if resultCodeDelete != noErr {
      print("Error deleting from Keychain: \(resultCodeDelete)")
    }
    
    // Save a shared Keychain item
    // ----------------
    
    guard let valueData = itemValue.dataUsingEncoding(NSUTF8StringEncoding) else {
      print("Error saving text to Keychain")
      return
    }
    
    let queryAdd: [String: AnyObject] = [
      kSecClass as String: kSecClassGenericPassword,
      kSecAttrAccount as String: itemKey,
      kSecValueData as String: valueData,
      kSecAttrAccessible as String: kSecAttrAccessibleWhenUnlocked,
      kSecAttrAccessGroup as String: keychainAccessGroupName
    ]
    
    let resultCode = SecItemAdd(queryAdd as CFDictionaryRef, nil)
    
    if resultCode != noErr {
      print("Error saving to Keychain: \(resultCode)")
    }
    
    // Load a shared Keychain item
    // ----------------

    let queryLoad: [String: AnyObject] = [
      kSecClass as String: kSecClassGenericPassword,
      kSecAttrAccount as String: itemKey,
      kSecReturnData as String: kCFBooleanTrue,
      kSecMatchLimit as String: kSecMatchLimitOne,
      kSecAttrAccessGroup as String: keychainAccessGroupName
    ]

    var result: AnyObject?

    let resultCodeLoad = withUnsafeMutablePointer(&result) {
      SecItemCopyMatching(queryLoad, UnsafeMutablePointer($0))
    }

    if resultCodeLoad == noErr {
      if let result = result as? NSData,
        keyValue = NSString(data: result,
          encoding: NSUTF8StringEncoding) as? String {

        print(keyValue)
      }
    } else {
      print("Error loading from Keychain: \(resultCodeLoad)")
    }
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }


}

