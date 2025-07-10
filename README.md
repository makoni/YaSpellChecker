# YaSpellChecker

## English

**YaSpellChecker** is a Swift Package for spell checking and automatic correction of Russian and English texts using the Yandex Speller API. It provides an async actor interface for easy integration into your Swift applications and scripts.

### Features
- Spell checking and correction for Russian and English (Yandex Speller API)
- Async/await support
- Simple integration into any Swift project
- Example executable target for demonstration

### Installation
Add the package to your `Package.swift` dependencies:

```swift
.package(url: "https://github.com/your-username/YaSpellChecker.git", from: "1.0.0")
```

And add `YaSpellChecker` to your target dependencies:

```swift
.target(
    name: "YourTarget",
    dependencies: ["YaSpellChecker"]
)
```

### Usage Example
```swift
import YaSpellChecker

let checker = YaSpellChecker()
let textWithErrors = "This is a tset with erors."
let corrected = try await checker.checkAndCorrect(text: textWithErrors)
print(corrected)
```

Or see `Sources/ExampleApp/main.swift` for a full example with colored output in terminal.

### Demo
To run the demo app:

```sh
swift run ExampleApp
```

---

## Русский

**YaSpellChecker** — Swift Package для проверки и автоматического исправления орфографии в русских и английских текстах через API Яндекс.Спеллера. Предоставляет actor-интерфейс для асинхронной работы.

### Возможности
- Проверка и исправление орфографии (русский, английский)
- Поддержка async/await
- Простая интеграция в любой Swift-проект
- Пример использования в отдельном executable target

### Установка
Добавьте пакет в зависимости вашего `Package.swift`:

```swift
.package(url: "https://github.com/your-username/YaSpellChecker.git", from: "1.0.0")
```

И добавьте `YaSpellChecker` в зависимости вашей цели:

```swift
.target(
    name: "YourTarget",
    dependencies: ["YaSpellChecker"]
)
```

### Пример использования
```swift
import YaSpellChecker

let checker = YaSpellChecker()
let textWithErrors = "Это тектс с ашбиками."
let corrected = try await checker.checkAndCorrect(text: textWithErrors)
print(corrected)
```

Полный пример с подсветкой исправленных слов — в `Sources/ExampleApp/main.swift`.

### Демонстрация
Для запуска демонстрационного приложения выполните:

```sh
swift run ExampleApp
```
