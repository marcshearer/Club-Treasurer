//
//  Statement View.swift
//  ClubTreasurer
//
//  Created by Marc Shearer on 22/11/2026.
//

import SwiftUI
import UniformTypeIdentifiers

struct StatementView: View {
    @Environment(\.dismiss) var dismiss
    var newStatement: Bool
    @State var statement: StatementViewModel
    @Binding var path: NavigationPath
    
    var title: String = "Statement"
    @State var message: String = ""
    @State private var droppedFiles: [(filename: String, contents: String)] = []
    @State private var dropZoneEntered = false
    @State private var isImporting = false
    @State private var bodyContentWidth: CGFloat?
    private let uttypes = [UTType.data]
    
    private let id = statementViewId
    
    
    let columns = [ GridItem(.fixed(150)), GridItem(.fixed(100)), GridItem(.flexible(minimum: 100)), GridItem(.fixed(100)), GridItem(.fixed(100)) ]
    
    var body: some View {
        StandardView("Statement", slideInId: id) {
            VStack(spacing: 0) {
                Banner(title: Binding.constant((newStatement ? "New " : "") + title + (newStatement ? "" : " - \(statement.desc)")), backAction: backAction, leftTitle: true)
                Spacer().frame(height: 10)
                InsetView(title: "Details", color: Palette.alternate) {
                    Middle {
                        Leading(padding: 0) {
                            Input(title: "Description", field: $statement.desc, message: $message, topSpace: 0, width: 400) //, inlineTitle: true, inlineTitleWidth: 100)
                                .onChange(of: statement.desc, initial: true) { _, newValue in
                                    message = statement.saveMessage
                                }
                        }
                        Spacer().frame(height: 8)
                    }
                }
                .frame(height: 75)
                Spacer().frame(height: 10)
                InsetView(title: "Statement Lines", color: Palette.alternate) {
                    GeometryReader { geometry in
                        let data = StatementLineViewModel.masterData.filter({$0.statement == statement})
                        if message != "" || !data.isEmpty {
                            VStack {
                                HStack {
                                    LazyVGrid(columns: columns, spacing: 0) {
                                        Text("Date").frame(maxWidth: .infinity, alignment: .leading)
                                        Text("Type").frame(maxWidth: .infinity, alignment: .leading)
                                        Text("Description").frame(maxWidth: .infinity, alignment: .leading)
                                        Text("Debit").frame(maxWidth: .infinity, alignment: .trailing)
                                        Text("Credit").frame(maxWidth: .infinity, alignment: .trailing)
                                    }
                                    .frame(width: bodyContentWidth)
                                    .font(defaultFont.bold())
                                    .background(Palette.alternate.background)
                                    .padding(.vertical, 8)
                                    Spacer()
                                }
                                ScrollView {
                                    LazyVGrid(columns: columns, spacing: 10, pinnedViews: [.sectionHeaders]) {
                                        Section {
                                            ForEach(data) { (line) in
                                                Text(line.date!.toString())
                                                    .frame(maxWidth: .infinity, alignment: .leading)
                                                Text(line.type)
                                                    .frame(maxWidth: .infinity, alignment: .leading)
                                                Text(line.text)
                                                    .lineLimit(2)
                                                    .frame(maxWidth: .infinity, alignment: .leading)
                                                Text((line.drCr == .debit ? line.amount : 0).toString(places: 2, exact: true, blankIfZero: true))
                                                    .frame(maxWidth: .infinity, alignment: .trailing)
                                                Text((line.drCr == .credit ? line.amount : 0).toString(places: 2, exact: true, blankIfZero: true))
                                                    .frame(maxWidth: .infinity, alignment: .trailing)
                                            }
                                        }
                                    }
                                    .font(defaultFont)
                                    .onGeometryChange(for: CGFloat.self) { proxy in
                                        proxy.size.width
                                    } action: { newWidth in
                                        bodyContentWidth = newWidth
                                    }
                                }
                                .clipped()
                                Spacer()
                            }
                            .background(Palette.alternate.background)
                            .frame(minWidth: geometry.size.width)
                        } else {
                            dropZone
                        }
                    }
                }
                .disabled(message != "")
                Spacer().frame(height: 10)
            }
        }
        .navigationBarBackButtonHidden(true)
    }
    
    var dropZone: some View {
        VStack(spacing: 0) {
            HStack {
                Spacer().frame(width: 50)
                VStack {
                    Spacer().frame(height: 20)
                    ZStack {
                        RoundedRectangle(cornerRadius: 30, style: .continuous)
                            .foregroundColor(dropZoneEntered ? Palette.contrastTile.background : Palette.background.background)
                        HStack {
                            Spacer().frame(width: 50)
                            Spacer()
                            VStack {
                                Spacer()
                                Text("Drop Statement Detail CSV file here").font(bannerFont)
                                    .multilineTextAlignment(.center)
                                Spacer()
                            }
                            Spacer()
                            Spacer().frame(width: 50)
                        }
                        .overlay(RoundedRectangle(cornerRadius: 30)
                            .strokeBorder(style: StrokeStyle(lineWidth: 5, dash: [10, 5]))
                            .foregroundColor(Palette.gridLine))
                    }
                    .onDrop(of: uttypes, delegate: DropFiles(dropZoneEntered: $dropZoneEntered, droppedFiles: $droppedFiles))
                    Spacer().frame(height: 20)
                }
                Spacer().frame(width: 50)
            }
            .onChange(of: droppedFiles.count, initial: false) {
                if !droppedFiles.isEmpty {
                    statement.save()
                    if droppedFiles.count > 1 {
                        MessageBox.shared.show("Only one file can be dropped")
                    } else {
                        isImporting = true
                        ImportBankOfScotland.importStatementLines(droppedFiles.first!.contents, statement: statement)
                    }
                    droppedFiles = []
                }
            }
        }
    }
    
    func backAction()->(Bool) {
        if message != "" {
            if newStatement {
                MessageBox.shared.show("Some data is not valid (\(message)).\n\nEither press Re-edit to correct the data, or press Cancel to abandon the account creation.", cancelText: "Re-edit", okText: "Cancel", okAction: {
                    dismiss()
                })
            } else {
                MessageBox.shared.show("Some data is not valid (\(message)).\n\nEither press Re-edit to correct the data, or press Cancel to undo any changes.", cancelText: "Re-edit", okText: "Cancel", okAction: {
                    statement.revert()
                    dismiss()
                })
            }
            return false
        } else {
            statement.save()
            return true
        }
    }
}
