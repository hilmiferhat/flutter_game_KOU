# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

```bash
flutter pub get          # Bağımlılıkları yükle
flutter analyze          # Statik analiz (hata kontrolü)
flutter run              # Uygulamayı çalıştır
flutter build apk        # Android APK derle
```

## Architecture

Single-file state management via `Provider` + `ChangeNotifier`. All game logic lives in one controller.

```
lib/
  main.dart                        — Provider root, MaterialApp dark theme
  controllers/game_controller.dart — Tek kaynak: tüm oyun mantığı burada
  models/block.dart                — Block veri sınıfı + renk/puan sabitleri
  screens/game_screen.dart         — Ana ekran, overlay (game over)
  widgets/
    board_widget.dart              — GridView (10 satır × 8 sütun)
    block_widget.dart              — Tek hücre: AnimatedContainer, GestureDetector
    hud_widget.dart                — Hedef sayı, skor, yanlış hamle, hız
```

## Game Rules (PDF özeti)

- **Grid**: 8 sütun × 10 satır; başlangıçta alt 3 satır dolu (1-9 rastgele)
- **Blok düşme**: `Timer.periodic` ile rastgele sütuna blok eklenir; `dropIntervalSeconds = max(1, 5 - score ~/ 100)`
- **Hedef sayı**: Ekranda gösterilen sayıya ulaşmak için 2-4 **komşu** blok seç (yatay + dikey + çapraz)
- **Seçim zinciri**: Her yeni blok, zincirin son elemanına komşu olmalı; max 4 blok; son elemanı tekrar tap ile geri al
- **Doğru hamle**: `sum == target` → bloklar silinir, cascade (boşluklar aşağı kayar), yeni hedef üretilir
- **Yanlış hamle**: `wrongMoves++`; 3'te ceza (final aşaması)
- **Oyun sonu**: Herhangi bir sütun tamamen dolduğunda

## Puan Tablosu

| Sayı | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 |
|------|---|---|---|---|---|---|---|---|---|
| Puan | 1 | 2 | 3 | 5 | 7 | 9 |12 |15 |20 |

Sabitler `block.dart` içindeki `pointValues` map'indedir.

## iOS Simulator Build Sorunu (macOS)

`Failed to codesign Flutter.framework` hatası alınırsa — macOS quarantine attribute'u engine artifact'lara ekleniyor:

```bash
sudo xattr -cr /Users/hilmiferhat/Development/flutter/bin/cache
flutter clean
flutter run
```

sudo istemiyorsan:
```bash
dot_clean -m /Users/hilmiferhat/Development/flutter/bin/cache/artifacts/engine
flutter clean
flutter run
```

## Proje Aşamaları

**Vize (tamamlandı):** Oyun alanı, başlangıç durumu, blok düşme, hızlanma, hedef sayı, blok seçimi, doğru/yanlış işlem

**Final (yapılacak):** Ceza mekanizması (3 yanlışta tüm sütunlara blok), puan sistemi detayları, liderlik tablosu, oyun sonu ekranı kayıt
