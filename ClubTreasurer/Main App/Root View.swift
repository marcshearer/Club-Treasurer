//
//  Bank Account View.swift
//  ClubTreasurer
//
//  Created by Marc Shearer on 22/11/2026.
//

import SwiftUI

enum Destination: Hashable {
    case root
    case bankAccount(bankAccount: BankAccountViewModel)
    case statement(statement: StatementViewModel)
    
    var navigate: Bool {
        switch self {
        case .bankAccount, .statement:
            true
        default:
            false
        }
    }
}

struct RootView : View {
    @Environment(\.verticalSizeClass) var sizeClass
    private let id = rootViewId
    @State private var destination: Destination = .root { didSet {
        if destination.navigate { path.append(destination)
        } } }
    @State private var path = NavigationPath()

    var body: some View {
        StandardView("Root View", slideInId: id, navigation: true, path: $path) {
            VStack {
                Banner(title: Binding.constant("Bank Accounts"), back: false)
                HStack {
                    Spacer().frame(width: 5)
                    VStack {
                        Spacer().frame(height: 10)
                        
                        newBankAccountTileView()
                        ScrollView {
                            LazyVStack {
                                ForEach(BankAccountViewModel.masterData) { (bankAccount) in
                                    bankAccountTileView(selectedBankAccount: bankAccount)
                                }
                            }
                        }
                        
                        Spacer().frame(height: 10)
                    }
                    Spacer().frame(width: 5)
                }
                Spacer()
            }
            .navigationDestination(for: Destination.self) { (destination) in
                AnyView(navigateToDestinationView(destination: destination))
            }
        }
    }
    
    func navigateToDestinationView(destination: Destination) -> any View {
        var result: any View
        switch destination {
        case .bankAccount(let bankAccount):
            result = BankAccountView(newAccount: bankAccount.managedObject == nil, bankAccount: bankAccount, path: $path)
        case .statement(let statement):
            result = StatementView(newStatement: statement.managedObject == nil, statement: statement, path: $path)
        default:
            result = EmptyView()
        }
        return result
    }
    
    func newBankAccountTileView() -> some View {
        return ListTileView(color: Palette.contrastTile) {
            HStack {
                Image(systemName: "plus.square")
                Text("New Bank Account")
            }
        }
        .onTapGesture {
            path.append(Destination.bankAccount(bankAccount: BankAccountViewModel()))
        }
    }
    
    func bankAccountTileView(selectedBankAccount: BankAccountViewModel) -> some View {
        return ListTileView(color: Palette.tile) {
            HStack {
                Text(selectedBankAccount.desc)
            }
        }
        .onTapGesture {
            path.append(Destination.bankAccount(bankAccount: selectedBankAccount))
        }
    }
}
