struct HistoryManager {
  var histories: [(Int, Int)] // collect the move (from: Int, to: Int)
  var historyIdx: Int

  init() {
    histories = []
    historyIdx = -1
  }

  func canUndo() -> Bool {
    return self.historyIdx >= 0
  }

  func canRedo() -> Bool {
    return self.historyIdx+1 < self.histories.count
  }

  mutating func undo() throws -> (from: Int, to: Int) {
    if !canUndo() {
      throw MyError.Message("cannot undo")
    }

    let (from, to) = self.histories[self.historyIdx]
    self.historyIdx -= 1

    return (from, to)
  }

  mutating func redo() throws -> (from: Int, to: Int) {
    if !canRedo() {
      throw MyError.Message("cannot redo")
    }

    let (from, to) = self.histories[self.historyIdx+1]
    self.historyIdx += 1

    return (from, to)
  }

  mutating func save(from: Int, to: Int) {
    while (self.historyIdx < self.histories.count-1) {
      self.histories.removeLast()
    }

    self.histories.append((from, to))
    if self.historyIdx+1 != self.histories.count-1 {
      print("wait bro.....\nthis is error\n\n\n")
    }
    self.historyIdx = self.histories.count - 1
  }
}