function swap(a, i, j)
    tmp = a[i]
    a[i] = a[j]
    a[j] = tmp
end

function round(i, skip, list, input)
    len = length(list)
    for input_length in input
        for j in 0:floor(Int, input_length/2)-1
            swap(list, 1+ (i+j) % length(list), 1 + (i + input_length - 1 - j) % length(list))
        end
        i += input_length + skip
        skip += 1
    end
    (i, skip)
end

# Hash function from day 10, translated to Julia...
function hash(input)
    push!(input, 17, 31, 73, 47, 23)
    data = [UInt8(0):UInt8(255);]
    (i, skip) = (0, 0)
    for j in 1:1
        (i, skip) = round(i, skip, data, input)
        if j == 0
            println(convert(Array{Int64}, data))
        end
    end
    println(reshape(data, (16,16)))
    numbers = reducedim(⊻, reshape(data, (16,16)), 1, 0)
    bytes2hex(convert(Array{UInt8}, numbers)) # For some reason this becomes Int64 on reducedim
end

# println(hash(b"31,2,85,1,80,109,35,63,98,255,0,13,105,254,128,33"))
