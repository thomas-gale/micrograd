# import random
from memory.unsafe import Pointer
from comparable import Comparable
from optional import Optional


trait RBNodeData(Comparable, Copyable, Stringable):
    ...


# struct OptionalPointer[type: AnyRegType, address_space: AddressSpace]:


struct RBNode[T: RBNodeData](Stringable):
    var val: T
    var red: Bool
    # var test: Pointer[Int]
    var parent: Pointer[Self]
    # var left: Pointer[Self]
    # var right: Pointer[Self]

    fn __init__(inout self, val: T):
        self.val = val
        self.red = True
        # self.test = Pointer[Int].alloc(1)
        self.parent = Pointer[Self].alloc(4)
        # self.left = Pointer[Self].alloc(1)
        # self.right = Pointer[Self].alloc(1)

    fn __str__(self) -> String:
        return str(self.val) + " " + ("r" if self.red else "b")


# Urrggh
struct NodeDataInt(RBNodeData):
    var val: Int

    fn __init__(inout self, val: Int):
        self.val = val

    fn __copyinit__(inout self, other: Self):
        self.val = other.val

    fn __str__(self) -> String:
        return str(self.val)

    fn __lt__(self, other: Self) -> Bool:
        return self.val < other.val


fn main():
    let rbnode = RBNode[NodeDataInt](42)
    print(rbnode)
    # tree = RBTree()
    # for x in range(1, 51):
    #     tree.insert(x)
    # print(tree)


# struct RBTree[T: Comparable]:
#     var nil: RBNode[T]

#     fn __init__(inout self):
#         self.nil = RBNode[T](0)
#         self.nil.red = False
#         self.nil.left = None
#         self.nil.right = None
#         self.root = self.nil

#     def insert(self, val):
#         # Ordinary Binary Search Insertion
#         new_node = RBNode(val)
#         new_node.parent = None
#         new_node.left = self.nil
#         new_node.right = self.nil
#         new_node.red = True  # new node must be red

#         parent = None
#         current = self.root
#         while current != self.nil:
#             parent = current
#             if new_node.val < current.val:
#                 current = current.left
#             elif new_node.val > current.val:
#                 current = current.right
#             else:
#                 return

#         # Set the parent and insert the new node
#         new_node.parent = parent
#         if parent == None:
#             self.root = new_node
#         elif new_node.val < parent.val:
#             parent.left = new_node
#         else:
#             parent.right = new_node

#         # Fix the tree
#         self.fix_insert(new_node)

#     def fix_insert(self, new_node):
#         while new_node != self.root and new_node.parent.red:
#             if new_node.parent == new_node.parent.parent.right:
#                 u = new_node.parent.parent.left  # uncle
#                 if u.red:
#                     u.red = False
#                     new_node.parent.red = False
#                     new_node.parent.parent.red = True
#                     new_node = new_node.parent.parent
#                 else:
#                     if new_node == new_node.parent.left:
#                         new_node = new_node.parent
#                         self.rotate_right(new_node)
#                     new_node.parent.red = False
#                     new_node.parent.parent.red = True
#                     self.rotate_left(new_node.parent.parent)
#             else:
#                 u = new_node.parent.parent.right  # uncle

#                 if u.red:
#                     u.red = False
#                     new_node.parent.red = False
#                     new_node.parent.parent.red = True
#                     new_node = new_node.parent.parent
#                 else:
#                     if new_node == new_node.parent.right:
#                         new_node = new_node.parent
#                         self.rotate_left(new_node)
#                     new_node.parent.red = False
#                     new_node.parent.parent.red = True
#                     self.rotate_right(new_node.parent.parent)
#         self.root.red = False

#     def exists(self, val):
#         curr = self.root
#         while curr != self.nil and val != curr.val:
#             if val < curr.val:
#                 curr = curr.left
#             else:
#                 curr = curr.right
#         return curr

#     # rotate left at node x
#     def rotate_left(self, x):
#         y = x.right
#         x.right = y.left
#         if y.left != self.nil:
#             y.left.parent = x

#         y.parent = x.parent
#         if x.parent == None:
#             self.root = y
#         elif x == x.parent.left:
#             x.parent.left = y
#         else:
#             x.parent.right = y
#         y.left = x
#         x.parent = y

#     # rotate right at node x
#     def rotate_right(self, x):
#         y = x.left
#         x.left = y.right
#         if y.right != self.nil:
#             y.right.parent = x

#         y.parent = x.parent
#         if x.parent == None:
#             self.root = y
#         elif x == x.parent.right:
#             x.parent.right = y
#         else:
#             x.parent.left = y
#         y.right = x
#         x.parent = y

#     def __repr__(self):
#         lines = []
#         print_tree(self.root, lines)
#         return "\n".join(lines)


# def print_tree(node, lines, level=0):
#     if node.val != 0:
#         print_tree(node.left, lines, level + 1)
#         lines.append(
#             "-" * 4 * level + "> " + str(node.val) + " " + ("r" if node.red else "b")
#         )
#         print_tree(node.right, lines, level + 1)


# def get_nums(num):
#     random.seed(1)
#     nums = []
#     for _ in range(num):
#         nums.append(random.randint(1, num - 1))
#     return nums
