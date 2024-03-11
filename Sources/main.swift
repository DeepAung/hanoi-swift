// The Swift Programming Language
// https://docs.swift.org/swift-book


func main() {
  var hanoi = Hanoi()
  while !hanoi.isSolved() {
    print("==========================")
    hanoi.printHanoi()

    print("case 1: 2 number as index of rods you want to move \"from\" and move \"to\"")
    print("case 2: type \"undo\"")
    print("case 3: type \"redo\"")
    print("input: ", terminator: "")
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