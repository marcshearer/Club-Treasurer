//
//  Import BoS.swift
//  ClubTreasurer
//
//  Created by Marc Shearer on 22/11/2026.
//

import Foundation

enum BoSColumns: String {
    case transactionDate = "TRANSACTION DATE"
    case transactionType = "TRANSACTION TYPE"
    case sortCode = "SORT CODE"
    case accountNumber = "ACCOUNT NUMBER"
    case transactionDescription = "TRANSACTION DESCRIPTION"
    case debitAmount = "DEBIT AMOUNT"
    case creditAmount = "CREDIT AMOUNT"
    case balance = "BALANCE"
}

class ImportBankOfScotland {
    
    class func importStatementLines(_ csvData: String, statement: Statement) {
        var statementLines: [StatementLine] = []
        
        let lines = csvData.replacingOccurrences(of: "\r\n", with: "\n").components(separatedBy: "\n")
        if lines.count < 2 {
            MessageBox.shared.show("Invalid CSV data - insufficient lines")
        } else {
            // Check header line
            let headerLine = lines[0].components(separatedBy: ",").map{$0.replacing("\"", with: "")}
            if let transactionDateIndex = headerLine.firstIndex(where: {$0.uppercased() == BoSColumns.transactionDate.rawValue.uppercased()}),
               let transactionTypeIndex = headerLine.firstIndex(where: {$0.uppercased() == BoSColumns.transactionType.rawValue.uppercased()}),
               let sortCodeIndex = headerLine.firstIndex(where: {$0.uppercased() == BoSColumns.sortCode.rawValue.uppercased()}),
               let accountNumberIndex = headerLine.firstIndex(where: {$0.uppercased() == BoSColumns.accountNumber.rawValue.uppercased()}),
               let transactionDescriptionIndex = headerLine.firstIndex(where: {$0.uppercased() == BoSColumns.transactionDescription.rawValue.uppercased()}),
               let debitAmountIndex = headerLine.firstIndex(where: {$0.uppercased() == BoSColumns.debitAmount.rawValue.uppercased()}),
               let creditAmountIndex = headerLine.firstIndex(where: {$0.uppercased() == BoSColumns.creditAmount.rawValue.uppercased()}),
               let balanceIndex = headerLine.firstIndex(where: {$0.uppercased() == BoSColumns.balance.rawValue.uppercased()}) {
                
                let minColumns = max(transactionDateIndex, transactionTypeIndex, sortCodeIndex, accountNumberIndex, transactionDescriptionIndex, debitAmountIndex, creditAmountIndex, balanceIndex)
                for (index, line) in lines.enumerated().dropFirst() {
                    let fields = line.components(separatedBy: ",").map{$0.replacing("\"", with: "")}
                    if fields.count < minColumns {
                        continue
                    } else {
                        let transactionDate = Utility.dateFromString(fields[transactionDateIndex])
                        let transactionType = fields[transactionTypeIndex]
                        let sortCode = fields[sortCodeIndex]
                        let accountNumber = fields[accountNumberIndex]
                        let transactionDescription = fields[transactionDescriptionIndex]
                        let debitAmount = Float(fields[debitAmountIndex]) ?? 0
                        let creditAmount = Float(fields[creditAmountIndex]) ?? 0
                        let balance = Float(fields[balanceIndex])
                        
                        let amount = abs(debitAmount - creditAmount)
                        let drCr = (debitAmount > creditAmount ? DebitCreditType.debit : .credit)
                        
                        var transType: TransType?
                        transType = TransType.transType(code: transactionType)
                        if transType == nil {
                            // Missing - create it
                            transType = TransType(code: transactionType, desc: "\(transactionType) code")
                            transType?.insert()
                        }
                        
                        let statementLine = StatementLine(statement: statement, sequence: index, transType: transType, date: transactionDate, drCr: drCr, text: transactionDescription, amount: amount, payee: "", notes: "")
                        
                        statementLines.append(statementLine)
                    }
                }
                // Clear existing events
                // Now insert new events
                for statementLine in statementLines {
                    statementLine.insert()
                }
            } else {
                MessageBox.shared.show("Invalid CSV data - Mandatory columns not found")
            }
        }
    }
    
}
