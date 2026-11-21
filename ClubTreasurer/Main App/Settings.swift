    //
    //  Settings.swift
    //  ImportUsebio
    //
    //  Created by Marc Shearer on 29/04/2019.
    //  Copyright © 2019 Marc Shearer. All rights reserved.
    //

    import SwiftUI

    @Observable class Settings {
        
        var maxNationalIdNumber: Int!
        var goodStatus: String!
        var notPaidPaymentStatus: String!
        var otherNBORank: Int!
        var ignorePaymentFrom: Int!
        var ignorePaymentTo: Int!
        var maxPoints: Float!
        var largestFieldSize: Int!
        var largestPlayerCount: Int!
        var defaultWorksheetZoom: Float!
        var linesPerFormattedPage: Int!
        var userDownloadData: String!
        var userDownloadFrozenData: String!
        var userDownloadMinRow: Int!
        var userDownloadMaxRow: Int!
        var userDownloadNationalIdColumn: String!
        var userDownloadOtherNamesColumn:String!
        var userDownloadFirstNameColumn: String!
        var userDownloadRankColumn: String!
        var userDownloadEmailColumn: String!
        var userDownloadOtherUnionColumn: String!
        var userDownloadHomeClubColumn: String!
        var userDownloadStatusColumn: String!
        var userDownloadPaymentStatusColumn: String!

        static public var current =  Settings(load: true)
        
        init(load: Bool = false) {
            if load {
                self.load()
            }
        }
            
        public func copy() -> Settings {
            let copy = Settings()
            copy.copy(from: self)
            return copy
        }
        
        public func copy(from: Settings) {
            self.maxNationalIdNumber = from.maxNationalIdNumber
            self.goodStatus = from.goodStatus
            self.notPaidPaymentStatus = from.notPaidPaymentStatus
            self.ignorePaymentFrom = from.ignorePaymentFrom
            self.ignorePaymentTo = from.ignorePaymentTo
            self.otherNBORank = from.otherNBORank
            self.maxPoints = from.maxPoints
            self.largestFieldSize = from.largestFieldSize
            self.largestPlayerCount = from.largestPlayerCount
            self.defaultWorksheetZoom = from.defaultWorksheetZoom
            self.linesPerFormattedPage = from.linesPerFormattedPage
            self.userDownloadData = from.userDownloadData
            self.userDownloadFrozenData = from.userDownloadFrozenData
            self.userDownloadMinRow = from.userDownloadMinRow
            self.userDownloadMaxRow = from.userDownloadMaxRow
            self.userDownloadNationalIdColumn = from.userDownloadNationalIdColumn
            self.userDownloadOtherNamesColumn = from.userDownloadOtherNamesColumn
            self.userDownloadFirstNameColumn = from.userDownloadFirstNameColumn
            self.userDownloadRankColumn = from.userDownloadRankColumn
            self.userDownloadEmailColumn = from.userDownloadEmailColumn
            self.userDownloadOtherUnionColumn = from.userDownloadOtherUnionColumn
            self.userDownloadHomeClubColumn = from.userDownloadHomeClubColumn
            self.userDownloadStatusColumn = from.userDownloadStatusColumn
            self.userDownloadPaymentStatusColumn = from.userDownloadPaymentStatusColumn
        }
        
        public func load() {
            self.maxNationalIdNumber = UserDefault.settingMaxNationalIdNumber.int
            self.goodStatus = UserDefault.settingGoodStatus.string
            self.notPaidPaymentStatus = UserDefault.settingnotPaidPaymentStatus.string
            self.otherNBORank = UserDefault.settingNonSBURank.int
            self.ignorePaymentFrom = UserDefault.settingIgnorePaymentFrom.int
            self.ignorePaymentTo = UserDefault.settingIgnorePaymentTo.int
            self.maxPoints = UserDefault.settingMaxPoints.float
            self.largestFieldSize = UserDefault.settingLargestFieldSize.int
            self.largestPlayerCount = UserDefault.settingLargestPlayerCount.int
            self.defaultWorksheetZoom = UserDefault.settingDefaultWorksheetZoom.float
            self.linesPerFormattedPage = UserDefault.settingLinesPerFormattedPage.int
            self.userDownloadData = UserDefault.settingUserDownloadData.string
            self.userDownloadFrozenData = UserDefault.settingUserDownloadFrozenData.string
            self.userDownloadMinRow = UserDefault.settingUserDownloadMinRow.int
            self.userDownloadMaxRow = UserDefault.settingUserDownloadMaxRow.int
            self.userDownloadNationalIdColumn = UserDefault.settingUserDownloadNationalIdColumn.string
            self.userDownloadOtherNamesColumn = UserDefault.settingUserDownloadOtherNamesColumn.string
            self.userDownloadFirstNameColumn = UserDefault.settingUserDownloadFirtNameColumn.string
            self.userDownloadRankColumn = UserDefault.settingUserDownloadRankColumn.string
            self.userDownloadEmailColumn = UserDefault.settingUserDownloadEmailColumn.string
            self.userDownloadOtherUnionColumn = UserDefault.settingUserDownloadOtherUnionColumn.string
            self.userDownloadHomeClubColumn = UserDefault.settingUserDownloadHomeClubColumn.string
            self.userDownloadStatusColumn = UserDefault.settingUserDownloadStatusColumn.string
            self.userDownloadPaymentStatusColumn = UserDefault.settingUserDownloadPaymentStatusColumn.string
        }
        
        public func save() {
            UserDefault.settingMaxNationalIdNumber.set(self.maxNationalIdNumber)
            UserDefault.settingGoodStatus.set(self.goodStatus)
            UserDefault.settingnotPaidPaymentStatus.set(self.notPaidPaymentStatus)
            UserDefault.settingNonSBURank.set(self.otherNBORank)
            UserDefault.settingIgnorePaymentFrom.set(self.ignorePaymentFrom)
            UserDefault.settingIgnorePaymentTo.set(self.ignorePaymentTo)
            UserDefault.settingMaxPoints.set(self.maxPoints)
            UserDefault.settingLargestFieldSize.set(self.largestFieldSize)
            UserDefault.settingLargestPlayerCount.set(self.largestPlayerCount)
            UserDefault.settingDefaultWorksheetZoom.set(self.defaultWorksheetZoom)
            UserDefault.settingLinesPerFormattedPage.set(self.linesPerFormattedPage)
            UserDefault.settingUserDownloadFrozenData.set(self.userDownloadFrozenData)
            UserDefault.settingUserDownloadMinRow.set(self.userDownloadMinRow)
            UserDefault.settingUserDownloadMaxRow.set(self.userDownloadMaxRow)
            UserDefault.settingUserDownloadNationalIdColumn.set(self.userDownloadNationalIdColumn)
            UserDefault.settingUserDownloadOtherNamesColumn.set(self.userDownloadOtherNamesColumn)
            UserDefault.settingUserDownloadFirtNameColumn.set(self.userDownloadFirstNameColumn)
            UserDefault.settingUserDownloadRankColumn.set(self.userDownloadRankColumn)
            UserDefault.settingUserDownloadEmailColumn.set(self.userDownloadEmailColumn)
            UserDefault.settingUserDownloadOtherUnionColumn.set(self.userDownloadOtherUnionColumn)
            UserDefault.settingUserDownloadHomeClubColumn.set(self.userDownloadHomeClubColumn)
            UserDefault.settingUserDownloadStatusColumn.set(self.userDownloadStatusColumn)
            UserDefault.settingUserDownloadPaymentStatusColumn.set(self.userDownloadPaymentStatusColumn)
        }
    }
