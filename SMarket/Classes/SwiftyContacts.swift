//
// SwiftyContacts
//
// Copyright (c) 2017 Satish Babariya <satish.babariya@gmail.com>
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
//to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import Foundation
import Contacts

import UIKit

class SwiftyContacts {
    
    private init() {}
    
    private static let swiftyContacts:SwiftyContacts = {
        let swiftyContacts = SwiftyContacts()
        return swiftyContacts
    }()
    
    static var shared:SwiftyContacts {
        return swiftyContacts
    }
    
    
    // PRAGMA MARK: - Contacts Authorization -
    
    /// Requests access to the user's contacts
    ///
    /// - Parameter requestGranted: Result as Bool
    public func requestAccess(_ requestGranted: @escaping (Bool) -> ()) {
        CNContactStore().requestAccess(for: .contacts) { grandted, _ in
            requestGranted(grandted)
        }
    }
    
    /// - Parameter requestGranted: Result as Bool
    public func requestAccess(_ require :Bool, requestGranted: @escaping (Bool) -> ()) {
        
        switch CNContactStore.authorizationStatus(for: .contacts) {
            
        case .authorized:
            requestGranted(true)
            
        case .restricted, .denied:
            if require {
                showSettingsAlert(requestGranted)
                
            }
            
        case  .notDetermined:
            
            requestAccess { (granted) in
                if granted {
                    requestGranted(true)
                } else if require {
                    DispatchQueue.main.async {
                        self.showSettingsAlert(requestGranted)
                    }
                }
            }
        }
    }
    
    private func showSettingsAlert(_ completionHandler: @escaping (_ accessGranted: Bool) -> Void) {
        
        CTopMostViewController?.presentAlertViewWithTwoButtons(alertTitle: "This app requires access to Contacts to proceed. Would you like to open settings and grant permission to contacts?", alertMessage: "", btnOneTitle: CBtnOpenSettings, btnOneTapped: { (action) in
            
            if let url = URL(string: UIApplicationOpenSettingsURLString) {
                // If general location settings are enabled then open location settings for the app
                UIApplication.shared.open(url, options: [:], completionHandler: { (success) in
                    
                })
            }
        }, btnTwoTitle: CBtnCancel, btnTwoTapped: { (action) in
            completionHandler(false)
        })
        
    }
    
    
    /// Returns the current authorization status to access the contact data.
    ///
    /// - Parameter requestStatus: Result as CNAuthorizationStatus
    public func authorizationStatus(_ requestStatus: @escaping (CNAuthorizationStatus) -> ()) {
        requestStatus(CNContactStore.authorizationStatus(for: .contacts))
    }
    
    // PRAGMA MARK: - Fetch Contacts -
    
    /// Result Enum
    ///
    /// - Success: Returns Array of Contacts
    /// - Error: Returns error
    public enum ContactsFetchResult {
        case Success(response: [CNContact])
        case Error(error: Error)
    }
    
    /// Fetching Contacts from phone
    ///
    /// - Parameter completionHandler: Returns Either [CNContact] or Error.
    public func fetchContacts(completionHandler: @escaping (_ result: ContactsFetchResult) -> ()) {
        
        let contactStore: CNContactStore = CNContactStore()
        var contacts: [CNContact] = [CNContact]()
        let fetchRequest: CNContactFetchRequest = CNContactFetchRequest(keysToFetch: [CNContactVCardSerialization.descriptorForRequiredKeys()])
        do {
            try contactStore.enumerateContacts(with: fetchRequest, usingBlock: {
                contact, _ in
                contacts.append(contact) })
            completionHandler(ContactsFetchResult.Success(response: contacts))
        } catch {
            completionHandler(ContactsFetchResult.Error(error: error))
        }
    }
    
