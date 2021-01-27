sub main {
    $x = @_[0];
    @code = split //, $x;

    @tmp = ();
    %brace = ();

    for ($pos = 0; $pos < scalar @code; $pos = $pos + 1) {
        $cmd = @code[$pos];

        if ($cmd eq "[") {
            push @tmp, $pos;
        }
        if ($cmd eq "]") {
            $start = pop @tmp;
            $brace{$start} = $pos;
            $brace{$pos} = $start;
        }
    }

    @cells = ();
    $codeptr = 0;
    $cellptr = 0;

    while ($codeptr < scalar @code) {
        $cmd = @code[$codeptr];

        if ($cmd eq ">") {
            $cellptr = $cellptr + 1;
            if ($cellptr == scalar @cells) {
                push @cells, 0;
            }
        }
        if ($cmd eq "<") {
            if ($cellptr <= 0) {
                $cellptr = 0;
            }
            else {
                $cellptr = $cellptr - 1;
            }
        }
        if ($cmd eq "+") {
            if (@cells[$cellptr] < 255) {
                @cells[$cellptr] = @cells[$cellptr] + 1;
            }
            else {
                @cells[$cellptr] = 0;
            }
        }
        if ($cmd eq "-") {
            if (@cells[$cellptr] > 0) {
                @cells[$cellptr] = @cells[$cellptr] - 1;
            }
            else {
                @cells[$cellptr] = 255;
            }
        }
        if ($cmd eq "[" && @cells[$cellptr] == 0) {
            $codeptr = $brace{$codeptr};
        }
        if ($cmd eq "]" && @cells[$cellptr] != 0) {
            $codeptr = $brace{$codeptr};
        }
        if ($cmd eq ".") {
            print chr(@cells[$cellptr]);
        }
        if ($cmd eq ",") {
            @cells[$cellptr] = ord(getc);
        }

        $codeptr++;
    }
}

$num_args = $#ARGV;
if ($num_args < 0) {
    print "\nUsage: brainfuck.pl <BrainFuck Code>\n";
    exit;
}

main($ARGV[0]);
