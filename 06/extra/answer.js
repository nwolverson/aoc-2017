var input = "14	0	15	12	11	11	3	5	1	6	8	4	9	1	8	4".split("\t").map(x => parseInt(x, 0));

const eq = (x, y) => x.length === y.length && x.every((n, i) => y[i] === n);

function cyc(banks){ 
    banks = banks.slice();
    var i = banks.indexOf(banks.slice().sort((a,b) => b-a)[0]);
    var n = banks[i]; 
    banks[i] = 0;
    while (n > 0) {
        i = (i + 1) % banks.length;
        banks[i]++;
        n--;
    }
    return banks;
}

const answer = input => {
    var seen = []; 
    
    var cycles = 0;
    var current = input;
    for (var i = 0; !seen.some(x => eq(x,current)); i++) {
        seen.push(current);
        current = cyc(current);
    }

    return {
        cycles: i,
        count: seen.length - seen.findIndex(x => eq(x, current))
    }
}
    
const answer1 = input => answer(input).cycles;
const answer2 = input => answer(input).count;
