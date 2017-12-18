<?
    $instr = array();
    while (($line = fgets(STDIN)) !== false) {
        $line = trim($line);
        $cmd = split(" ", $line);
        array_push($instr, $cmd);
    }

    $pc = 0;
    $variables = array();
    $last_snd = FALSE;

    function val($variables, $var) {
        if (is_numeric($var)) {
            return 0+$var;
        }
        return 0+$variables[$var];
    }

    while ($pc >= 0 && $pc < count($instr)) {
        $cmd = $instr[$pc];
        $x = val($variables, $cmd[1]);
        $y = val($variables, $cmd[2]);
        $pc++;
        switch ($cmd[0]) {
            case 'snd':
                echo "BEEP ", $x, "\n";
                $last_snd = $x;
                break;
            case 'set':
                $variables[$cmd[1]] = $y;
                break;
            case 'add':
                $variables[$cmd[1]] += $y;
                break;
            case 'mul':
                $variables[$cmd[1]] *= $y;
                break;
            case 'mod':
                $variables[$cmd[1]] = $x % $y;
                break;
            case 'rcv':
                if ($x != 0) {
                    echo "RECOVER ", $last_snd, "\n";
                    exit(1);
                }
                break;
            case 'jgz':
                if ($x > 0) {
                    $pc += $y - 1;
                }
                break;
            default:
                echo "UNKNOWN INSTRUCTION ", $cmd[0];
                exit(0);
                break;
        }
    }
?>