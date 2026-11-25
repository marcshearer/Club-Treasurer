//
//  DefaultData.swift
//  ClubTreasurer
//
//  Created by Marc Shearer on 21/11/2026.
//

extension ExpenseCode {
    
    override public class func createDefaultData() {
        ExpenseCode(code: "51001", desc: "Product Purchase / resale", sequence: 1).insert()
        ExpenseCode(code: "56305", desc: "Subcontractors - misc.", sequence: 2).insert()
        ExpenseCode(code: "57100", desc: "Concert prof. services", sequence: 3).insert()
        ExpenseCode(code: "57200", desc: "Fees to Square", sequence: 4).insert()
        ExpenseCode(code: "57300", desc: "Website costs", sequence: 5).insert()
        ExpenseCode(code: "57400", desc: "Concert hall rent", sequence: 6).insert()
        ExpenseCode(code: "57600", desc: "Music director", sequence: 7).insert()
        ExpenseCode(code: "57700", desc: "Accompanist", sequence: 8).insert()
        ExpenseCode(code: "57800", desc: "Rehearsal hall rent", sequence: 9).insert()
        ExpenseCode(code: "57900", desc: "Concert - soloists", sequence: 10).insert()
        ExpenseCode(code: "58200", desc: "Concert instrumental", sequence: 11).insert()
        ExpenseCode(code: "58300", desc: "Concert - organ/piano", sequence: 12).insert()
        ExpenseCode(code: "58400", desc: "Concert - conductor", sequence: 13).insert()
        ExpenseCode(code: "60000", desc: "Advertising", sequence: 14).insert()
        ExpenseCode(code: "63500", desc: "Commissions & Fees", sequence: 15).insert()
        ExpenseCode(code: "67000", desc: "Insurance", sequence: 16).insert()
        ExpenseCode(code: "69000", desc: "Licenses", sequence: 17).insert()
        ExpenseCode(code: "71000", desc: "Office expense", sequence: 18).insert()
        ExpenseCode(code: "73100", desc: "Printing offsite", sequence: 19).insert()
        ExpenseCode(code: "73500", desc: "Postage", sequence: 20).insert()
        ExpenseCode(code: "74000", desc: "Rent or lease", sequence: 21).insert()
        ExpenseCode(code: "77000", desc: "Utilities", sequence: 22).insert()
    }
}

extension TransType {
    
    override public class func createDefaultData() {
        TransType(code: "FPI", desc: "Faster Payment Incoming", sequence: 1).insert()
        TransType(code: "FPO", desc: "Faster Payment Outgoing", sequence: 2).insert()
        TransType(code: "PAY", desc: "Concert prof. services", sequence: 3).insert()
        TransType(code: "DEP", desc: "Fees to Square", sequence: 4).insert()
        TransType(code: "BGC", desc: "Bank Giro Credit", sequence: 5).insert()
        TransType(code: "DEB", desc: "Debit Card payment", sequence: 6).insert()
        TransType(code: "DD", desc: "Direct Debit", sequence: 7).insert()
        TransType(code: "SO", desc: "Standing Order", sequence: 8).insert()
        TransType(code: "BP", desc: "Bill Payment", sequence: 9).insert()
        TransType(code: "CPT", desc: "Cashpoint (ATM withdrawal)", sequence: 10).insert()
        TransType(code: "TFR", desc: "Transfer (between accounts)", sequence: 11).insert()
        TransType(code: "CHQ", desc: "Cheque", sequence: 12).insert()
        TransType(code: "COR", desc: "Correction", sequence: 13).insert()
        TransType(code: "CSH", desc: "Cash", sequence: 14).insert()
        TransType(code: "FEE", desc: "Fixed Service Charge", sequence: 15).insert()
        TransType(code: "OTH", desc: "OTH", sequence: 16).insert()
    }
}
    
extension BankAccount {
    override public class func createDefaultData() {
        BankAccount(desc: "Default Bank Account").insert()
    }
}
