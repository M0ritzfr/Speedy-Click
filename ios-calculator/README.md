# Calculator — SwiftUI iOS App

Ein Taschenrechner für iOS, gebaut mit **SwiftUI**, im Look der iOS-System-App
(dunkles Layout, oranger Operator-Akzent, rundes Tastenraster). Liegt als eigener
Ordner neben der Speedclick-Website und ist von ihr komplett unabhängig.

## Voraussetzungen

- Ein **Mac** mit **Xcode 15 oder neuer**
- iOS-Deployment-Target: **16.0**

> Hinweis: Diese App wurde auf einem Linux-System erzeugt und konnte dort nicht
> kompiliert werden — Swift/Xcode-Apps lassen sich nur auf einem Mac bauen.
> Der Build und die Ausführung im Simulator erfolgen bei dir lokal (siehe unten).

## Öffnen & Starten

```bash
open ios-calculator/Calculator.xcodeproj
```

1. In Xcode oben ein iOS-Simulator-Ziel wählen (z. B. *iPhone 15*).
2. **Run** (⌘R) drücken.
3. Die App startet im Simulator.

## Funktionen

- Ziffern `0`–`9` und Komma
- Grundrechenarten `+`, `−`, `×`, `÷`
- Gleich `=` mit verketteten Rechnungen (z. B. `2 + 3 × 4`)
- `AC` (alles löschen) / `C` (aktuelle Eingabe löschen)
- Vorzeichen `±` und Prozent `%`
- Division durch Null → Anzeige **„Fehler"**
- Aktive Operator-Taste wird hervorgehoben (invertiert)

## Projektstruktur

```
ios-calculator/
├── Calculator.xcodeproj/          # Xcode-Projekt
└── Calculator/
    ├── CalculatorApp.swift        # App-Einstiegspunkt (@main)
    ├── ContentView.swift          # Haupt-UI (Display + Tastenraster)
    ├── CalculatorButtonView.swift # Tasten-View, Tasten-Modell & Farben
    ├── CalculatorViewModel.swift  # ObservableObject-Adapter
    ├── CalculatorEngine.swift     # reine, testbare Rechenlogik
    └── Assets.xcassets/           # App-Icon & Akzentfarbe
```

Die **Rechenlogik** (`CalculatorEngine`) ist bewusst ohne SwiftUI-Abhängigkeit als
reiner Wertetyp geschrieben und lässt sich dadurch leicht per Unit-Test abdecken.
