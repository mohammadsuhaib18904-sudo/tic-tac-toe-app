class GameLogic {
  final List<String> _board = List.filled(9, '');
  String _currentPlayer = 'X';
  String? _winner;
  bool _isDraw = false;
  List<int>? _winningLine;
  int _moves = 0;
  final List<String> _moveHistory = [];

  List<String> get board => List.unmodifiable(_board);
  String get currentPlayer => _currentPlayer;
  String? get winner => _winner;
  bool get isDraw => _isDraw;
  bool get isGameOver => _winner != null || _isDraw;
  List<int>? get winningLine => _winningLine;
  int get moves => _moves;
  List<String> get moveHistory => List.unmodifiable(_moveHistory);

  static const List<List<int>> winPatterns = [
    [0, 1, 2], [3, 4, 5], [6, 7, 8], // rows
    [0, 3, 6], [1, 4, 7], [2, 5, 8], // cols
    [0, 4, 8], [2, 4, 6],            // diagonals
  ];

  /// Attempt to play at [index]. Returns true if the move was accepted.
  bool makeMove(int index) {
    if (index < 0 || index > 8) return false;
    if (_board[index].isNotEmpty) return false;
    if (isGameOver) return false;

    _board[index] = _currentPlayer;
    _moves++;
    _moveHistory.add('$_currentPlayer@$index');

    final pattern = _findWinningPattern(_currentPlayer);
    if (pattern != null) {
      _winner = _currentPlayer;
      _winningLine = pattern;
    } else if (!_board.contains('')) {
      _isDraw = true;
    } else {
      _currentPlayer = _currentPlayer == 'X' ? 'O' : 'X';
    }
    return true;
  }

  List<int>? _findWinningPattern(String symbol) {
    for (final p in winPatterns) {
      if (p.every((i) => _board[i] == symbol)) return p;
    }
    return null;
  }

  /// Pure function: returns winning line for [board] or null.
  static List<int>? findWin(List<String> board) {
    if (board.length != 9) return null;
    for (final p in winPatterns) {
      final s = board[p[0]];
      if (s.isNotEmpty && p.every((i) => board[i] == s)) return p;
    }
    return null;
  }

  /// Pure function: returns true if [board] is a draw.
  static bool isDrawBoard(List<String> board) {
    if (board.length != 9) return false;
    if (board.any((c) => c.isEmpty)) return false;
    return findWin(board) == null;
  }

  void reset() {
    for (int i = 0; i < _board.length; i++) {
      _board[i] = '';
    }
    _currentPlayer = 'X';
    _winner = null;
    _isDraw = false;
    _winningLine = null;
    _moves = 0;
    _moveHistory.clear();
  }
}