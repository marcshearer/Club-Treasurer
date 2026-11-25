//
//  Transaction Type Setup View.swift
//  Club Treasurer
//
//  Created by Marc Shearer on 24/11/2026
//

import SwiftUI


struct TransTypeSetupView: View {
    @State private var title = "Transaction Types"
    @State var selected = TransType()
    @State private var canUndo = false
    @State private var canRedo = false
    @FocusState var focus: FocusField?

    var body: some View {
        StandardView("TransType") {
            VStack(spacing: 0) {
                Banner(title: $title, bottomSpace: false, back: true, backEnabled: { return selected.saveMessage == "" }, optionMode: .buttons, options: UndoManager.undoBannerOptions(canUndo: $canUndo, canRedo: $canRedo))
                DoubleColumnView {
                    TransTypeSelectionView(selected: selected, changeSelected: changeSelection, removeSelected: removeSelection, addTransType: addTransType, focus: $focus)
                        .focusable(false)
                } rightView: {
                    TransTypeDetailView(selected: selected, removeSelected: removeSelection, focus: $focus)
                }
            }
            .undoManager(canUndo: $canUndo, canRedo: $canRedo)
        }
        .onAppear {
            selected.copy(from: TransType.masterData.first!)
        }
        .onDisappear {
            save(transType: selected)
        }
    }
    
    func changeSelection(newTransType: TransType) {
        save(transType: selected)
        selected.copy(from: newTransType)
        focus = .code
        UndoManager.clearActions()
    }
    
    func removeSelection(removeTransType: TransType) {
        if selected.isNew {
            // Just get rid of it if it has never been saved
            selected.copy(from: TransType.masterData.first!)
        } else {
            // If it is not used in a line allocation go ahead and delete it
            let isUsed = StatementLine.masterData.contains(where: {$0.transType == removeTransType})
            if !isUsed {
                MessageBox.shared.show("This will delete the transaction type permanently. Are you sure you want to do this?", cancelText: "Cancel", okText: "Delete", okAction: {
                    if let transType = TransType.transType(id: removeTransType.transTypeId) {
                        transType.remove()
                    }
                    selected.copy(from: TransType.masterData.first!)
                })
            } else {
                // It is used - retire it by setting the flag and moving it to the bottom of the list
                MessageBox.shared.show("As this transaction type is used in statement lines it cannot be deleted. Instead it will be marked as retired. Are you sure you want to do this?", cancelText: "Cancel", okText: "Retire", okAction: {
                    selected.retired = true
                    save(transType: selected)
                    if let index = TransType.masterData.firstIndex(where: {$0 == selected}) {
                        TransType.moveSequence(transTypes: IndexSet(integer: index), to: TransType.masterData.endIndex)
                    }
                })
            }
        }
    }

    func addTransType() {
        save(transType: selected)
        selected.copy(from: TransType())
        selected.sequence = TransType.masterData.filter({$0.sequence < Int16.max}).last!.sequence + 1
    }
    
    func save(transType: TransType) {
        if let master = TransType.transType(id: transType.transTypeId) {
            master.copy(from: transType)
            master.save()
        } else {
            let master = TransType()
            master.copy(from: transType)
            master.insert()
        }
    }
}

struct TransTypeSelectionView : View {
    @Bindable var selected: TransType
    @State var changeSelected: (TransType)->()
    @State var removeSelected: (TransType)->()
    @State var addTransType: ()->()
    var focus: FocusState<FocusField?>.Binding
    

    var body: some View {
        let disabled = selected.saveMessage != ""
        
        VStack(spacing: 0) {
            HStack {
                List {
                    ForEach(TransType.masterData.sorted(by: {$0.sequence < $1.sequence}), id: \.id) { transType in
                        
                        let thisSelected = (selected == transType)
                        let color = (thisSelected ? Palette.tile : Palette.background)
                        VStack {
                            Spacer().frame(height: 16)
                            HStack {
                                Spacer().frame(width: 10)
                                Text((transType.code == "" ? "<Blank>" : transType.code))
                                    .font(.title2).frame(width: 70)
                                Text(transType.desc)
                                    .font(.title2)
                                    .lineLimit(1)
                                Spacer()
                            }
                            Spacer().frame(height: 16)
                        }
                        .background(Rectangle().fill(color.background))
                        .foregroundColor((transType.retired ? color.faintText : color.text).opacity(disabled ? 0.3 : 1.0))
                        .cornerRadius(10)
                        .onDrag({transType.itemProvider})
                        .onTapGesture {
                            changeSelected(transType)
                        }
                    }
                    .onMove { (indexSet, toIndex) in
                        TransType.moveSequence(transTypes: indexSet, to: toIndex)
                        selected.sequence = TransType.transType(id: selected.transTypeId)?.sequence ?? selected.sequence
                    }
                }
                .listStyle(.inset)
                Spacer()
            }
            .disabled(disabled)
            Spacer()
            Separator(direction: .horizontal, thickness: 2.0, color: Palette.banner.background)
            ToolbarView(canAdd: {selected.saveMessage == ""}, canRemove: {selected.isNew || TransType.masterData.count > 1}, addAction: addTransType, removeAction: { removeSelected(selected)})
        }
        .background(Palette.background.background)
    }
}


struct TransTypeDetailView : View {
    @Bindable var selected: TransType
    @State var removeSelected: (TransType)->()
    var focus: FocusState<FocusField?>.Binding
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                VStack(spacing: 0) {
                    
                    InsetView(title: "Transaction Type Details", color: Palette.alternate) {
                        VStack(spacing: 0) {
                            
                            Input(title: "Name", field: $selected.code, height: 35, cornerRadius: 10, inlineTitle: true, inlineTitleWidth: 100, focus: focus, focusValue: .code)
                            
                            Spacer().frame(height: 20)
                            
                            Input(title: "Description", field: $selected.desc, height: 35, cornerRadius: 10, inlineTitle: true, inlineTitleWidth: 100, focus: focus)
                            
                            if selected.managedObject == nil && selected.saveMessage != "" {
                                
                                Spacer().frame(height: 40)
                                
                                Separator(padding: true, color: Palette.banner.background)
                                
                                Spacer().frame(height: 20)
                                VStack {
                                    Text("This newly created transaction type is invalid (\(selected.saveMessage))")
                                    Text("Either correct it or click 'Abandon'")
                                }
                                .font(inputTitleFont)
                                
                                Spacer().frame(height: 20)
                                
                                Button {
                                    // Remove created transaction type
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
                                Text("This transaction type has been marked as retired")
                                    .font(inputTitleFont)
                                
                                Spacer().frame(height: 20)
                                
                                Button {
                                    // Remove retired flag and resequence above all other retired transTypes
                                    selected.retired = false
                                    if let index = TransType.masterData.firstIndex(where: {$0 == selected}) {
                                        let toIndex = TransType.masterData.firstIndex(where: {$0.retired}) ?? TransType.masterData.endIndex
                                        TransType.moveSequence(transTypes: IndexSet(integer: index), to: toIndex)
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
