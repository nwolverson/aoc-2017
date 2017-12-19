package uk.nwolverson.aoc17_19;

import java.util.List;

import static java.util.Arrays.asList;

public enum Direction {
    NORTH(0, -1),
    WEST(-1, 0),
    SOUTH(0, 1),
    EAST(1, 0);

    private final int x;
    private final int y;

    Direction(int x, int y) {
        this.x = x;
        this.y = y;
    }

    public static List<Direction> turns(Direction direction) {
        switch (direction) {
            case NORTH:
            case SOUTH:
                return asList(WEST, EAST);
            default:
                return asList(NORTH, SOUTH);
        }
    }


    public int getX() {
        return x;
    }

    public int getY() {
        return y;
    }
}
