
import Foundation
import YaSpellChecker

@main
struct ExampleApp {
    static func main() async {
        let checker = YaSpellChecker()
        let textWithErrors = "Это тектс с арфаграфическми ашбиками для демонстрации работы спеллера."
        print("Исходный текст:")
        print(textWithErrors)
        do {
            let corrected = try await checker.checkAndCorrect(text: textWithErrors)
            print("\nИсправленный текст:")
            print(corrected)
        } catch {
            print("Ошибка проверки: \(error)")
        }
    }
}