    /// Fetching Contacts from phone with specific sort order.
    ///
    /// - Parameters:
    ///   - sortOrder: To return contacts in a specific sort order.
    ///   - completionHandler: Result Handler
    @available(iOS 10.0, *)
    public func fetchContacts(ContactsSortorder sortOrder: CNContactSortOrder, completionHandler: @escaping (_ result: ContactsFetchResult) -> ()) {
        
        let contactStore: CNContactStore = CNContactStore()
        var contacts: [CNContact] = [CNContact]()
        let fetchRequest: CNContactFetchRequest = CNContactFetchRequest(keysToFetch: [CNContactVCardSerialization.descriptorForRequiredKeys()])
        fetchRequest.unifyResults = true
        fetchRequest.sortOrder = sortOrder
        do {
            try contactStore.enumerateContacts(with: fetchRequest, usingBlock: {
                contact, _ in
                contacts.append(contact) })
            completionHandler(ContactsFetchResult.Success(response: contacts))
        } catch {
            completionHandler(ContactsFetchResult.Error(error: error))
        }
        
        
    }
    
    /// etching Contacts from phone with Grouped By Alphabet
    ///
    /// - Parameter completionHandler: It will return Dictonary of Alphabets with Their Sorted Respective Contacts.
    // @available(iOS 10.0, *)
    // public func fetchContactsGroupedByAlphabets( completionHandler : @escaping (_ result : [String: [CNContact]],Error?) -> ()){
    //
    //    let fetchRequest: CNContactFetchRequest = CNContactFetchRequest(keysToFetch: [CNContactVCardSerialization.descriptorForRequiredKeys()])
    //    var orderedContacts: [String: [CNContact]] = [String: [CNContact]]()
    //    CNContact.localizedString(forKey: CNLabelPhoneNumberiPhone)
    //    fetchRequest.mutableObjects = false
    //    fetchRequest.unifyResults = true
    //    fetchRequest.sortOrder = .givenName
    //    do {
    //        try CNContactStore().enumerateContacts(with: fetchRequest, usingBlock: { (contact, _) -> Void in
    //            // Ordering contacts based on alphabets in firstname
    //            var key: String = "#"
    //            // If ordering has to be happening via family name change it here.
    //            if let firstLetter = contact.givenName[0..<1], firstLetter.containsAlphabets() {
    //                key = firstLetter.uppercased()
    //            }
    //            var contacts = [CNContact]()
    //            if let segregatedContact = orderedContacts[key] {
    //                contacts = segregatedContact
    //            }
    //            contacts.append(contact)
    //            orderedContacts[key] = contacts
    //        })
    //    } catch {
    //        completionHandler(orderedContacts, error)
    //    }
    //    completionHandler(orderedContacts,nil)
    // }
    
