//
//  MyApp.swift
//  ImportUsebio
//
//  Created by Marc Shearer on 07/02/2023.
//

import Foundation

import SwiftUI

class MyApp {
    
    
    enum Target {
        case iOS
        case macOS
    }
   
    enum Format {
        case computer
        case tablet
        case phone
    }

    enum Database: String {
        case development = "Development"
        case production = "Production"
        case unknown = ""
        
        public var name: String {
            return self.rawValue
        }
    }
    
    static let objectModel = Model(GeneratedModels.allEntities)
    
    static let shared = MyApp()
    
    static let defaults = UserDefaults(suiteName: appGroup)!
    
    /// Database to use - This  **MUST MUST MUST** match icloud entitlement
    static let expectedDatabase: Database = .production
    
    public static var database: Database = .unknown
    public static var undoManager = UndoManager()
    public static var masterDataLoaded = false
    
    #if targetEnvironment(macCatalyst)
    public static let target: Target = .macOS
    #else
    public static let target: Target = .iOS
    #endif

    public static var format: Format = .computer
 
    public func start() {
        loadMasterData()
        Themes.selectTheme(.standard)
        self.registerDefaults()
        #if !widget
        Version.current.load()
        // Remove comment (CAREFULLY) if you want to clear the iCloud DB
        // DatabaseUtilities.initialiseAllCloud() {
            // Remove (CAREFULLY) if you want to clear the Core Data DB
            //DatabaseUtilities.initialiseAllCoreData()
            self.setupDatabase()
            // self.setupPreviewData()
        //}
              
        #if canImport(UIKit)
        UITextView.appearance().backgroundColor = .clear
        #endif
        #endif
    }
    
    private func setupDatabase() {
        
        // Get saved database
        MyApp.database = Database(rawValue: UserDefault.database.string) ?? .unknown
        
        #if !widget
            // Check which database we are connected to
        #endif
    }
     
    #if !widget
    private func setupPreviewData() {

    }
    #endif
    
    private func registerDefaults() {
        var initial: [String:Any] = [:]
        for value in UserDefault.allCases {
            initial[value.name] = value.defaultValue ?? ""
        }
        MyApp.defaults.register(defaults: initial)
    }
    
    public func loadMasterData() {
        /// **Builds in-memory mirror of data**
        /// with pointers to managed objects
        /// Note that this infers that there will only ever be 1 instance of the app accessing the database
        
        for entity in MyApp.objectModel.entities.sorted(by: {$0.loadSequence < $1.loadSequence}) {
            _ = entity.viewModelType.loadData(createDefaultData: true)
        }
        
        MyApp.masterDataLoaded = true
    }
}

enum BridgeScoreError: Error {
    case invalidData
}
