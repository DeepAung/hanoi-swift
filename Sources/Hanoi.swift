struct Hanoi {
  var rods: Int
  var height: Int

  // collect width of the each disk
  var towers: [[Int?]]

  // current index of top disk at X rods
  var indexs: [Int]
  private var historyManager: HistoryManager

  init() {
    // TODO: make init function be able to customize the rods and height
    self.rods = 3
    self.height = 3

    // int towers[rods][height] = {nil, nil, ...};
    self.towers = [[Int?]](repeating: [Int?](repeating: nil, count: height), count: rods)
    // int currentIndexOf[rods] = {-1, -1, ...};
    self.indexs = [Int](repeating: -1, count: rods)
    self.historyManager = HistoryManager()

    // build one sorted hanoi tower on the most left
    var tmp = height
    for i in 0...height-1 {
      self.towers[0][i] = tmp
      tmp -= 1
    }
    self.indexs[0] = height-1
  }

  mutating func move(from: Int, to: Int, saveHistory: Bool = true) throws {
    do {
      guard 0 <= from && from < self.height else {
        throw MyError.Message("invalid 'from' input")
      }
      guard 0 <= to && to < self.height else {
        throw MyError.Message("invalid 'to' input")
      }

      if self.indexs[from] == -1 {
        throw MyError.Message("there is no disk to pop")
      }

      let topDisk = self.getTopDisk(from)!

      if self.indexs[to] == self.towers[to].count - 1 {
        throw MyError.Message("full of disks. cannot push more")
      }
      if self.indexs[to] != -1 && topDisk > self.getTopDisk(to)! {
        throw MyError.Message("cannot put the larger disk on top of the smaller disk")
      }

      self.setTopDisk(from, value: nil)
      self.indexs[from] -= 1
      self.indexs[to] += 1
      self.setTopDisk(to, value: topDisk)

      if saveHistory {
        historyManager.save(from: from, to: to)
      }
    } catch {
      throw error
    }
  }

  func getTopDisk(_ i: Int) -> Int? {
    return self.towers[i][self.indexs[i]]
  }

  mutating func setTopDisk(_ i: Int, value: Int?) {
    self.towers[i][self.indexs[i]] = value
  }

  // TODO: there must be a better for this
  mutating func undo() throws {
    let (from, to) = try self.historyManager.undo()
    try move(from: to, to: from, saveHistory: false)
  }

  mutating func redo() throws {
    let (from, to) = try self.historyManager.redo()
    try move(from: from, to: to, saveHistory: false)
  }

  func isSolved() -> Bool {
    let arr = self.towers.last!
    var expectedVal = self.height
    for val in arr {
      if val != expectedVal {
        return false
      }

      expectedVal -= 1
    }

    return true
  }

  func printHanoi() {
    for i in 0...height-1 {
      print("[\(i)]", terminator: "\t")
    }
    print()

    for j in stride(from: self.height-1, through: 0, by: -1) {
      for i in 0...self.rods-1 {
        print(self.towers[i][j] ?? " ", terminator: "\t")
      }
      print()
    }
  }
}