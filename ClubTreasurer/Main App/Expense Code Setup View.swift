//
//  Expense Code Setup View.swift
//  Club Treasurer
//
//  Created by Marc Shearer on 24/11/2026
//

import SwiftUI

enum FocusField : Hashable {
    case code
    case desc
}

struct ExpenseCodeSetupView: View {
    @State private var title = "Expense Codes"
    @State var selected = ExpenseCode()
    @State private var canUndo = false
    @State private var canRedo = false
    @FocusState var focus: FocusField?

    var body: some View {
        StandardView("ExpenseCode") {
            VStack(spacing: 0) {
                Banner(title: $title, bottomSpace: false, back: true, backEnabled: { return selected.saveMessage == "" }, optionMode: .buttons, options: UndoManager.undoBannerOptions(canUndo: $canUndo, canRedo: $canRedo))
                DoubleColumnView {
                    ExpenseCodeSelectionView(selected: selected, changeSelected: changeSelection, removeSelected: removeSelection, addExpenseCode: addExpenseCode, focus: $focus)
                        .focusable(false)
                } rightView: {
                    ExpenseCodeDetailView(selected: selected, removeSelected: removeSelection, focus: $focus)
                }
            }
            .undoManager(canUndo: $canUndo, canRedo: $canRedo)
        }
        .onAppear {
            selected.copy(from: ExpenseCode.masterData.first!)
        }
        .onDisappear {
            save(expenseCode: selected)
        }
    }
    
    func changeSelection(newExpenseCode: ExpenseCode) {
        save(expenseCode: selected)
        selected.copy(from: newExpenseCode)
        focus = .code
        UndoManager.clearActions()
    }
    
    func removeSelection(removeExpenseCode: ExpenseCode) {
        if selected.isNew {
            // Just get rid of it if it has never been saved
            selected.copy(from: ExpenseCode.masterData.first!)
        } else {
            // If it is not used in a line allocation go ahead and delete it
            let isUsed = LineAllocation.masterData.contains(where: {$0.expenseCode == removeExpenseCode})
            if !isUsed {
                MessageBox.shared.show("This will delete the expense code permanently. Are you sure you want to do this?", cancelText: "Cancel", okText: "Delete", okAction: {
                    if let expenseCode = ExpenseCode.expenseCode(id: removeExpenseCode.expenseCodeId) {
                        expenseCode.remove()
                    }
                    selected.copy(from: ExpenseCode.masterData.first!)
                })
            } else {
                // It is used - retire it by setting the flag and moving it to the bottom of the list
                MessageBox.shared.show("As this expense code is used in line allocations it cannot be deleted. Instead it will be marked as retired. Are you sure you want to do this?", cancelText: "Cancel", okText: "Retire", okAction: {
                    selected.retired = true
                    save(expenseCode: selected)
                    if let index = ExpenseCode.masterData.firstIndex(where: {$0 == selected}) {
                        ExpenseCode.moveSequence(expenseCodes: IndexSet(integer: index), to: ExpenseCode.masterData.endIndex)
                    }
                })
            }
        }
    }

    func addExpenseCode() {
        save(expenseCode: selected)
        selected.copy(from: ExpenseCode())
        selected.sequence = ExpenseCode.masterData.last!.sequence + 1
    }
    
    func save(expenseCode: ExpenseCode) {
        if let master = ExpenseCode.expenseCode(id: expenseCode.expenseCodeId) {
            master.copy(from: expenseCode)
            master.save()
        } else {
            let master = ExpenseCode()
            master.copy(from: expenseCode)
            master.insert()
        }
    }
}

struct ExpenseCodeSelectionView : View {
    @Bindable var selected: ExpenseCode
    @State var changeSelected: (ExpenseCode)->()
    @State var removeSelected: (ExpenseCode)->()
    @State var addExpenseCode: ()->()
    var focus: FocusState<FocusField?>.Binding
    

