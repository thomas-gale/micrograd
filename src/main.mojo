from micrograd.value import Value

fn main():
    var a = Value[Int](2)
    var b = Value[Int](4)
    var c = a + b
    print(c)
