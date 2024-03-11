struct Hanoi {
  var holes: Int
  var length: Int
  var towers: [[Int?]]
  var curIdxs: [Int]
  private var historyManager: HistoryManager

  init() {
    self.holes = 3
    self.length = 3
    self.towers = [[Int?]](repeating: [Int?](repeating: nil, count: length), count: holes)
    self.curIdxs = [Int](repeating: -1, count: holes)
    self.historyManager = HistoryManager()

    var tmp = length
    for i in 0...length-1 {
      self.towers[0][i] = tmp
      tmp -= 1
    }
    self.curIdxs[0] = length-1
  }

  mutating func move(from: Int, to: Int) throws {
    do {
      guard 0 <= from && from < self.length else {
        throw MyError.Message("invalid 'from' input")
      }
      guard 0 <= to && to < self.length else {
        throw MyError.Message("invalid 'to' input")
      }

      if self.curIdxs[from] == -1 {
        throw MyError.Message("there is no block to pop")
      }

      let topBlock = self.getTopBlock(from)!

      if self.curIdxs[to] == self.towers[to].count - 1 {
        throw MyError.Message("full of blocks. cannot push more")
      }
      if self.curIdxs[to] != -1 && topBlock > self.getTopBlock(to)! {
        throw MyError.Message("cannot put the larger block on top of the smaller block")
      }

      self.setTopBlock(from, value: nil)
      self.curIdxs[from] -= 1
      self.curIdxs[to] += 1
      self.setTopBlock(to, value: topBlock)

      historyManager.save(from: from, to: to)
    } catch {
      throw error
    }
  }

  func getTopBlock(_ i: Int) -> Int? {
    return self.towers[i][self.curIdxs[i]]
  }

  mutating func setTopBlock(_ i: Int, value: Int?) {
    self.towers[i][self.curIdxs[i]] = value
  }

  mutating func undo() throws {
    try self.historyManager.undo(move: { (from: Int, to: Int) in
      try move(from: from, to: to)
    })
  }

  mutating func redo() throws {
    try self.historyManager.redo(move: { (from: Int, to: Int) in
      try move(from: from, to: to)
    })
  }

  func isSolved() -> Bool {
    let arr = self.towers.last!
    var target = self.length
    for val in arr {
      if val != target {
        return false
      }

      target -= 1
    }

    return true
  }

  func printHanoi() {
    for i in 0...length-1 {
      print("[\(i)]", terminator: "\t")
    }
    print("\n\n", terminator: "")

    for j in stride(from: self.length-1, through: 0, by: -1) {
      for i in 0...self.holes-1 {
        print(self.towers[i][j] ?? " ", terminator: "\t")
      }
      print()
    }
  }
}