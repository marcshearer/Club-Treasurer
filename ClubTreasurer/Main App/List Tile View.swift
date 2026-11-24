//
//  List Tile View.swift
//  BridgeScore
//
//  Created by Marc Shearer on 08/02/2022.
//

import SwiftUI

struct ListTileView <Content> : View where Content : View {
    var color: PaletteColor
    var font: Font
    var content: Content
    var height: CGFloat = defaultTileHeight
    
    init(color: PaletteColor = Palette.tile, font: Font = defaultFont, height: CGFloat = defaultTileHeight, @ViewBuilder content: ()->Content) {
        self.color = color
        self.font = font
        self.height = height
        self.content = content()
    }

    var body: some View {
        VStack {
            Spacer().frame(height: defaultSpacing / 8)
            HStack {
                Spacer().frame(width: defaultSpacing)
                HStack {
                    Spacer().frame(width: defaultSpacing * 2)
                    content
                    Spacer()
                }
                .frame(height: height - (defaultSpacing / 4))
                .background(color.background)
                .cornerRadius(defaultCornerRadius)
                Spacer().frame(width: defaultSpacing)
            }
            Spacer().frame(height: defaultSpacing / 8)
        }
        .frame(height: height)
        .foregroundColor(color.text)
        .font(font)
    }
}
