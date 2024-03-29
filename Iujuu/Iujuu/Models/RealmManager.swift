//
//  RealmManager.swift
//  Iujuu
//
//  Created by Xmartlabs SRL ( https://xmartlabs.com )
//  Copyright © 2016 'Xmartlabs SRL'. All rights reserved.
//

import Foundation
import UIKit
import Crashlytics
import RealmSwift

class RealmManager: AnyObject {

    static let shared = RealmManager()

    fileprivate(set) var defaultRealm: Realm!

    fileprivate var config = Realm.Configuration()

    fileprivate init() {
//        config.schemaVersion = 1
//        config.migrationBlock = { migration, oldSchemaVersion in
//             Perform migrations when needed
//            if oldSchemaVersion == 1 {
//                 ...
//            }
//        }

        do {
            defaultRealm = try Realm(configuration: config)
            DEBUGLog("Realm DB path: \(config.fileURL)")
        } catch {
            let nserror = error as NSError
            Crashlytics.sharedInstance().recordError(nserror)
        }
    }

    func eraseAll() {
        do {
            let realm = try createRealm()
            try realm.write {
                realm.deleteAll()
            }
        } catch {
            let nserror = error as NSError
            Crashlytics.sharedInstance().recordError(nserror)
        }
    }

    func createRealm() throws -> Realm {
        return try Realm(configuration: config)
    }

}

extension Object {

    fileprivate func realmInst() -> Realm {
        return self.realm ?? RealmManager.shared.defaultRealm
    }

    /** Must be called from main thread */
    func save(_ update: Bool = true) throws {
        let realm = self.realmInst()
        try realm.write() {
            realm.add(self, update: update)
        }
    }

    /** Must be called from main thread */
    static func save<T: Object>(_ objects: [T], update: Bool = true, removeOld: Bool = false) throws where T: IUObject {
        guard let realm = objects.first?.realmInst() ?? (try? RealmManager.shared.createRealm()) else { return }
        try realm.write() {
            if removeOld {
                let old = realm.objects(self)
                let deleted = old.filter { del in !objects.contains(where: { obj in obj.id == (del as? T)!.id }) }
                realm.delete(deleted)
            }
            objects.forEach() { realm.add($0, update: update) }
        }
    }

}
