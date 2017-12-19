package uk.nwolverson.aoc17_19;

import java.io.FileInputStream;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.Scanner;
import java.util.stream.Collectors;

import static uk.nwolverson.aoc17_19.Direction.SOUTH;

public class Main {
    static class Position {
        final int x;
        final int y;

        Position(int x, int y) {
            this.x = x;
            this.y = y;
        }

        public Position add(Direction d) {
            return new Position(x + d.getX(), y+ d.getY());
        }
    }

    static class Input {
        static ArrayList<String> map = new ArrayList<>();

        public void load(String fileName) throws IOException {
            try (FileInputStream stream = new FileInputStream(fileName);
                 Scanner input = new Scanner(stream)) {
                while (input.hasNext()) {
                    map.add(input.nextLine());
                }
            }
        }

        public Optional<Character> get(Position p) {
            if (p.y >= 0 && p.y < map.size() && p.x >= 0 && p.x < map.get(p.y).length()) {
                return Optional.of(map.get(p.y).charAt(p.x));
            }
            return Optional.empty();
        }

        public Position start() {
            return new Position(0, map.get(0).indexOf('|'));
        }
    }

    public static void main(String[] args) throws IOException {
        Input input = new Input();
        input.load("input.txt");

        List<Character> letters = new ArrayList<>();
        Direction direction = SOUTH;

        Position pos = input.start();
        int steps;
        for (steps = 0; input.get(pos).filter(c -> c != ' ').isPresent(); steps++) {
            char currentChar = input.get(pos).get();
            switch (currentChar) {
                case '+':
                    for (Direction newDir : Direction.turns(direction)) {
                        if (input.get(pos.add(newDir)).filter(c -> c != ' ').isPresent()) {
                            direction = newDir;
                        }
                    }
                    break;
                case '|':
                case '-':
                    break; // continue in same direction
                default:
                    letters.add(currentChar);
            }
        }

        System.out.println(letters.stream().map(String::valueOf).collect(Collectors.joining()));
        System.out.println(steps);
    }
}
