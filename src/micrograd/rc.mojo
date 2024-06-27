from memory.unsafe_pointer import (
    UnsafePointer,
    initialize_pointee_move,
    destroy_pointee,
)


from micrograd.traits import CopyableAndMovable


struct RC[T: CopyableAndMovable]:
    """
    Experimental, non-thread-safe reference counted pointer.
    """

    var ptr: UnsafePointer[T]
    var ref_count: UnsafePointer[Int]

    fn __init__(inout self, owned data: T):
        """
        Create a new RC with the given data (which can be transferred to the RC).
        """
        self.ptr = UnsafePointer[T].alloc(1)
        initialize_pointee_move(self.ptr, data^)
        self.ref_count = UnsafePointer[Int].alloc(1)
        initialize_pointee_move(self.ref_count, 1)

    fn __init__(inout self, owned ptr: UnsafePointer[T]):
        """
        Create a new RC with the given pointer to the data.
        """
        self.ptr = ptr
        self.ref_count = UnsafePointer[Int].alloc(1)
        initialize_pointee_move(self.ref_count, 1)

    fn clone(self) -> Self:
        """
        Create a deep copy of the data and returns a new RC.
        """
        return Self(self.get_data_copy())

    fn __copyinit__(inout self, existing: Self):
        """
        Create a shallow copy of the data and returns a new RC with the same data and incremented ref count.
        """
        self.ptr = existing.ptr
        self.ref_count = existing.ref_count
        self.ref_count[] += 1

    fn __moveinit__(inout self, owned existing: Self):
        """
        Move the data from the existing RC to the new RC.
        """
        self.ptr = existing.ptr
        self.ref_count = existing.ref_count

    fn __del__(owned self):
        """
        On destruction, decrement the ref count and destroy the data if the ref count reaches 0.
        """
        # print("Decrement Ref: " + str(self.ptr))
        self.ref_count[] -= 1
        if self.ref_count[] <= 0:
            # print("Destroying RC: " + str(self.ptr))
            destroy_pointee(self.ptr)
            destroy_pointee(self.ref_count)

    fn get_data_copy(self) -> T:
        return self.ptr[]

    fn get_ref_count(self) -> Int:
        return self.ref_count[]
