exports.answer1 = input => {
    const arr = input.split("").map(Number);
    return arr.reduce((acc, x, i) => acc + (arr[(i+1) % arr.length] === x ? x : 0), 0);
};

exports.answer2 = input => {
    const arr = input.split("").map(Number);
    return arr.reduce((acc, x, i) => acc + (arr[(i + arr.length/2) % arr.length] === x ? x : 0), 0);
};