    /// Fetching Contacts from phone
    /// - parameter completionHandler: Returns Either [CNContact] or Error.
    public func fetchContactsOnBackgroundThread(completionHandler: @escaping (_ result: ContactsFetchResult) -> ()) {
        
        DispatchQueue.global(qos: .userInitiated).async(execute: { () -> () in
            let fetchRequest: CNContactFetchRequest = CNContactFetchRequest(keysToFetch: [CNContactVCardSerialization.descriptorForRequiredKeys()])
            var contacts = [CNContact]()
            CNContact.localizedString(forKey: CNLabelPhoneNumberiPhone)
            if #available(iOS 10.0, *) {
                fetchRequest.mutableObjects = false
            } else {
                // Fallback on earlier versions
            }
            fetchRequest.unifyResults = true
            fetchRequest.sortOrder = .userDefault
            do {
                try CNContactStore().enumerateContacts(with: fetchRequest) { (contact, _) -> () in
                    contacts.append(contact)
                }
                DispatchQueue.main.async(execute: { () -> () in
                    completionHandler(ContactsFetchResult.Success(response: contacts))
                })
            } catch let error as NSError {
                completionHandler(ContactsFetchResult.Error(error: error))
            }
            
        })
        
    }
    
    // PRAGMA MARK: - Search Contacts -
    
    /// Search Contact from phone
    /// - parameter string: Search String.
    /// - parameter completionHandler: Returns Either [CNContact] or Error.
    public func searchContact(SearchString string: String, completionHandler: @escaping (_ result: ContactsFetchResult) -> ()) {
        
        let contactStore: CNContactStore = CNContactStore()
        var contacts: [CNContact] = [CNContact]()
        let predicate: NSPredicate = CNContact.predicateForContacts(matchingName: string)
        do {
            contacts = try contactStore.unifiedContacts(matching: predicate, keysToFetch: [CNContactVCardSerialization.descriptorForRequiredKeys()])
            completionHandler(ContactsFetchResult.Success(response: contacts))
        } catch {
            completionHandler(ContactsFetchResult.Error(error: error))
        }
    }
    
    public enum ContactFetchResult {
        case Success(response: CNContact)
        case Error(error: Error)
    }
    
    // Get CNContact From Identifier
    /// Get CNContact From Identifier
    /// - parameter identifier: A value that uniquely identifies a contact on the device.
    /// - parameter completionHandler: Returns Either CNContact or Error.
    public func getContactFromID(Identifires identifiers: [String], completionHandler: @escaping (_ result: ContactsFetchResult) -> ()) {
        
        let contactStore: CNContactStore = CNContactStore()
        var contacts: [CNContact] = [CNContact]()
        let predicate: NSPredicate = CNContact.predicateForContacts(withIdentifiers: identifiers)
        do {
            contacts = try contactStore.unifiedContacts(matching: predicate, keysToFetch: [CNContactVCardSerialization.descriptorForRequiredKeys()])
            completionHandler(ContactsFetchResult.Success(response: contacts))
        } catch {
            completionHandler(ContactsFetchResult.Error(error: error))
        }
    }
    
    // PRAGMA MARK: - Contact Operations
    
    /// Result enum
    ///
    /// - Success: Returns Bool
    /// - Error: Returns error
    public enum ContactOperationResult {
        case Success(response: Bool)
        case Error(error: Error)
    }
    
    
    
    // Update Contact
    /// Updates an existing contact in the contact store.
    /// - parameter mutContact: A mutable value object for the contact properties, such as the first name and the phone number of a contact.
    /// - parameter completionHandler: Returns Either CNContact or Error.
    public func updateContact(Contact mutContact: CNMutableContact, completionHandler: @escaping (_ result: ContactOperationResult) -> ()) {
        let store: CNContactStore = CNContactStore()
        let request: CNSaveRequest = CNSaveRequest()
        request.update(mutContact)
        do {
            try store.execute(request)
            completionHandler(ContactOperationResult.Success(response: true))
        } catch {
            completionHandler(ContactOperationResult.Error(error: error))
        }
    }
    
    // Delete Contact
    /// Deletes a contact from the contact store.
    /// - parameter mutContact: A mutable value object for the contact properties, such as the first name and the phone number of a contact.
    /// - parameter completionHandler: Returns Either CNContact or Error.
    public func deleteContact(Contact mutContact: CNMutableContact, completionHandler: @escaping (_ result: ContactOperationResult) -> ()) {
        let store: CNContactStore = CNContactStore()
        let request: CNSaveRequest = CNSaveRequest()
        request.delete(mutContact)
        do {
            try store.execute(request)
            completionHandler(ContactOperationResult.Success(response: true))
        } catch {
            completionHandler(ContactOperationResult.Error(error: error))
        }
    }
    
    
    // PRAGMA MARK: - Groups Methods -
    
    /// Result enum
    ///
    /// - Success: Returns Array of CNGroup
    /// - Error: Returns error
    public enum GroupsFetchResult {
        case Success(response: [CNGroup])
        case Error(error: Error)
    }
    
    /// Fetch list of Groups from the contact store.
    /// - parameter completionHandler: Returns Either [CNGroup] or Error.
    public func fetchGroups(completionHandler: @escaping (_ result: GroupsFetchResult) -> ()) {
        let store: CNContactStore = CNContactStore()
        do {
            let groups: [CNGroup] = try store.groups(matching: nil)
            completionHandler(GroupsFetchResult.Success(response: groups))
        } catch {
            completionHandler(GroupsFetchResult.Error(error: error))
        }
    }
    
    
    
    /// Fetch all contacts in a group.
    /// - parameter group: The group.
    /// - parameter completionHandler: Returns Either [CNContact] or Error.
    public func fetchContactsInGorup(Group group: CNGroup, completionHandler: @escaping (_ result: ContactsFetchResult) -> ()) {
        
        let contactStore: CNContactStore = CNContactStore()
        var contacts: [CNContact] = [CNContact]()
        do {
            let predicate: NSPredicate = CNContact.predicateForContactsInGroup(withIdentifier: group.name)
            let keysToFetch: [String] = [CNContactGivenNameKey]
            contacts = try contactStore.unifiedContacts(matching: predicate, keysToFetch: keysToFetch as [CNKeyDescriptor])
            completionHandler(ContactsFetchResult.Success(response: contacts))
        } catch {
            completionHandler(ContactsFetchResult.Error(error: error))
        }
    }
    
    /// Fetch all contacts in a group.
    /// - parameter group: The group.
    /// - parameter completionHandler: Returns Either [CNContact] or Error.
    public func fetchContactsInGorup2(Group group: CNGroup, completionHandler: @escaping (_ result: ContactsFetchResult) -> ()) {
        
        let contactStore: CNContactStore = CNContactStore()
        let contacts: [CNContact] = [CNContact]()
        do {
            var predicate: NSPredicate!
            let allGroups: [CNGroup] = try contactStore.groups(matching: nil)
            for item in allGroups {
                if item.name == group.name {
                    predicate = CNContact.predicateForContactsInGroup(withIdentifier: group.identifier)
                }
            }
            let keysToFetch: [String] = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactOrganizationNameKey, CNContactPhoneNumbersKey, CNContactUrlAddressesKey, CNContactEmailAddressesKey, CNContactPostalAddressesKey, CNContactNoteKey, CNContactImageDataKey]
            if predicate != nil {
                var contacts: [CNContact] = try contactStore.unifiedContacts(matching: predicate, keysToFetch: keysToFetch as [CNKeyDescriptor])
                for contact in contacts {
                    contacts.append(contact)
                }
            }
            completionHandler(ContactsFetchResult.Success(response: contacts))
        } catch {
            completionHandler(ContactsFetchResult.Error(error: error))
        }
    }
    
    
    
    
    /// Check if iOS Device supports sms
    /// - parameter completionHandler: Returns Bool.
    public func isCapableToSMS(completionHandler: @escaping (_ result: Bool) -> ()) {
        if UIApplication.shared.canOpenURL(NSURL(string: "sms:")! as URL) {
            completionHandler(true)
        } else {
            completionHandler(false)
        }
        
    }
    
    /// Convert CNPhoneNumber To digits
    /// - parameter CNPhoneNumber: Phone number.
    public func CNPhoneNumberToString(_ CNPhoneNumber: CNPhoneNumber?) -> String? {
        if let result: String = CNPhoneNumber?.value(forKey: "digits") as? String {
            return result
        }
        return nil
    }
    
    /// Make call to given number.
    /// - parameter CNPhoneNumber: Phone number.
    public func makeCall(CNPhoneNumber: CNPhoneNumber) {
        if let phoneNumber: String = CNPhoneNumber.value(forKey: "digits") as? String {
            guard let url: URL = URL(string: "tel://" + "\(phoneNumber)") else {
                print("Error in Making Call")
                return
            }
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                // Fallback on earlier versions
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    // PRAGMA MARK: - Helper Methods -
    func convertContactListToArray(_ contactList : [Any]?) -> [Any]? {
            
            var arrContactList = [[String : Any]]()
            
            if let contactList = contactList  {
                
                for contact in contactList {
                    
                    if let item = contact as? CNContact {
                        var dict = [String : Any]()
                        
                        var name = String(item.givenName)
                        let familyName = String(item.familyName)
                        var index = name.prefix(1)
                        
                        if  let  number = SwiftyContacts.shared.CNPhoneNumberToString(item.phoneNumbers.first?.value) {
                            if name.isBlank {
    //                            name = number
    //                            index = "#"
                                
                                continue
                            }else if !familyName.isBlank {
                                name = name + " " + familyName
                            }else if number.isValidPhoneNo == false {
                                continue
                            }
                            dict["index"] = index
                            dict["name"] = name
                            dict["number"] = number
                            dict["id"] = item.identifier
                            
                            arrContactList.append(dict)
                        }
                    }
                }
            }
            
                              
            return arrContactList
        }
}
