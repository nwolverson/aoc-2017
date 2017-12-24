require 'numo/narray'
lines = File.readlines("input.txt").map {|l| l.strip.split('').map { |x| x == '#' ? :infected : :clean } }
arr = Numo::NArray[*lines]

def decide(dir, node, left, right)
    dir = if node == :infected then right[dir] else left[dir] end
    updated = if node == :infected then :clean else :infected end
    [dir, updated]
end

def decide2(dir, node, left, right)
    opp = {:up => :down, :left => :right, :down => :up, :right => :left}

    updated = if node == :clean then
        :weakened
    elsif node == :weakened then
        :infected
    elsif node == :infected then
        :flagged
    elsif node == :flagged then
        :clean
    else
        raise ("bad node: " + node.to_s)
    end
    dir = if node == :clean then
        left[dir]
    elsif node == :weakened then
        dir
    elsif node == :infected then
        right[dir]
    elsif node == :flagged then
        opp[dir]
    else
        raise ("bad node: " + node.to_s)
    end
    [dir, updated]
end

left = {:up => :left, :left => :down, :down => :right, :right => :up}
right = left.invert

def answer(arr, n, &decider)
    x = arr.shape[0]/2 # 0..12..24
    y = arr.shape[1]/2
    dir = :up

    move = {
        :up => [0, -1],
        :left => [-1, 0],
        :down => [0, 1],
        :right => [1, 0]
    }

    infects = 0
    for i in 1..n do
        dir, updated = yield(dir, arr[y,x])
        arr[y,x] = updated
        if updated == :infected then
            infects = infects+1
        end
        x += move[dir][0]
        y += move[dir][1]

        if y < 0 then
            arr = arr.insert(0, [:clean], axis: 0)
            y += 1
        elsif x < 0 then
            arr = arr.insert(0, [:clean], axis: 1)
            x += 1
        elsif y >= arr.shape[0]
            arr = arr.insert(y, [:clean], axis: 0)
        elsif x >= arr.shape[1]
            arr = arr.insert(x, [:clean], axis: 1)
        end
    end
    infects
end

# Part 1
p answer(arr, 10000) { |dir, node| decide(dir, node, left, right) }

# Part 2
p answer(arr, 10000000) { |dir, node| decide2(dir, node, left, right) }
