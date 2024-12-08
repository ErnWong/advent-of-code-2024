use std::fs::read_to_string;

use itertools::Itertools;

#[derive(Clone, PartialEq, Eq, Hash, Debug)]
struct Coord(i16, i16);

fn part_a(input: String) -> usize {
    let rows: Vec<&str> = input.split('\n').collect();
    let width = rows.first().unwrap().len() as i16;
    let height = rows.len() as i16;

    let mut antennas_by_frequency = [const { Vec::<Coord>::new() };128];

    for (y, row) in rows.iter().enumerate() {
        for (x, antenna) in row.chars().enumerate().filter(|(_, frequency)| *frequency != '.') {
            antennas_by_frequency[antenna as u8 as usize].push(Coord(x as i16, y as i16));
        }
    }

    antennas_by_frequency
        .iter()
        .flat_map(|coords|
            coords
                .iter()
                .combinations(2)
                .flat_map(|pair| {
                    [
                        Coord(2 * pair[0].0 - pair[1].0, 2 * pair[0].1 - pair[1].1),
                        Coord(2 * pair[1].0 - pair[0].0, 2 * pair[1].1 - pair[0].1),
                    ]
                })
        )
        .filter(|Coord(x, y)| *x >= 0 && *y >= 0 && *x < width && *y < height)
        .unique()
        .count()
}

fn main() {
    let input = read_to_string("input.txt").unwrap();
    println!("{}", part_a(input));
}

#[test]
fn part_a_example() {
    assert_eq!(part_a("............
........0...
.....0......
.......0....
....0.......
......A.....
............
............
........A...
.........A..
............
............".into()), 14);
}