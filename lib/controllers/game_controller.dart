import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../models/block.dart';

class GameController extends ChangeNotifier {
  static const int rows = 10;
  static const int cols = 8;
  static const int initialFilledRows = 3;

  // Board: [row][col], null = boş hücre
  late List<List<Block?>> board;

  GameController() {
    initGame();
  }

  int score = 0;
  int wrongMoves = 0;
  int? targetNumber;
  bool isGameOver = false;

  // Seçili blokların konumları (sıralı zincir)
  List<List<int>> selectedPositions = [];

  // Hızlanma mekaniği
  int get dropIntervalSeconds => max(1, 5 - score ~/ 100);

  Timer? _dropTimer;
  final Random _random = Random();

  String? feedbackMessage;

  void initGame() {
    board = List.generate(rows, (_) => List.filled(cols, null));
    score = 0;
    wrongMoves = 0;
    isGameOver = false;
    selectedPositions = [];
    feedbackMessage = null;

    // Alt 3 satırı rastgele bloklarla doldur
    for (int r = rows - initialFilledRows; r < rows; r++) {
      for (int c = 0; c < cols; c++) {
        board[r][c] = Block(value: _randomValue());
      }
    }

    targetNumber = _generateTargetNumber();
    _startDropTimer();
    notifyListeners();
  }

  int _randomValue() => _random.nextInt(9) + 1;

  // Zamanlayıcıyı başlat (skor değişince yeniden çağrılır)
  void _startDropTimer() {
    _dropTimer?.cancel();
    _dropTimer = Timer.periodic(
      Duration(seconds: dropIntervalSeconds),
      (_) => _dropNewBlock(),
    );
  }

  bool _isDropping = false;

  void _dropNewBlock() {
    if (isGameOver || _isDropping) return;

    final col = _random.nextInt(cols);

    // Sütunun en alt boş satırını bul (hedef)
    int? targetRow;
    for (int r = rows - 1; r >= 0; r--) {
      if (board[r][col] == null) {
        targetRow = r;
        break;
      }
    }

    if (targetRow == null) {
      _triggerGameOver();
      return;
    }

    // En üst satır doluysa direkt yerleştir
    if (board[0][col] != null) {
      board[targetRow][col] = Block(value: _randomValue());
      notifyListeners();
      return;
    }

    // Bloku satır 0'dan başlatıp adım adım düşür
    _isDropping = true;
    final block = Block(value: _randomValue());
    board[0][col] = block;
    notifyListeners();

    _animateDrop(col, 0, targetRow, block);
  }

  void _animateDrop(int col, int currentRow, int targetRow, Block block) {
    if (currentRow >= targetRow) {
      _isDropping = false;
      return;
    }

    Future.delayed(const Duration(milliseconds: 60), () {
      if (isGameOver) {
        _isDropping = false;
        return;
      }

      // Mevcut konumdan sil, bir alt satıra taşı
      board[currentRow][col] = null;
      board[currentRow + 1][col] = block;
      notifyListeners();

      if (currentRow + 1 >= targetRow) {
        _isDropping = false;
      } else {
        _animateDrop(col, currentRow + 1, targetRow, block);
      }
    });
  }

  void _triggerGameOver() {
    isGameOver = true;
    _dropTimer?.cancel();
    notifyListeners();
  }

  // Hedef sayı: board'daki mevcut bloklardan 2-4 komşu seçimi bul, toplamını al
  int? _generateTargetNumber() {
    final allPositions = <List<int>>[];
    for (int r = 0; r < rows; r++) {
      for (int c = 0; c < cols; c++) {
        if (board[r][c] != null) allPositions.add([r, c]);
      }
    }

    if (allPositions.isEmpty) return null;

    // Rastgele bir başlangıç bloğu seç, 2-4 komşu zincir oluştur
    allPositions.shuffle(_random);
    for (final start in allPositions) {
      final chain = _buildRandomChain(start, 2 + _random.nextInt(3));
      if (chain.length >= 2) {
        return chain.fold<int>(0, (sum, pos) => sum + board[pos[0]][pos[1]]!.value);
      }
    }

    // Fallback: herhangi iki komşu bloğun toplamı
    return _fallbackTarget();
  }

  List<List<int>> _buildRandomChain(List<int> start, int length) {
    final chain = [start];
    final used = {_key(start[0], start[1])};

    while (chain.length < length) {
      final last = chain.last;
      final neighbors = _getAdjacentFilled(last[0], last[1])
          .where((n) => !used.contains(_key(n[0], n[1])))
          .toList();
      if (neighbors.isEmpty) break;
      neighbors.shuffle(_random);
      final next = neighbors.first;
      chain.add(next);
      used.add(_key(next[0], next[1]));
    }

    return chain;
  }

  int? _fallbackTarget() {
    for (int r = 0; r < rows; r++) {
      for (int c = 0; c < cols; c++) {
        if (board[r][c] == null) continue;
        final neighbors = _getAdjacentFilled(r, c);
        if (neighbors.isNotEmpty) {
          return board[r][c]!.value + board[neighbors.first[0]][neighbors.first[1]]!.value;
        }
      }
    }
    return null;
  }

  String _key(int r, int c) => '$r,$c';

