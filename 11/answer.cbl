IDENTIFICATION DIVISION.
    PROGRAM-ID. ANSWER.

ENVIRONMENT DIVISION.
    INPUT-OUTPUT SECTION.
        FILE-CONTROL.
        SELECT DIRECTIONSFILE ASSIGN TO 'input-lines.txt'
        ORGANIZATION IS LINE SEQUENTIAL.   

DATA DIVISION.
    FILE SECTION.
    FD DIRECTIONSFILE.
    01 DIRECTIONS.
        05 DIRECTION PIC X(2).
            88 VALID-DIRECTIONS VALUE 'n' 's' 'nw' 'ne' 'sw' 'se'.
    
    WORKING-STORAGE SECTION.
    01 DIR.
        05 DIRECTION PIC X(2).
    01 WS-EOF PIC A(1). 

    *> Represent hex position in axial/cube coordinates 
    *> https://www.redblobgames.com/grids/hexagons/#coordinates
    01 X PIC S9(5) VALUE 0.
    01 Y PIC S9(5) VALUE 0.
    01 Z PIC S9(5) VALUE 0.

    01 DIST PIC 9(5) VALUE 0.
    01 MAX-DIST PIC 9(5) VALUE 0.

    PROCEDURE DIVISION.
    OPEN INPUT DIRECTIONSFILE.
        PERFORM UNTIL WS-EOF='Y'
        READ DIRECTIONSFILE INTO DIR
            AT END MOVE 'Y' TO WS-EOF
            NOT AT END PERFORM Input-Loop
        END-READ
        END-PERFORM.
        CLOSE DIRECTIONSFILE.
        DISPLAY "Distance: " DIST.
        DISPLAY "Max distance: " MAX-DIST.
    STOP RUN.

    Input-Loop.
    EVALUATE DIR
    WHEN 'nw'
        SUBTRACT 1 FROM X
    WHEN 'ne'
        SUBTRACT 1 FROM Z
        ADD 1 TO X
    WHEN 'sw'
        ADD 1 TO Z
        SUBTRACT 1 FROM X
    WHEN 'se'
        ADD 1 TO X
    WHEN 'n'
        SUBTRACT 1 FROM Z
    WHEN 's'
        ADD 1 TO Z
    WHEN OTHER
        DISPLAY "UNKNOWN INPUT: " DIR
    END-EVALUATE.
    PERFORM Calculate-Path.
    IF DIST > MAX-DIST
        MOVE DIST TO MAX-DIST
    END-IF.

    Calculate-Path.
    *> Axial to cube coordinates
    COMPUTE Y = - X - Z.
    COMPUTE DIST = (FUNCTION ABS(X) + FUNCTION ABS(Y) + FUNCTION ABS(Z)) / 2.
