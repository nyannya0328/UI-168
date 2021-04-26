//
//  TextBox.swift
//  UI-168
//
//  Created by にゃんにゃん丸 on 2021/04/26.
//

import SwiftUI

struct TextBox: Identifiable {
    var id = UUID().uuidString
    var text : String = ""
    var offset : CGSize = .zero
    var isBold : Bool = false
    var isAdded : Bool = false
    var lastOffset : CGSize = .zero
    var textColor : Color = .white
    var size : CGFloat = 30
}