  // 8 yönlü komşu (dolu hücreler)
  List<List<int>> _getAdjacentFilled(int r, int c) {
    final result = <List<int>>[];
    for (int dr = -1; dr <= 1; dr++) {
      for (int dc = -1; dc <= 1; dc++) {
        if (dr == 0 && dc == 0) continue;
        final nr = r + dr;
        final nc = c + dc;
        if (nr >= 0 && nr < rows && nc >= 0 && nc < cols && board[nr][nc] != null) {
          result.add([nr, nc]);
        }
      }
    }
    return result;
  }

  // 8 yönlü komşu kontrolü (seçim için)
  bool _isAdjacent(List<int> a, List<int> b) {
    return (a[0] - b[0]).abs() <= 1 && (a[1] - b[1]).abs() <= 1 && !(a[0] == b[0] && a[1] == b[1]);
  }

  // Blok seçim/seçim kaldırma
  void onBlockTap(int row, int col) {
    if (isGameOver) return;
    if (board[row][col] == null) return;

    final pos = [row, col];
    final key = _key(row, col);

    // Zaten seçiliyse: sadece zincirin SONUNDAKİ blok kaldırılabilir
    final alreadyIdx = selectedPositions.indexWhere((p) => _key(p[0], p[1]) == key);
    if (alreadyIdx != -1) {
      if (alreadyIdx == selectedPositions.length - 1) {
        selectedPositions.removeLast();
        board[row][col] = board[row][col]!.copyWith(isSelected: false);
        notifyListeners();
      }
      return;
    }

    // Yeni seçim kuralları
    if (selectedPositions.length >= 4) return; // max 4 blok

    // Zincirin sonuna komşu mu?
    if (selectedPositions.isNotEmpty && !_isAdjacent(selectedPositions.last, pos)) {
      feedbackMessage = 'Blok zincire komşu değil!';
      notifyListeners();
      return;
    }

    feedbackMessage = null;
    selectedPositions.add(pos);
    board[row][col] = board[row][col]!.copyWith(isSelected: true);
    notifyListeners();
  }

  // Onay butonu
  void onConfirm() {
    if (isGameOver) return;
    if (selectedPositions.length < 2) {
      feedbackMessage = 'En az 2 blok seçmelisiniz!';
      notifyListeners();
      return;
    }

    final sum = selectedPositions.fold<int>(0, (s, p) => s + board[p[0]][p[1]]!.value);

    if (sum == targetNumber) {
      _handleCorrectMove();
    } else {
      _handleWrongMove();
    }
  }

  void _handleCorrectMove() {
    // Puan hesapla
    final gained = selectedPositions.fold<int>(0, (s, p) => s + board[p[0]][p[1]]!.points);

    // Blokları kaldır
    for (final pos in selectedPositions) {
      board[pos[0]][pos[1]] = null;
    }

    // Cascade: boşlukları aşağı doldur
    _cascadeBlocks();

    // Skor güncelle
    final prevInterval = dropIntervalSeconds;
    score += gained;
    wrongMoves = 0;
    selectedPositions = [];

    // Hız değiştiyse timer'ı yeniden başlat
    if (dropIntervalSeconds != prevInterval) {
      _startDropTimer();
    }

    targetNumber = _generateTargetNumber();
    feedbackMessage = '+$gained puan!';
    notifyListeners();
  }

  void _handleWrongMove() {
    // Seçimi temizle
    for (final pos in selectedPositions) {
      board[pos[0]][pos[1]] = board[pos[0]][pos[1]]!.copyWith(isSelected: false);
    }
    selectedPositions = [];
    wrongMoves++;

    if (wrongMoves >= 3) {
      // Ceza: Tüm sütunlara birer blok ekle
      feedbackMessage = 'Ceza! Tüm sütunlara blok eklendi!';
      _addPenaltyBlocks();
      wrongMoves = 0;
    } else {
      feedbackMessage = 'Yanlış! ($wrongMoves/3)';
    }
    notifyListeners();
  }

  // Ceza: her sütunun en üst boş satırına blok ekle
  void _addPenaltyBlocks() {
    for (int c = 0; c < cols; c++) {
      // En alt boş satırı bul
      for (int r = rows - 1; r >= 0; r--) {
        if (board[r][c] == null) {
          board[r][c] = Block(value: _randomValue());
          break;
        }
      }
    }
    // Sütun taşma kontrolü
    _checkGameOver();
  }

  void _checkGameOver() {
    for (int c = 0; c < cols; c++) {
      if (board[0][c] != null) {
        // En üst satır doluysa, sütunun tamamen dolu olup olmadığını kontrol et
        bool full = true;
        for (int r = 0; r < rows; r++) {
          if (board[r][c] == null) {
            full = false;
            break;
          }
        }
        if (full) {
          _triggerGameOver();
          return;
        }
      }
    }
  }

  // Her sütunda boşlukları aşağı kaydır
  void _cascadeBlocks() {
    for (int c = 0; c < cols; c++) {
      final column = <Block?>[];
      for (int r = 0; r < rows; r++) {
        column.add(board[r][c]);
      }

      // Dolu hücreleri alta topla
      final filled = column.whereType<Block>().toList();
      final nullCount = rows - filled.length;

      for (int r = 0; r < rows; r++) {
        board[r][c] = r < nullCount ? null : filled[r - nullCount];
      }
    }
  }

  // Seçimi sıfırla
  void clearSelection() {
    for (final pos in selectedPositions) {
      board[pos[0]][pos[1]] = board[pos[0]][pos[1]]?.copyWith(isSelected: false);
    }
    selectedPositions = [];
    feedbackMessage = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _dropTimer?.cancel();
    super.dispose();
  }
}
