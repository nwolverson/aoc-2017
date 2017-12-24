require 'numo/narray'
lines = File.readlines("input.txt").map {|l| l.strip.split('').map { |x| x == '#' ? 1 : 0 } }
arr = Numo::NArray[*lines]
p arr

x = arr.shape[0]/2 # 0..12..24
y = arr.shape[1]/2
dir = :up

left = {:up => :left, :left => :down, :down => :right, :right => :up}
right = left.invert

move = {
    :up => [0, -1],
    :left => [-1, 0],
    :down => [0, 1],
    :right => [1, 0]
}

infects = 0
for i in 1..10000 do
    dir = if arr[y, x] == 1 then right[dir] else left[dir] end
    arr[y, x] = if arr[y, x] == 1 then 0 else 1 end
    if arr[y, x] == 1 then
        infects = infects + 1
    end
    x += move[dir][0]
    y += move[dir][1]

    if y < 0 then
        arr = arr.insert(0, 0, axis: 0)
        y += 1
    elsif x < 0 then
        arr = arr.insert(0, 0, axis: 1)
        x += 1
    elsif y >= arr.shape[0]
        arr = arr.insert(y, 0, axis: 0)
    elsif x >= arr.shape[1]
        arr = arr.insert(x, 0, axis: 1)
    end
end

p arr
p infects