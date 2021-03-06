import SPMUtility
import Foundation

let arguments = ProcessInfo.processInfo.arguments.dropFirst()
let parser = ArgumentParser(usage: "<options> \"some text\"", overview: "A command-line tool similar to cowsay, dedicated to pnut.io")
let messageArgument = parser.add(positional: "\"some text\"", kind: String.self, optional: false, usage: "The text that will be included in the speech bubble")
let pnutprinterArgument = parser.add(option: "--pnutprinter", shortName: "-p", kind: Bool.self, usage: "Adds a tag which triggers pnut's printer")
let errrorMessage = "You need to pass \"some text\" to generate the message. Use --help to list arguments and options."

do {
    let parsedArguments = try parser.parse(Array(arguments))
    if let msg = parsedArguments.get(messageArgument) {
        let ps = PnutSays(thoughts: msg)
        if let _ = parsedArguments.get(pnutprinterArgument) {
            print(ps.say(pnutPrinter: true))
        } else {
            print(ps.say())
        }
    } else {
        print(errrorMessage)
    }
} catch {
    print("An error occured!\n`\(error)`.\n\(errrorMessage)")
}
