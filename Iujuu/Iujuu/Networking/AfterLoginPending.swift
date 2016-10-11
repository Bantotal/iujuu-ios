//
//  AfterLoginPending.swift
//  Iujuu
//
//  Created by Diego Ernst on 10/10/16.
//  Copyright © 2016 'Xmartlabs SRL'. All rights reserved.
//

import Foundation
import Opera
import RxSwift

class AfterLoginPending {

    static let shared = AfterLoginPending()
    private init() { }
    private var pendings = [PendingType]()

    typealias PendingType = () -> Observable<Void>

    func add(pending: @escaping PendingType) {
        pendings.append(pending)
    }

    func execute() -> Observable<Void> {
        guard !pendings.isEmpty else {
            return Observable.just(())
        }
        return Observable.from(pendings.map { $0() })
            .merge()
            .toArray()
            .flatMap { _ in Observable<Void>.just(()) }
            .do(
                onDispose: { _ in
                    AfterLoginPending.shared.clear()
                }
            )
    }

    func clear() {
        pendings.removeAll()
    }

}
