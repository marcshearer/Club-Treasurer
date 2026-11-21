//
//  Master Data.swift
//  ImportUsebio
//
//  Created by Marc Shearer on 11/08/2025.
//

import Foundation
import CoreData
import Combine

@Observable class MasterData {
    
    public static let shared = MasterData()

    private(set) var bankAccounts = WrappedArray()
    private(set) var statements = WrappedArray()
    private(set) var statementLines = WrappedArray()
    private(set) var expenseCodes = WrappedArray()

    public func load() {
        
        /// **Builds in-memory mirror of data**
        /// with pointers to managed objects
        /// Note that this infers that there will only ever be 1 instance of the app accessing the database
        
        for entity in MyApp.objectModel.entities.sorted(by: {$0.loadSequence < $1.loadSequence}) {
            _ = entity.viewModelType.loadData(createDefaultData: true)
        }
        
        MyApp.masterDataLoaded = true
    }
}
