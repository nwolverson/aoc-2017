fn round(initial_i: usize, initial_skip: usize, list: &mut Vec<u16>, input: &[u8]) -> (usize, usize) {
    let mut i = initial_i;
    let mut skip = initial_skip;
    let len = list.len();
    for length in input.iter() {
        let length = *length as usize;
        for j in 0..length/2  {
            list.swap((i+j) % len, (i + length - 1 - j) % len);
        }
        i += length + skip;
        skip += 1;
    }
    (i, skip)
}

fn answer1() {
    let mut list : Vec<u16> = (0..256).collect();
    let lengths = vec![31,2,85,1,80,109,35,63,98,255,0,13,105,254,128,33];

    round(0, 0, &mut list, &lengths);

    println!("{}", list[0] * list[1]);
}
fn answer2() {
    let mut input : Vec<u8> = "31,2,85,1,80,109,35,63,98,255,0,13,105,254,128,33".as_bytes().to_vec();
    input.append(&mut vec![17, 31, 73, 47, 23]);
    let mut list : Vec<u16> = (0..256).collect();

    let mut counters = (0, 0);
    for _ in 0..64 {
        counters = round(counters.0, counters.1, &mut list, &input);
    }

    let hash = list.as_slice().chunks(16).map(|chunk| chunk.iter().fold(0, |acc, &x| acc ^ x ));
    for c in hash {
        print!("{:02x}", c)
    }
    print!("\n");
}

fn main() {
    answer1();
    answer2();
}