    var body: some View {
        let disabled = selected.saveMessage != ""
        
        VStack(spacing: 0) {
            HStack {
                List {
                    ForEach(ExpenseCode.masterData.sorted(by: {$0.sequence < $1.sequence}), id: \.id) { expenseCode in
                        
                        let thisSelected = (selected == expenseCode)
                        let color = (thisSelected ? Palette.tile : Palette.background)
                        VStack {
                            Spacer().frame(height: 16)
                            HStack {
                                Spacer().frame(width: 10)
                                Text((expenseCode.code == "" ? "<Blank>" : expenseCode.code))
                                    .font(.title2).frame(width: 70)
                                Text(expenseCode.desc)
                                    .font(.title2)
                                    .lineLimit(1)
                                Spacer()
                            }
                            Spacer().frame(height: 16)
                        }
                        .background(Rectangle().fill(color.background))
                        .foregroundColor((expenseCode.retired ? color.faintText : color.text).opacity(disabled ? 0.3 : 1.0))
                        .cornerRadius(10)
                        .onDrag({expenseCode.itemProvider})
                        .onTapGesture {
                            changeSelected(expenseCode)
                        }
                    }
                    .onMove { (indexSet, toIndex) in
                        ExpenseCode.moveSequence(expenseCodes: indexSet, to: toIndex)
                        selected.sequence = ExpenseCode.expenseCode(id: selected.expenseCodeId)?.sequence ?? selected.sequence
                    }
                }
                .listStyle(.inset)
                Spacer()
            }
            .disabled(disabled)
            Spacer()
            Separator(direction: .horizontal, thickness: 2.0, color: Palette.banner.background)
            ToolbarView(canAdd: {selected.saveMessage == ""}, canRemove: {selected.isNew || ExpenseCode.masterData.count > 1}, addAction: addExpenseCode, removeAction: { removeSelected(selected)})
        }
        .background(Palette.background.background)
    }
}


struct ExpenseCodeDetailView : View {
    @Bindable var selected: ExpenseCode
    @State var removeSelected: (ExpenseCode)->()
    var focus: FocusState<FocusField?>.Binding
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                VStack(spacing: 0) {
                    
                    InsetView(title: "Expense Code Details", color: Palette.alternate) {
                        VStack(spacing: 0) {
                            
                            Input(title: "Name", field: $selected.code, height: 35, cornerRadius: 10, inlineTitle: true, inlineTitleWidth: 100, focus: focus, focusValue: .code)
                            
                            Spacer().frame(height: 20)
                            
                            Input(title: "Description", field: $selected.desc, height: 35, cornerRadius: 10, inlineTitle: true, inlineTitleWidth: 100, focus: focus)
                            
                            if selected.managedObject == nil && selected.saveMessage != "" {
                                
                                Spacer().frame(height: 40)
                                
                                Separator(padding: true, color: Palette.banner.background)
                                
                                Spacer().frame(height: 20)
                                VStack {
                                    Text("This newly created expense code is invalid (\(selected.saveMessage))")
                                    Text("Either correct it or click 'Abandon'")
                                }
                                .font(inputTitleFont)
                                
                                Spacer().frame(height: 20)
                                
                                Button {
                                    // Remove created expense code
                                    removeSelected(selected)
                                } label: {
                                    VStack {
                                        Spacer().frame(height: 6)
                                        HStack {
                                            Spacer().frame(width: 16)
                                            Text("Abandon")
                                                .foregroundColor(Palette.enabledButton.text)
                                                .font(.title2)
                                            Spacer().frame(width: 16)
                                        }
                                        Spacer().frame(height: 6)
                                    }
                                    .background(Palette.enabledButton.background)
                                    .cornerRadius(10)
                                }
                            }
                            
                            if selected.retired {
                                
                                Spacer().frame(height: 40)
                                
                                Separator(padding: true, color: Palette.banner.background)
                                
                                Spacer().frame(height: 20)
                                Text("This expense code has been marked as retired")
                                    .font(inputTitleFont)
                                
                                Spacer().frame(height: 20)
                                
                                Button {
                                    // Remove retired flag and resequence above all other retired expenseCodes
                                    selected.retired = false
                                    if let index = ExpenseCode.masterData.firstIndex(where: {$0 == selected}) {
                                        let toIndex = ExpenseCode.masterData.firstIndex(where: {$0.retired}) ?? ExpenseCode.masterData.endIndex
                                        ExpenseCode.moveSequence(expenseCodes: IndexSet(integer: index), to: toIndex)
                                    }
                                } label: {
                                    VStack {
                                        Spacer().frame(height: 6)
                                        HStack {
                                            Spacer().frame(width: 16)
                                            Text("Reinstate")
                                                .foregroundColor(Palette.enabledButton.text)
                                                .font(.title2)
                                            Spacer().frame(width: 16)
                                        }
                                        Spacer().frame(height: 6)
                                    }
                                    .background(Palette.enabledButton.background)
                                    .cornerRadius(10)
                                }
                                Spacer().frame(height: 40)
                            }
                        }
                    }
                }
            }
            Spacer()
        }
        .background(Palette.alternate.background)
    }
}
