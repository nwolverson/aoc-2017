local edges = {}
for line in io.lines() do
    local node, links = string.match(line, "(%d+) <%-> (.+)")
    if node then
        local newlinks = {}
        for link in string.gmatch(links, "%d+") do
            table.insert(newlinks, link)
        end
        edges[node] = newlinks
    end
end

function findReachable(start)
    local reachable = {}
    function reach (node)
        if not reachable[node] then
            reachable[node] = true
            if edges[node] then
                for _, childNode in pairs(edges[node]) do
                    reach(childNode)
                end
            end
        end
    end
    reach(start)
    return reachable
end

function size(group)
    local i = 0
    for _ in pairs(group) do
        i = i + 1
    end
    return i
end

-- Part 1
print(size(findReachable("0")))

-- Part 2
local groups, reachables = 0, {}
for k in pairs(edges) do
    if not reachables[k] then
        for e in pairs(findReachable(k)) do
            reachables[e] = true
        end
        groups = groups + 1
    end
end
print(groups)

