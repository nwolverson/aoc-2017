#!/usr/bin/perl
$max_during = -10000;
while ($line = <STDIN>) {
    if ($line =~ /([a-z]+) (inc|dec) ([-0-9]+) if ([a-z]+) ([!><=]+) ([-0-9]+)/) {
        $var1 = $1, $var2 = $4, $isInc = $2 eq 'inc' ? 1 : -1, $inc = $3, $cond = $5, $testVal = $6;
        $vars{$var1} = 0 if !$vars{$var1};
        $vars{$var2} = 0 if !$vars{$var2};
        if ($cond eq '<') {
            $test = $vars{$var2} < $testVal;
        } elsif ($cond eq '<=') {
            $test = $vars{$var2} <= $testVal;
        } elsif ($cond eq '==') {
            $test = $vars{$var2} == $testVal;
        } elsif ($cond eq '>') {
            $test = $vars{$var2} > $testVal;
        } elsif ($cond eq '>=') {
            $test = $vars{$var2} >= $testVal;
        } elsif ($cond eq '!=') {
            $test = $vars{$var2} != $testVal;
        }
        if ($test) {
            $vars{$var1} += $isInc * $inc if $test;
            $max_during = $vars{$var1} if $vars{$var1} > $max_during;
        }
    } else {
        die "Couldn't parse $line";
    }
}

$max = -10000;
while (($var, $val) = each %vars) {
    $max = $val if $val > $max;
}
print "$max\n";
print "$max_during\n";