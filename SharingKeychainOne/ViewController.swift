//
//  ViewController.swift
//  SharingKeychainOne
//
//  Created by Evgenii on 19/12/2015.
//  Copyright © 2015 Evgenii Neumerzhitckii. All rights reserved.
//

import UIKit
import Security

class ViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    
    let itemKey = "My item key"
    let keychainAccessGroupName = "login-group.com.my-app-bundle-id"
    
    // Delete existing key
    // ----------------

    let queryDelete: [String: AnyObject] = [
      kSecClass as String: kSecClassGenericPassword,
      kSecAttrAccount as String: itemKey,
      kSecAttrAccessGroup as String: keychainAccessGroupName
    ]
    
    let resultCodeDelete = SecItemDelete(queryDelete as CFDictionaryRef)
    if resultCodeDelete != noErr { print("Error deleting from Keychain: \(resultCodeDelete)") }

    // Save a shared Keychain item
    // ----------------
    
    let queryAdd: [String: AnyObject] = [
      kSecAttrAccessible as String: kSecAttrAccessible,
      kSecClass as String: kSecClassGenericPassword,
      kSecAttrAccount as String: itemKey,
      kSecValueData as String: "My secret data 🐝",
      kSecAttrAccessGroup as String: keychainAccessGroupName
    ]
    
    let resultCode = SecItemAdd(queryAdd as CFDictionaryRef, nil)
    if resultCode != noErr { print("Error saving to Keychain: \(resultCode)") }
    
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
        keyValue = NSString(data: result, encoding: NSUTF8StringEncoding) as? String {
          
        print(keyValue)
      }
    } else { print("Error loading from Keychain: \(resultCodeLoad)") }
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }


}

