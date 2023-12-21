from defaultable import Defaultable


trait OptionalValue(Movable, Copyable, Defaultable):
    ...


struct Optional[T: OptionalValue]:
    var value: T
    var isPresent: Bool

    fn __init__(inout self, value: T, isPresent: Bool = True):
        self.value = value
        self.isPresent = isPresent

    @staticmethod
    fn empty() -> Optional[T]:
        return Optional[T](T.default(), False)
