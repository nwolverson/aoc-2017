module.exports = input => {
    const arr = input.split("").map(Number);
    return arr.reduce((acc, x, i) => acc + (arr[(i+1) % arr.length] === x ? x : 0), 0);
};