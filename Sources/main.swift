// The Swift Programming Language
// https://docs.swift.org/swift-book


func main() {
  var hanoi = Hanoi()
  while !hanoi.isSolved() {
    hanoi.printHanoi()

    print("input the index of rod you want to move 'from' and move 'to")
    print("input 2 number: ", terminator: "")
    if let input = readLine() {
      do {
        if input == "undo" {
          try hanoi.undo()
        } else if input == "redo" {
          try hanoi.redo()
        } else {
          let arr = input.split(separator: " ")
          let from = Int(arr[0])!
          let to = Int(arr[1])!
          try hanoi.move(from: from, to: to)
        }
      } catch MyError.Message(let msg) {
        print("error: \(msg). pls try again")
        continue
      } catch {
        print("error: unknown error")
        return
      }
    }
  }

  print("congratulations!!! you just solved hanoi tower")
}

main()