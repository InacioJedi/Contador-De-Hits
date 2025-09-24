# Placar de HITS — (Flutter)

App Flutter para gerenciamento de **HITS**, **timer** e **pontuação final** seguindo critérios de julgamento de combate (Robocore).

## ✨ Recursos
- 🕒 Timer configurável (min/seg), play/pause/reset + haptic feedback
- 👆 Placar rápido (+1 por lado ao toque, −1 nos cantos)
- 🎨 Nomes e cores personalizáveis
- 📘 Acesso ao PDF oficial de critérios (Robocore)
- 🧮 Finalização: Dano (6 níveis) + Agressividade pelos HITS (3 juízes) → total automático
- 🗂️ Código dividido em `pages/` e `widgets/`

## 📂 Estrutura
lib/
├─ main.dart
├─ pages/
│ ├─ scoreboard_page.dart
│ ├─ edit_names_page.dart
│ ├─ finalize_fight_page.dart
│ ├─ color_settings_page.dart
│ ├─ regras_robocore_page.dart
│ ├─ damage_classification_page.dart
│ └─ timer_config_page.dart
└─ widgets/
├─ round_icon_button.dart
├─ half_pane.dart
└─ top_pill_button.dart


## 🚀 Rodando
```bash
flutter pub get
flutter run         # ou: flutter run -d chrome

🧩 Dependências

url_launcher

📝 Licença

MIT — veja LICENSE.


---

# (Opcional) CI com GitHub Actions

Crie `.github/workflows/flutter.yml`:
```yaml
name: Flutter CI

on:
  push:
    branches: [ "main" ]
  pull_request:
    branches: [ "main" ]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: 'stable'
      - run: flutter --version
      - run: flutter pub get
      - run: flutter analyze
      - run: flutter test --no-pub || true   # se não tiver testes ainda
