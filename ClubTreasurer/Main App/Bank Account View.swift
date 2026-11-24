//
//  Bank Account View.swift
//  ClubTreasurer
//
//  Created by Marc Shearer on 22/11/2026.
//

import SwiftUI

struct BankAccountView: View {
    @Environment(\.dismiss) var dismiss
    var newAccount: Bool
    @State var bankAccount: BankAccountViewModel
    @Binding var path: NavigationPath
    
    var title: String = "Bank Account"
    @State var message: String = ""
    
    private let id = bankAccountViewId
    
    var body: some View {
        StandardView("Bank Account", slideInId: id) {
            VStack(spacing: 0) {
                Banner(title: Binding.constant((newAccount ? "New " : "") + title + (newAccount ? "" : " - \(bankAccount.desc)")), backAction: backAction, leftTitle: true)
                Spacer().frame(height: 10)
                InsetView(title: "Details", color: Palette.alternate) {
                    Middle {
                        Leading(padding: 0) {
                            Input(title: "Description", field: $bankAccount.desc, message: $message, topSpace: 0, width: 400) //, inlineTitle: true, inlineTitleWidth: 100)
                                .onChange(of: bankAccount.desc, initial: true) { _, newValue in
                                    message = bankAccount.saveMessage
                                }
                        }
                        Spacer().frame(height: 8)
                    }
                }
                .frame(height: 70)
                Spacer().frame(height: 10)
                InsetView(title: "Statements", color: Palette.alternate) {
                    VStack {
                        newStatementTileView()
                        ScrollView {
                            LazyVStack {
                                let data = StatementViewModel.masterData.filter({$0.bankAccount == bankAccount})
                                ForEach(data) { (statement) in
                                    statementTileView(selectedStatement: statement)
                                }
                            }
                        }
                        Spacer()
                    }
                }
                .opacity(message != "" ? 0.5 : 1.0)
                .disabled(message != "")
                Spacer().frame(height: 10)
            }
        }
        .navigationBarBackButtonHidden(true)
    }
    
    func backAction()->(Bool) {
        if message != "" {
            if newAccount {
                MessageBox.shared.show("Some data is not valid (\(message)).\n\nEither press Re-edit to correct the data, or press Cancel to abandon the account creation.", cancelText: "Re-edit", okText: "Cancel", okAction: {
                    dismiss()
                })
            } else {
                MessageBox.shared.show("Some data is not valid (\(message)).\n\nEither press Re-edit to correct the data, or press Cancel to undo any changes.", cancelText: "Re-edit", okText: "Cancel", okAction: {
                    bankAccount.revert()
                    dismiss()
                })
            }
            return false
        } else {
            bankAccount.save()
            return true
        }
    }
    
    func newStatementTileView() -> some View {
        return ListTileView(color: Palette.contrastTile) {
            HStack {
                Image(systemName: "plus.square")
                Text("New Statement")
            }
        }
        .onTapGesture {
            bankAccount.save()
            path.append(Destination.statement(statement: StatementViewModel(bankAccount: bankAccount)))
        }
    }
    
    func statementTileView(selectedStatement: StatementViewModel) -> some View {
        return ListTileView(color: Palette.tile) {
            HStack {
                Text(selectedStatement.desc)
            }
        }
        .onTapGesture {
            bankAccount.save()
            path.append(Destination.statement(statement: selectedStatement))
        }
    }
}
