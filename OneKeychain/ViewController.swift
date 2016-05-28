//
//  ViewController.swift
//  OneKeychain
//
//  Created by Evgenii on 28/05/2016.
//  Copyright © 2016 Evgenii Neumerzhitckii. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

  @IBOutlet weak var label: UILabel!
  
  let keychainWrapper = KeychainTextWrapper()
  let keychainItemKey = "myKey"
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let appIdPrefix = NSBundle.mainBundle().objectForInfoDictionaryKey("AppIdentifierPrefix")
    print(appIdPrefix)
    
    // Use your App ID Prefix here instead of 'AB123CDE45'
    // To find out what it is: http://evgenii.com/blog/sharing-keychain-in-ios/
    keychainWrapper.accessGroup = "AB123CDE45.myKeychainGroup1"
  }

  @IBAction func didTapAddButton(sender: AnyObject) {
    keychainWrapper.add(keychainItemKey, itemValue: "myValue")
    showKeychainItem()
  }
  
  @IBAction func didTapGetButton(sender: AnyObject) {
    label.text = keychainWrapper.find(keychainItemKey)
    showKeychainItem()
  }
  
  private func showKeychainItem() {
    label.text = keychainWrapper.find(keychainItemKey)
  }
  
  @IBAction func didTapRemoveButton(sender: AnyObject) {
    keychainWrapper.delete(keychainItemKey)
    showKeychainItem()
  }

}

