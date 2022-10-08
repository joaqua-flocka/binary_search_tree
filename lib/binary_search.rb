
class Node
  include Comparable
  attr_accessor :value, :left_child, :right_child
  def initialize(value , left_child = nil, right_child = nil)
    @value = value
    @left_child = left_child
    @right_child = right_child
  end

  def is_leaf
    if @left_child == nil && @right_child == nil
      true
    else
      false
    end
  end

  def one_child
    if @left_child == nil && @right_child != nil
      return @right_child
    elsif @right_child == nil && @left_child != nil
      return @left_child
    else
      return nil
    end
  end
end

class Tree
  attr_accessor :root
  def initialize(array)
    array = array.uniq.sort
    @root = build_tree(array, 0, array.length - 1)
  end

  def build_tree(array, start, finish)
    return nil if start > finish
    middle = (finish + start)/2
    root = Node.new(array[middle])
    root.left_child = build_tree(array, start, middle - 1)
    root.right_child = build_tree(array, middle + 1, finish)
    return root
  end

  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right_child, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right_child
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.value}"
    pretty_print(node.left_child, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left_child
  end

  def insert(value)
    tmp = @root
    node = Node.new(value)
    placed = false
    while placed == false
      if value < tmp.value
        if tmp.left_child == nil
          tmp.left_child = node
          placed = true
        else
          tmp = tmp.left_child
        end
      else
        if tmp.right_child == nil
          tmp.right_child = node
          placed = true
        else
          tmp = tmp.right_child
        end
      end
    end
  end

  def find(value)
    tmp = @root
    until tmp == nil || tmp.value == value
      if value < tmp.value
        tmp = tmp.left_child
      else
        tmp = tmp.right_child
      end
    end
    tmp
  end

  def delete(value)
    tmp = @root
    node = nil
    is_left = false
    found = false
    until found == true || tmp == nil
      if @root.value == value
        node = tmp
        break
      elsif @root.left_child.value == value
        node = @root.left_child
        break
      elsif @root.right_child.value == value
        node = @root.right_child
        break
      elsif value < tmp.value
        tmp = tmp.left_child
        if tmp.left_child != nil && tmp.left_child.value == value
          node = tmp.left_child
          is_left = true
          found = true
        elsif tmp.right_child != nil && tmp.right_child.value == value
          node = tmp.right_child
          found = true
        end
      else
        tmp = tmp.right_child
        if tmp.left_child != nil && tmp.left_child.value == value
          node = tmp.left_child
          is_left = true
          found = true
        elsif tmp.right_child != nil && tmp.right_child.value == value
          node = tmp.right_child
          found = true
        end
      end
    end
    if tmp == nil
      puts 'Can\'t delete nonexistent value'
      return
    elsif node.is_leaf
      if is_left
        tmp.left_child = nil
      else
        tmp.right_child = nil
      end
    elsif node.one_child != nil
      if is_left
        tmp.left_child = node.one_child
      else
        tmp.right_child = node.one_child
      end
    else
      arr = []
      queue = [node]
      until queue.empty?
        current = queue.shift
        next if current == nil
        puts current.value
        queue.push current.left_child
        queue.push current.right_child
        arr.push current.value
      end
      arr.sort!
      idx = arr.index(value)
      puts idx
      delete(arr[idx + 1])
      node.value = arr[idx + 1]
    end
  end

  def level_order(&code)
    tmp = @root
    queue = [tmp]
    arr = []
    until queue.empty?
      current = queue.shift
      next if current == nil
      queue.push current.left_child, current.right_child
      code.call(current) unless code == nil
      arr.push current.value
    end
    return arr if code == nil
  end

  def inorder(&code)
    stack = []
    tmp = @root
    arr = []
    while tmp != nil || !stack.empty?
      if tmp != nil
        stack.push tmp
        tmp = tmp.left_child
      else
        tmp = stack.pop
        if code != nil
          code.call(tmp)
        else
          arr.push tmp.value
        end
        tmp = tmp.right_child
      end
    end
    return arr if code == nil
  end

  def preorder(&code)
    tmp = @root
    stack = []
    arr = []
    while tmp != nil || !stack.empty?
      if tmp != nil
        stack.push tmp
        if code != nil
          code.call(tmp)
        else
          arr.push tmp.value
        end
        tmp = tmp.left_child
      else
        tmp = stack.pop.right_child
      end
    end
    return arr if code == nil
  end

  def postorder(&code)
    tmp = @root
    stack = []
    arr = []
    last_visited = nil
    while (tmp != nil || !stack.empty?)
      if tmp != nil
        stack.push tmp
        tmp = tmp.left_child
      else
        stack.pop if stack.last == last_visited
        if stack.last.right_child == nil || stack.last.right_child == last_visited
          tmp = stack.pop
          if code != nil
            code.call tmp
          else
            arr.push tmp.value
          end
          last_visited = tmp
          tmp = nil
        else
          tmp = stack.last.right_child
        end
      end
    end
    return arr if code == nil
  end

  def height(node)
    nodes = {node.value => [0, nil]}
    tmp = node
    queue = [tmp]
    while !queue.empty?
      if tmp != nil
        nodes[tmp.left_child.value] = [nodes[tmp.value][0] + 1, tmp] unless tmp.left_child == nil
        nodes[tmp.right_child.value] = [nodes[tmp.value][0] + 1, tmp] unless tmp.right_child == nil
        queue.push tmp.left_child unless tmp.left_child == nil# || nodes.has_key?(tmp.left_child.value)
        queue.push tmp.right_child unless tmp.right_child == nil# || nodes.has_key?(tmp.right_child.value)
        tmp = queue.pop
      else
        tmp = queue.pop
      end
    end
    max = 0
    nodes.each_key do |k|
      if nodes[k][0] > max
        max = nodes[k][0]
      end
    end
    max
  end

  def depth(node)
    tmp = @root
    count = 0
    until tmp.value == node.value
      if node.value < tmp.value
        tmp = tmp.left_child
      else
        tmp = tmp.right_child
      end
      count += 1
    end
    count
  end

  def balanced?
    tmp = @root
    stack = [tmp]

    until stack.empty?
      tmp = stack.pop
      if tmp.is_leaf
        next
      elsif tmp.left_child == nil
        return false if height(tmp.right_child) >= 1
      elsif tmp.right_child == nil
        return false if height(tmp.left_child) >= 1
      else
        difference = height(tmp.left_child) - height(tmp.right_child)
        return false if difference.abs > 1
        stack.push tmp.left_child unless tmp.left_child == nil
        stack.push tmp.right_child unless tmp.right_child == nil
      end
    end
    true
  end

  def rebalance
    arr = inorder
    arr = arr.uniq.sort
    @root = build_tree(arr, 0, arr.length - 1)
  end
end

#Driver script

arr = Array.new(20) { rand(1..100) }
puts arr

tree = Tree.new(arr)
puts "Initial array: "
p arr.uniq.sort
puts "\nInitial tree:\n"
tree.pretty_print
puts "\nTree balanced?: #{tree.balanced?}\n"
puts "\nLevel order: \n"
p tree.level_order
puts "\nPreorder Traversal: \n"
p tree.preorder
puts "\nInorder Traversal: \n"
p tree.inorder
puts "\nPostorder Traversal: \n"
p tree.postorder

arr = Array.new(15) { rand(100..200) }
arr.each { |i| tree.insert i }

puts "\nInserting elements: #{arr.inspect}\n"
tree.pretty_print
puts "\nTree balanced?: #{tree.balanced?}\n"
puts "\nRebalancing...\n"
tree.rebalance
tree.pretty_print
puts "\nTree balanced?: #{tree.balanced?}\n"
puts "\nLevel order: \n"
p tree.level_order
puts "\nPreorder Traversal: \n"
p tree.preorder
puts "\nInorder Traversal: \n"
p tree.inorder
puts "\nPostorder Traversal: \n"
p tree.postorder