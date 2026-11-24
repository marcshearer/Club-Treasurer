//
//  Inset View.swift
//  BridgeScore
//
//  Created by Marc Shearer on 26/01/2022.
//

import SwiftUI

struct InsetView <Content>: View where Content: View {
    var title: String?
    var color: PaletteColor
    var font: Font
    var content: Content

    init(title: String? = nil, color: PaletteColor = Palette.inset, font: Font = .body, @ViewBuilder content: ()->Content) {
        self.title = title
        self.color = color
        self.font = font
        self.content = content()
    }
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer().frame(height: 10)
            if let title = title {
                VStack {
                    HStack {
                        Spacer().frame(width: 20)
                        Text(title.uppercased()).foregroundColor(Palette.alternate.faintText)
                        Spacer()
                    }
                    Spacer().frame(height: 4)
                }
            }
            HStack {
                Spacer().frame(width: 10)
                VStack(spacing: 0) {
                    Spacer().frame(height: 8)
                    HStack {
                        Spacer().frame(width: 5)
                        content
                        Spacer().frame(width: 5)
                    }
                }
                .background(color.background)
                .cornerRadius(10)
                Spacer().frame(width: 10)
            }
        }
        .foregroundColor(color.text)
        .font(font)
    }
}
