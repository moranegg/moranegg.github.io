require 'benchmark'

class Node
  attr_reader   :children
  attr_accessor :tag

  def initialize(terminal, tag, children = [])
    @terminal = terminal
    @tag = tag
    @children = children
  end

  def terminal?
    @terminal == true
  end
end

class Factorial
  @computed = []

  def self.fact(n)
    return 1 if n < 2
    x = 1
    (1..n).each do |i|
      next if i == 0
      x *= i
    end
    x
  end

  def self.calc(n)
    @computed[n] = fact(n) if @computed[n].nil?
    @computed[n]
  end
end

class Calc
  def self.g(n)
    n, product = n - 1, 1.0
    return 1.0 if n <= 0
    (1..n).each { |i| product *= (0.5 - i) }
    (product * (-2)**n)
  end

  def self.composition(n, length = nil)
    result = []
    a = Array.new(n + 1, 0)
    k = 1
    a[0] = 0
    a[1] = n
    while k != 0
      x = a[k - 1] + 1
      y = a[k] - 1
      k = k - 1
      while 1 <= y do
        a[k] = x
        x = 1
        y -= x
        k += 1
      end
      a[k] = x + y
      result << a[0..k]
    end
    result.keep_if { |branch| length.nil? ? branch : branch.size == length }
  end

  def self.multinomial(n, coeffs)
    product = 1
    coeffs.each { |coeff| product *= Factorial.calc(coeff) }
    Factorial.calc(n) / product
  end

  def self.compo_product(compo, n)
    total = multinomial(n, compo)
    compo.each do |i|
      total *= g(i)
    end
    total
  end

  def self.inner_sum(size, length)
    composition(size, length).map { |x| compo_product(x, size) }.reduce(:+)
  end
end

def tree_gen_rec(size)
  case size
  when 0 then raise Error('ask zero size')
  when 1 then return Node.new(true, -1)
  when 2 then return Node.new(false, -1, [Node.new(true, -1)])
  end
  random = rand(Calc.g(size) - 1)
  k = 1
  while k < size
    tmp = Calc.inner_sum(size - 1, k)
    if (random - tmp > 0)
      random -= tmp
    else
      break
    end
    k += 1
  end
  compos = Calc.composition(size - 1, k)
  i = 0
  while i < compos.size
    tmp = Calc.compo_product(compos[i], size - 1)
    if (random - tmp > 0)
      random -= tmp
    else
      break
    end
    i += 1
  end

  children = compos[i] ? compos[i].map { |w| tree_gen_rec(w) } : []
  Node.new(false, -1, children)
end

def tree_gen(size, to_tag = true)
  tree = tree_gen_rec(size)
  if to_tag
    tag_tree(tree)
  else
    tree
  end
end

def prefix_nodes(trees)
  stack = []
  while trees.size != 0
    # stack << trees.delete_at(rand(trees.size))
    stack << trees.shift
    trees += stack.last.children
  end
  stack
end

def tag_them(stack)
  i = 1
  stack.each do |node|
    node.tag = i
    i += 1
  end
end

def tag_tree(tree)
  tag_them(prefix_nodes([tree]))
  tree
end

def tree_size(tree)
  return 0 if tree.nil?
  return 1 if tree.terminal?
  return 1 if tree.children == []
  return 1 + tree.children.map { |e| tree_size(e) }.reduce(:+)
end

def tree_depth(tree)
  return 0 if tree.nil?
  return 1 if tree.terminal?
  return 1 if tree.children == []
  return 1 + tree.children.map { |e| tree_depth(e) }.max
end

def traverse_tree(fun, tree)
  fun.call(tree)
  tree.children.each do |node|
    traverse_tree(fun, node)
  end
end

def average_depth(tree)
  sum = 0
  traverse_tree(-> (node) {
    sum += tree_depth(node)
  }, tree)
  sum / tree_size(tree)
end

def gen_dot(tree, name)
  File.open(name, "w") do |file|
    file.write("digraph tree {\n")
    traverse_tree(-> (node, out = file) {
      node.children.each do |child|
        out.write("#{node.tag} -> #{child.tag};\n")
      end
    }, tree)
    file.write("}\n")
  end
end

tree = tree_gen(2)
n_times, m_times = 15, 25
real_time, depth, average_depth = Array.new(30, 0), Array.new(30, 0), Array.new(30, 0)
File.open("calcul_tag/stats.txt", "w") do |file|
  file.puts "Generating trees:"
  file.puts "Size;Real Time;Depth;Average Depth"

  (2..m_times).each do |i|
    print "Generating tree of size #{i}"

    # Sample n_times.
    n_times.times do
      print "."
      STDOUT.flush

      # Benchmark.
      results = Benchmark.measure { tree = tree_gen(i) }

      # Do stats, because it's good.
      real_time[i] += results.to_s.delete("()").split(" ")[3].to_i
      depth[i] += tree_depth(tree)
      average_depth[i] += average_depth(tree)
      tree = nil
    end

    # Make stats because it's good.
    real_time[i] /= n_times.to_f
    depth[i] /= n_times.to_f
    average_depth[i] /= n_times.to_f
    # Print stats because it's good.
    file.puts "#{i};#{real_time[i]};#{depth[i]};#{average_depth[i]}"
    file.flush
    # Because I love great printing.
    print "\r"
    60.times { print " " }
    print "\r"
  end
end

real_time, depth, average_depth = Array.new(30, 0), Array.new(30, 0), Array.new(30, 0)
File.open("calcul_no_tag/stats.txt", "w") do |file|
  file.puts "Generating trees:"
  file.puts "Size;Real Time;Depth;Average Depth"

  (2..m_times).each do |i|
    print "Generating tree of size #{i}"

    # Sample n_times.
    n_times.times do
      print "."
      STDOUT.flush

      # Benchmark.
      results = Benchmark.measure { tree = tree_gen(i, false) }

      # Do stats, because it's good.
      real_time[i] += results.to_s.delete("()").split(" ")[3].to_i
      depth[i] += tree_depth(tree)
      average_depth[i] += average_depth(tree)
      tree = nil
    end

    # Make stats because it's good.
    real_time[i] /= n_times.to_f
    depth[i] /= n_times.to_f
    average_depth[i] /= n_times.to_f
    # Print stats because it's good.
    file.puts "#{i};#{real_time[i]};#{depth[i]};#{average_depth[i]}"
    file.flush
    # Because I love great printing.
    print "\r"
    60.times { print " " }
    print "\r"
  end
end
