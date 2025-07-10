
import Foundation
import YaSpellChecker

@main
struct ExampleApp {
    static func main() async {
        let checker = YaSpellChecker()
        let textWithErrors = "Это тектс с арфаграфическми ашбиками для демонстрации работы спеллера."
        print("\nИсходный текст / Original text:")
        print(textWithErrors)
        do {
            let corrected = try await checker.checkAndCorrect(text: textWithErrors)
            print("\nИсправленный текст / Corrected text:")
            print(highlightDifferences(original: textWithErrors, corrected: corrected))
        } catch {
            print("Ошибка проверки: \(error.localizedDescription)")
        }
    }
}

/// Подсвечивает исправленные слова ANSI-цветом (жирный красный)
func highlightDifferences(original: String, corrected: String) -> String {
    let originalWords = original.components(separatedBy: .whitespaces)
    let correctedWords = corrected.components(separatedBy: .whitespaces)
    var result: [String] = []
    let count = max(originalWords.count, correctedWords.count)
    for i in 0..<count {
        let orig = i < originalWords.count ? originalWords[i] : ""
        let corr = i < correctedWords.count ? correctedWords[i] : ""
        if orig != corr {
            // ANSI: ярко-красный + жирный
            result.append("\u{001B}[1;31m" + corr + "\u{001B}[0m")
        } else {
            result.append(corr)
        }
    }
    return result.joined(separator: " ")
}
