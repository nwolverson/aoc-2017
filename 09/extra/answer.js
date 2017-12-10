const count = (input) => {
    let total = 0;
    let depth = 0;
    let garbage = false;
    let garbageTotal = 0;
    for (let i = 0; i < input.length; ++i) {
        if (input[i] == '!') {
            i++;
        } else if (garbage) {
            if (input[i] == '>') {
                garbage = false;
            } else  {
                garbageTotal++;
            }
        } else if (input[i] == '<') {
            garbage = true;
        } else if (input[i] == '{') {
            depth++;
        } else if (input[i] == '}') {
            total += depth;
            depth--;
        }
    }
    console.log(total, depth, garbage, garbageTotal);
}
var text = require('fs').readFileSync('input.txt', 'utf8');
count(text);