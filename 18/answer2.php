<?
    function val($variables, $var) {
        if (is_numeric($var)) {
            return 0+$var;
        }
        return 0+$variables[$var];
    }

    function simulate($instr, &$pc, &$variables, &$rq, &$sq, &$send_count) {
        while ($pc >= 0 && $pc < count($instr)) {
            $cmd = $instr[$pc];
            $x = val($variables, $cmd[1]);
            $y = val($variables, $cmd[2]);
            $pc++;
            switch ($cmd[0]) {
                case 'snd':
                    $send_count++;
                    array_push($sq, $x);
                    // echo "send\n";
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
                    if (count($rq) > 0) {
                        $variables[$cmd[1]] = array_shift($rq);
                    } else {
                        $pc--;
                        return true; // Blocked
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
        echo "TERMINATED\n";
        return false;
    }

    $instr = array();
    while (($line = fgets(STDIN)) !== false) {
        $line = trim($line);
        $cmd = split(" ", $line);
        array_push($instr, $cmd);
    }

    $pc = array(0, 0);
    $variables = array(array(
        p => 0
    ), array(
        p => 1
    ));
    $queue = array(array(), array());

    $sends = array(0, 0);
    $blocks = array(true, true);
    do {
        $lp = $pc;
        $blocks[0] = simulate($instr, $pc[0], $variables[0], $queue[0], $queue[1], $sends[0]);
        $blocks[1] = simulate($instr, $pc[1], $variables[1], $queue[1], $queue[0], $sends[1]);
    } while (
        ($blocks[0] && count($queue[0]) > 0)
        || ($blocks[1] && count($queue[1]) > 0)
    );
    echo "$sends[1]\n";
?>