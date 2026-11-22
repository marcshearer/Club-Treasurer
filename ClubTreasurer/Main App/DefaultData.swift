//
//  DefaultData.swift
//  ClubTreasurer
//
//  Created by Marc Shearer on 21/11/2026.
//

extension ExpenseCodeViewModel {
    
    override public class func createDefaultData() {
        ExpenseCodeViewModel(code: "51001", desc: "Product Purchase / resale").insert()
        ExpenseCodeViewModel(code: "56305", desc: "Subcontractors - misc.").insert()
        ExpenseCodeViewModel(code: "57100", desc: "Concert prof. services").insert()
        ExpenseCodeViewModel(code: "57200", desc: "Fees to Square").insert()
        ExpenseCodeViewModel(code: "57300", desc: "Website costs").insert()
        ExpenseCodeViewModel(code: "57400", desc: "Concert hall rent").insert()
        ExpenseCodeViewModel(code: "57600", desc: "Music director").insert()
        ExpenseCodeViewModel(code: "57700", desc: "Accompanist").insert()
        ExpenseCodeViewModel(code: "57800", desc: "Rehearsal hall rent").insert()
        ExpenseCodeViewModel(code: "57900", desc: "Concert - soloists").insert()
        ExpenseCodeViewModel(code: "58200", desc: "Concert instrumental").insert()
        ExpenseCodeViewModel(code: "58300", desc: "Concert - organ/piano").insert()
        ExpenseCodeViewModel(code: "58400", desc: "Concert - conductor").insert()
        ExpenseCodeViewModel(code: "60000", desc: "Advertising").insert()
        ExpenseCodeViewModel(code: "63500", desc: "Commissions & Fees").insert()
        ExpenseCodeViewModel(code: "67000", desc: "Insurance").insert()
        ExpenseCodeViewModel(code: "69000", desc: "Licenses").insert()
        ExpenseCodeViewModel(code: "71000", desc: "Office expense").insert()
        ExpenseCodeViewModel(code: "73100", desc: "Printing offsite").insert()
        ExpenseCodeViewModel(code: "73500", desc: "Postage").insert()
        ExpenseCodeViewModel(code: "74000", desc: "Rent or lease").insert()
        ExpenseCodeViewModel(code: "77000", desc: "Utilities").insert()
    }
}
    
extension BankAccountViewModel {
    override public class func createDefaultData() {
        BankAccountViewModel(desc: "Default Bank Account").insert()
    }
}
