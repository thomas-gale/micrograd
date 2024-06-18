from micrograd.traits import CopyableAndMovable

@value
struct CopyMoveList[T: CollectionElement](CopyableAndMovable):
	var data: List[T]

	fn __init__(inout self: Self):
		self.data = List[T]()
