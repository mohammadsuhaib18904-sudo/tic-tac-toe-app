const readline = require('readline');

const rl = readline.createInterface({
  input: process.stdin,
  output: process.stdout
});

let board = ['', '', '', '', '', '', '', '', ''];
const playerSymbols = ['X', 'O'];
let currentPlayer = 0;

// Print the current board state
function printBoard() {
  console.log('\n');
  for (let i = 0; i < 3; i++) {
    let row = '';
    for (let j = 0; j < 3; j++) {
      const idx = i * 3 + j;
      const cell = board[idx] === '' ? idx + 1 : board[idx];
      row += ` ${cell} `;
      if (j < 2) row += '|';
    }
    console.log(row);
    if (i < 2) console.log('---+---+---');
  }
  console.log('\n');
}

// Check if a player has won
function checkWin(symbol) {
  const winPatterns = [
    [0,1,2],[3,4,5],[6,7,8], // rows
    [0,3,6],[1,4,7],[2,5,8], // cols
    [0,4,8],[2,4,6]          // diagonals
  ];
  return winPatterns.some(pattern => 
    pattern.every(idx => board[idx] === symbol)
  );
}

// Check for a draw
function checkDraw() {
  return board.every(cell => cell !== '');
}

// Reset the game state for a new round
function resetGame() {
  board = ['', '', '', '', '', '', '', '', ''];
  currentPlayer = 0;
  console.log('Starting a new game!');
  printBoard();
  askMove();
}

// Prompt the user to play again after a win or draw
function promptReplay() {
  rl.question('Do you want to play again? (y/n): ', (answer) => {
    const resp = answer.trim().toLowerCase();
    if (resp === 'y' || resp === 'yes') {
      resetGame();
    } else {
      console.log('Thanks for playing! Goodbye.');
      rl.close();
    }
  });
}

// Main move handling logic
function askMove() {
  rl.question(`Player ${playerSymbols[currentPlayer]}, enter your move (1-9): `, (answer) => {
    const move = parseInt(answer.trim(), 10);
    if (isNaN(move) || move < 1 || move > 9) {
      console.log('Invalid input. Please enter a number between 1 and 9.');
      return askMove();
    }
    const idx = move - 1;
    if (board[idx] !== '') {
      console.log('That cell is already taken. Choose another.');
      return askMove();
    }
    board[idx] = playerSymbols[currentPlayer];
    printBoard();

    if (checkWin(playerSymbols[currentPlayer])) {
      console.log(`Player ${playerSymbols[currentPlayer]} wins! Congratulations!`);
      return promptReplay();
    }
    if (checkDraw()) {
      console.log("It's a draw! Well played.");
      return promptReplay();
    }

    // Switch player and continue
    currentPlayer = 1 - currentPlayer;
    askMove();
  });
}

// Entry point
console.log('Welcome to Tic Tac Toe!');
printBoard();
askMove();