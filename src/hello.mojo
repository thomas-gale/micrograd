def greet(name: String) -> String:
    return "Hello, " + name + "!"


fn main():
    try:
        print(greet("World"))
        print(greet("Grok"))
        print(greet("123"))
        print(greet(""))
    except:
        print("Error!")
