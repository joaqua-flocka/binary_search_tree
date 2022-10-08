# binary_search_tree

BST built as part of the curriculum for The Odin Project.\n
Methods:\n
#build_tree
  -Accepts array of values, returns root node of BST
#insert
  -Accepts a value to insert into BST
#delete
  -Accepts a value to delete from BST, prints error if value doesn't exist in BST
#find
  -Accepts a value and returns corresponding node from the tree. Returns nil if value not found
#level_order
  -Accepts a block, yields nodes to block in level order. Returns array in level order if block
  not given
#preorder
  -Accepts a block, yields nodes to block in preorder. Returns array in preorder if block
  not given
#inorder
  -Accepts a block, yields nodes to block in order. Returns array in order if block
  not given
#postorder
  -Accepts a block, yields nodes to block in postorder. Returns array in postorder if block
  not given
#height
  -Accepts a node, returns height as an integer value
#depth
  -Accepts a node, returns depths as an integer value
#balanced?
  -Returns true if tree is balanced, else returns false
#rebalance
  -Balances an unbalanced BST