//
//  StateLines.swift
//  Stickers-Creator
//
//  Created by Наиль Буркеев on 30.05.2022.
//

import Foundation
import UIKit

protocol StateLinesMementoProtocol {
    //func addLine(line: LineModel)
    //func previousLine() -> Bool
}

class StateLinesMemento {
    private var lines = [LineModel]()

    init(lines: [LineModel]) {
        self.lines = lines
    }
}
