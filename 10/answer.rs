fn answer1() {
    let mut i = 0;
    let mut skip = 0;
    let mut list : Vec<u16> = (0..256).collect();
    let mut lengths = vec![31,2,85,1,80,109,35,63,98,255,0,13,105,254,128,33];
    lengths.reverse();

    let len = list.len();

    while let Some(length) = lengths.pop() {
        for j in 0..length/2  {
            list.swap((i+j) % len, (i + (length - 1 - j)) % len);
        }
        i += length + skip;
        skip += 1;
    }

    println!("{}", list[0] * list[1]);
}
fn answer2() {
    let mut input : Vec<u8> = "31,2,85,1,80,109,35,63,98,255,0,13,105,254,128,33".as_bytes().to_vec();
    input.append(&mut vec![17, 31, 73, 47, 23]);

    // TODO copied
    let mut i : usize = 0;
    let mut skip : usize = 0;
    let mut list : Vec<u16> = (0..256).collect();

    for _round in 0..64 {
        for input_index in 0..input.len() {
            let length = input[input_index] as usize;
            // TODO copied
            for j in 0..length/2  {
                let len = list.len();
                list.swap((i+j) % len, (i + length - 1 - j) % len);
            }
            i += length + skip;
            skip += 1;
        }
    }

    let mut hash : Vec<u16> = Vec::new();
    for chunk in list.as_slice().chunks(16) {
        hash.push(chunk.iter().fold(0, |acc, &x| acc ^ x ));
    }
    for c in hash {
        print!("{:02x}", c)
    }
    print!("\n");
}

fn main() {
    answer1();
    answer2();
}