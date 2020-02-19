//  Created by ERIC DEJONCKHEERE on 19/02/2020.
//
//  pnutsays
//  cowsay replacement for pnut.io written in Swift 5

extension String {
    
    func splitByLength(_ length: Int, seperator: String) -> [String] {
        var result = [String]()
        var collectedWords = [String]()
        collectedWords.reserveCapacity(length)
        var count = 0
        let words = self.split { $0 == " " }.map(String.init)
        for word in words {
            count += word.count + 1 //add 1 to include space
            if (count > length) {
                result.append(collectedWords.map { String($0) }.joined(separator: seperator) )
                collectedWords.removeAll(keepingCapacity: true)
                count = word.count
                collectedWords.append(word)
            } else {
                collectedWords.append(word)
            }
        }
        if !collectedWords.isEmpty {
            result.append(collectedWords.map { String($0) }.joined(separator: seperator))
        }
        return result
    }
    
    func components(withMaxLength length: Int) -> [String] {
        return stride(from: 0, to: self.count, by: length).map {
            let start = self.index(self.startIndex, offsetBy: $0)
            let end = self.index(start, offsetBy: length, limitedBy: self.endIndex) ?? self.endIndex
            return String(self[start..<end])
        }
    }
    
    func removingLeadingSpaces() -> String {
        guard let index = self.firstIndex(where: { String($0) != " " }) else {
            return self
        }
        return String(self[index...])
    }
}

class PnutSays {
    
    private let thoughts: String
    private let maxWordLength: Int
    
    private lazy var wrapped = computeWrapped()
    private func computeWrapped() -> [String] {
        let firstPass = thoughts.split { $0.isNewline }
        var result = [String]()
        for block in firstPass {
            let cut = String(block).splitByLength(maxWordLength, seperator: " ")
            for subBlock in cut {
                let components = subBlock.components(withMaxLength: maxWordLength)
                for element in components {
                    result.append(element.removingLeadingSpaces())
                }
            }
        }
        if result.isEmpty {
            result.append("???")
        }
        return result
    }
    
    private lazy var longestLine = computeLongestLine()
    private func computeLongestLine() -> Int {
        let m = wrapped.max { (a, b) -> Bool in
            return a.count < b.count
        }
        return m!.count
    }
    
    private func makePadding(with s: String) -> String {
        let toAdd = longestLine - s.count
        var base = s
        for _ in 0 ... toAdd {
            base.append(" ")
        }
        return base
    }
    
    private lazy var horizontalSeparator = makeHorizontalSeparator()
    private func makeHorizontalSeparator() -> String {
        var base = " "
        for _ in 0 ... longestLine + 1 {
            base.append("–")
        }
        base.append(" ")
        return base
    }
    
    init(thoughts: String) {
        self.thoughts = thoughts
        self.maxWordLength = 15 // 15 is nice length for pnut cow
    }
    
    private let firstSeparatorStart = "/"
    private let firstSeparatorEnd = "\\"
    private let lastSeparatorStart = "\\"
    private let lastSeparatorEnd = "/"
    private let middleSeparator = "|"
    
    private let cow =
    """
     \\   ,__,
      \\  (oo)____
         (__)    )\\
            ||--|| *
    """
    
    func say(pnutPrinter: Bool = false) -> String {
        let num = wrapped.count
        if num == 1 {
            return makeOneLine(pnutPrinter: pnutPrinter)
        } else if num == 2 {
            return makeTwoLines(pnutPrinter: pnutPrinter)
        } else {
            return makeMultipleLines(number: num, pnutPrinter: pnutPrinter)
        }
    }
    
    private func makeOneLine(pnutPrinter: Bool) -> String {
        var base = makeFirstLine(with: wrapped[0], unique: true)
        base.append(horizontalSeparator + "\n" + cow)
        if pnutPrinter {
            base.append("\n\n" + "#pnutprinter*")
        }
        return base
    }
    
    private func makeTwoLines(pnutPrinter: Bool) -> String {
        let base = makeFirstLine(with: wrapped[0], unique: false)
        var last = makeLastLine(with: base, phrase: wrapped[1])
        if pnutPrinter {
            last.append("\n\n" + "#pnutprinter*")
        }
        return last
    }
    
    private func makeMultipleLines(number: Int, pnutPrinter: Bool) -> String {
        var base = makeFirstLine(with: wrapped[0], unique: false)
        for i in 1 ..< number - 1 {
            base.append(middleSeparator + " " + makePadding(with: wrapped[i]) + middleSeparator + "\n")
        }
        var last = makeLastLine(with: base, phrase: wrapped[number - 1])
        if pnutPrinter {
            last.append("\n\n" + "#pnutprinter*")
        }
        return last
    }
    
    private func makeFirstLine(with phrase: String, unique: Bool) -> String {
        var base = horizontalSeparator
        if unique {
            base.append("\n" + middleSeparator + " " + makePadding(with: phrase) + middleSeparator + "\n")
        } else {
            base.append("\n" + firstSeparatorStart + " " + makePadding(with: phrase) + firstSeparatorEnd + "\n")
        }
        return base
    }
    
    private func makeLastLine(with base: String, phrase: String) -> String {
        var base = base
        base.append(lastSeparatorStart + " " + makePadding(with: phrase) + lastSeparatorEnd + "\n")
        base.append(horizontalSeparator + "\n" + cow)
        return base
    }
}
