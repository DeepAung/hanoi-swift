struct HistoryManager {
  var histories: [(Int, Int)]
  var historyIdx: Int

  init() {
    histories = []
    historyIdx = -1
  }

  func canUndo() -> Bool {
    return historyIdx >= 0
  }

  func canRedo() -> Bool {
    return historyIdx+1 < histories.count
  }

  func undo(move: (Int, Int) throws -> Void) throws {
    if !canUndo() {
      return
    }

    let (from, to) = self.histories[self.historyIdx]
    try move(from, to)
  }

  func redo(move: (Int, Int) throws -> Void) throws {
    if !canRedo() {
      return
    }

    let (from, to) = self.histories[self.historyIdx]
    try move(to, from)
  }

  mutating func save(from: Int, to: Int) {
    self.histories.append((from, to))
  }
}