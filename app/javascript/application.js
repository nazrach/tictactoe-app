// Entry point for the build script in your package.json
import "@hotwired/turbo-rails"
import "./controllers"
import * as bootstrap from "bootstrap"

document.addEventListener('DOMContentLoaded', () => {
  const board = document.getElementById('board');
  const resetButton = document.getElementById('resetButton');

  board.addEventListener('click', (event) => {
    if (event.target.classList.contains('cell')) {
      makeMove(event.target.dataset.index);
    }
  });

  resetButton.addEventListener('click', resetGame);

  function makeMove(index) {
    fetch('/make_move.json', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content
      },
      body: JSON.stringify({
        index: index,
        current_player: getCurrentPlayer(),  // Assuming you have a function to get current player
        board: getBoard()
      })
    })
      .then(response => response.json())
      .then(data => updateGame(data));
  }

  function getCurrentPlayer() {
    let currentPlayerElement = document.getElementById("current-player");

    return currentPlayerElement.value;
  }

  function getBoard() {
    var cellElements = document.querySelectorAll('#board .cell');

    var board = [];

    cellElements.forEach(function (cell) {
      var index = cell.dataset.index;
      var content = cell.textContent.trim();

      board[index] = content;
    });

    return board;
  }

  function resetGame() {
    fetch('/reset_game.json', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content
      }
    })
      .then(response => response.json())
      .then(data => updateGame(data));
  }

  function updateGame(data) {
    console.log(data.game_board)
    document.getElementById("current-player").value = data.current_player;
    document.querySelector('p').textContent = `Current Turn: ${data.current_player}`;
    document.getElementById('board').innerHTML = data.game_board.map((cell, index) => `<div class="cell" data-index="${index}">${cell}</div>`).join('');
    if (data.winner) {
      alert(`Player ${data.winner} Menang!`);
    }else if (!(data.winner) && !(data.game_board.includes(''))){
      alert('The game is a draw.!');
    }
  }
});