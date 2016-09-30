import Foundation

/**
 
 A Keychain wrapper for iOS written in Swift for reading/writing text values. Supports keychain access groups that can be used for sharing keychain items between apps on the same device.
 
 License: MIT
 Source: http://evgenii.com/blog/sharing-keychain-in-ios/
 
*/
open class KeychainTextWrapper {

  /// Supply an optional Keychain access group to access shared Keychain items.
  open var accessGroup: String?;
  
  /**
   
   Adds the text value in the keychain.
   
   - parameter itemKey: Key under which the text value is stored in the keychain.
   - parameter itemValue: Text string to be written to the keychain.
   - returns: True if the text was successfully written to the keychain.
   
   */
  @discardableResult
  open func add(_ itemKey: String, itemValue: String) -> Bool {
    guard let valueData = itemValue.data(using: String.Encoding.utf8) else {
      return false
    }
    
    // Delete the item before adding, otherwise there will be multiple items with the same name
    delete(itemKey)
    
    var queryAdd: [String: AnyObject] = [
      kSecClass as String: kSecClassGenericPassword,
      kSecAttrAccount as String: itemKey as AnyObject,
      kSecValueData as String: valueData as AnyObject,
      kSecAttrAccessible as String: kSecAttrAccessibleWhenUnlocked
    ]
    
    if let accessGroup = accessGroup {
      queryAdd[kSecAttrAccessGroup as String] = accessGroup as AnyObject?
    }
    
    let resultCode = SecItemAdd(queryAdd as CFDictionary, nil)
    
    if resultCode != noErr { return false }
    
    return true
  }
  
  /**
   
   Returns a text item from the Keychain.
   
   - parameter itemKey: The key that is used to read the keychain item.
   - returns: The text value from the keychain. Returns nil if unable to read the item.
   
  */
  open func find(_ itemKey: String) -> String? {
    var queryLoad: [String: AnyObject] = [
      kSecClass as String: kSecClassGenericPassword,
      kSecAttrAccount as String: itemKey as AnyObject,
      kSecReturnData as String: kCFBooleanTrue,
      kSecMatchLimit as String: kSecMatchLimitOne
    ]
    
    if let accessGroup = accessGroup {
      queryLoad[kSecAttrAccessGroup as String] = accessGroup as AnyObject?
    }
    
    var result: AnyObject?
    
    let resultCodeLoad = withUnsafeMutablePointer(to: &result) {
      SecItemCopyMatching(queryLoad as CFDictionary, UnsafeMutablePointer($0))
    }
    
    if resultCodeLoad == noErr {
      if let result = result as? Data,
        let keyValue = NSString(data: result,
                            encoding: String.Encoding.utf8.rawValue) as? String {
        
        return keyValue
      }
    }
    
    return nil
  }
  
  /**
   
   Deletes the single keychain item specified by the key.
   
   - parameter itemKey: The key that is used to delete the keychain item.
   - returns: True if the item was successfully deleted.
   
  */
  @discardableResult
  open func delete(_ itemKey: String) -> Bool {
    var queryDelete: [String: AnyObject] = [
      kSecClass as String: kSecClassGenericPassword,
      kSecAttrAccount as String: itemKey as AnyObject
    ]
    
    if let accessGroup = accessGroup {
      queryDelete[kSecAttrAccessGroup as String] = accessGroup as AnyObject?
    }
    
    let resultCodeDelete = SecItemDelete(queryDelete as CFDictionary)
    
    if resultCodeDelete != noErr { return false }
    
    return true
  }
}


