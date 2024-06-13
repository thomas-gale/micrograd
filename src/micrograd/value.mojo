from collections import Set, KeyElement
from memory.unsafe import Pointer

struct Value(KeyElement, Stringable):
  var data: Float32
  var prev: Set[Value] 

  fn __init__(inout self: Value, data: Float32):
    self.data = data
    self.prev = Set[Value]()

  fn __copyinit__(inout self: Value, existing: Value):
    self.data = existing.data
    self.prev = Set[Value](existing.prev)
    pass

  fn __moveinit__(inout self: Value, owned existing: Value):
    self.data = existing.data
    self.prev.__moveinit__(existing.prev^)
    pass

  fn __hash__(self: Value) -> Int:
    return hash(self.data)

  fn __eq__(self: Value, other: Value) -> Bool:
    return self.data == other.data

  fn __ne__(self: Value, other: Value) -> Bool:
    return self.data != other.data

  fn __str__(self: Value) -> String:
    return self.data
  

