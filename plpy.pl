#!/usr/bin/perl -w

# written by z5060165@cse.unsw.edu.au September 2016

use Switch 'fallthrough';
use List::MoreUtils qw(uniq);

my %variables = ();
my (@lines, @imports) = ();
my $hash_bang_flag = 0;

# highest priority
while ($line = <>) {
    check_import($line);
    if ($line =~ /^#!/ and !$hash_bang_flag) {
        print "#!/usr/local/bin/python3.5 -u\n" if $. == 1; $hash_bang_flag = 1; next;
    }
    $line =~ s/<STDIN>/STDIN/g;
    if ($line =~ /join.*,.*/) { $line = convert_join($line); }
    push @lines, $line;
    if (eof) {
        print "import ", join(', ', uniq(@imports)), "\n" if (scalar @imports > 0);
        last;
    }
}

foreach $line (@lines) {

    # Simple substitution
    translate($line);
    # Creating variables for python does not require "$" and ";"
    add_variable($line) if ($line =~ /^\s*(\$|@)/ and $line =~ /;$/);
    # Python's print adds a new-line character by default
    # so we need to delete it from the Perl print statement
    if ($line =~ /^\s*print\s*"(.*)\\n"[\s;]*$/) { convert_print($1, get_space_count($line), 1); }
    elsif ($line =~ /^\s*print.*$/) { convert_print_advanced($line); }
    # translate #! line 
    elsif ($line =~ /^\s*#/ || $line =~ /^\s*$/) { print $line; }
    else {
        switch ($line) {
            # Closed bracket are not included in python for if/while statements
            case (/^\s*}/) { convert_closed_brackets($line) }
            # If and while statements in python rely on denting
            case (/^\s*(if|while).*/) { convert_if_while($line) }
            # else statement in python ends with ":"
            case (/^\s*.*else.*/) { convert_else($line) }
            case (/^\s*.*elsif.*/) { convert_elsif($line) }
            case (/^\s*for.*/) { convert_for($line) }
            case (/^\s*chomp.*/) { convert_chomp($line) }
            case (/^\s*exit\(.*\)/) { convert_exit($line) }
            case (/^\s*push/) { convert_push($line) }
            case (/^\s*pop/) { convert_pop($line) }
        }
    }
}

sub convert_push {
    $line = shift;
    $line =~ /push.*@(.*)\s*,\s*\$(.*)\s*;$/;
    for ($i = 0; $i < get_space_count($line); $i++) { print " "; }
    print "$1.append($2)\n"
}

sub convert_pop {
    $line = shift;
    $line =~ /pop.*@(.*)\s*;$/;
    for ($i = 0; $i < get_space_count($line); $i++) { print " "; }
    print "$1.pop()\n"
}

sub convert_exit {
    $line = shift;
    $line =~ s/exit/sys.exit/g;
    print "$line\n";
}

sub is_numeric {
    $var = shift;
    foreach $line (@lines) {
        if ($line =~ /\$$var/ and $line =~ /\s+(eq|ne|cmp|lt|le|gt|ge)\s+/) {
            return 0;
        }
    }
    return 1;
}

sub check_import {
    $line = shift;
    push @imports, "sys" if (!($line =~ /\\n/) and $line =~ /^\s*print/);
    push @imports, "sys" if (($line =~ /STDIN/ || $line =~ /ARGV/ || $line =~ /^\s*exit(.*)/));
    push @imports, "fileinput" if ($line =~ /<>/);
    push @imports, "re" if ($line =~ /s\/.*\//);
}

sub translate {
    $line = shift;
    if ($line =~ /last;/) { $line =~ s/last;/break/g; print $line; }
}

sub convert_array {
    $line = shift;   
    if ($line =~ /@\w+.*../) { $line =~ s/\.\./:/g; $line =~ s/@//g; }
    return $line;
}

sub convert_print {
    $line = shift;
    $space_count = shift;
    $new_line = shift;
    $line_unchanged = $line;
    $line =~ s/\$//g;
    $line = convert_argv($line);
    $line = convert_array($line);
    $var = $variables{$line};
    $variable_flag = 0; # check if var is numeric
    if (!$var) {
        $var = convert_variable($line_unchanged);
        $line =~ s/\$//g;
        $variable_flag = 1;
    }
    $var =~ s/(\+|\*|\-| |\/|%)//g;
    for ($i = 0; $i < $space_count; $i++) { print " "; }
    if ($new_line) { print "print(" } else { print "sys.stdout.write("; }
    if ((!$variable_flag && $var eq 1) || $line =~ /\.join.*/ || $var =~ /^-?\d+\.?\d*$/) {
        print "$line)\n";
    } else {
        if ($line_unchanged =~ /\$\w*/) { # has variables and strings
            @var_list = ($line_unchanged =~ /\$\w*/g);
            for (@var_list) { s/\$//g }
            $line_unchanged =~ s/\$\w*/\%s/g;
            print "\"$line_unchanged\" \% (", join(', ', @var_list), "))\n";
            return;
        }
        print "\"$line\")\n";
    }
}

sub convert_print_advanced {
    $line = shift;
    $space_count = get_space_count($line);
    if ($line =~ /\\n/) { $new_line = 1; } else { $new_line = 0; }
    $line =~ s/(,\s*\"|"|^\s*printf\s*|^\s*print\s*|^\s*|\\n|\n|;$)//g;
    convert_print($line, $space_count, $new_line);
}

sub add_variable {
    $line = shift;
    $space_count = get_space_count($line);
    # array conversion
    if ($line =~ /\s*@\w+/) {
        $line =~ tr/\(\)/\[\]/;
    }
    $line =~ s/(\$|@|~)//g;
    $line =~ s/;//g;
    if ($line =~ /s\/.*\//) { $line = convert_substitution($line); return; }
    $line =~ s/^\s*//g;
    @line_split = split(/ /, $line);
    $var_name = $line_split[0];
    if ($line =~ /\w*\+\+/) { $line =~ s/\+\+/ \+\= 1/g; force_add_variable($var_name) }
    if ($line =~ /\w*\-\-/) { $line =~ s/\-\-/ \-\= 1/g; force_add_variable($var_name) }
    chomp @line_split;
    if (!(exists $variables{$var_name})) {
        for ($i = 0; $i < scalar @line_split; $i++) {
            foreach $s (keys %variables) {
                if (index($line_split[$i], $s) != -1) { # check if $s is a substring
                    $line_split[$i] = $variables{$s};
                }
            }
        }         
        splice @line_split, 0, 2;
        $variables{$var_name} = join(' ', @line_split);
    }
    if ($line =~ /STDIN/) {
        if (!is_numeric($var_name)) { $line =~ s/STDIN/sys.stdin.readline()/g; }
        else { $line =~ s/STDIN/float(sys.stdin.readline())/g; }
    }
    for ($i = 0; $i < $space_count; $i++) { print " "; }
    print "$line"; 
}

sub force_add_variable {
    $var_name = shift;
    $variables{$var_name} = 1; # default
}

sub convert_substitution {
    $line = shift;
    $space_count = get_space_count($line);
    $line =~ s/(^\s*|\n)//g;
    @line_split = split(/ /, $line);
    @sub_split = split (/\//, $line_split[2]);
    for ($i = 0; $i < $space_count; $i++) { print " "; }
    print "$line_split[0] = re.sub\(r\'$sub_split[1]\', \'$sub_split[2]\', $line_split[0]\)\n";
    force_add_variable($line_split[0]);
}

sub convert_argv {
    $line = shift;
    if (!($line =~ /ARGV\[/)) { return $line; }
    $line =~ s/ARGV/sys\.argv/g;
    $line =~ s/]/ \+ 1]/g;
    force_add_variable($line);
    return $line; # for conversion in print
}

sub convert_variable {
    $line = shift;
    $line =~ s/ARGV/sys.argv[1:]/g;
    @line_split = split(/\$/, $line);
    for ($i = 0; $i < scalar @line_split; $i++) {
        foreach $s (keys %variables) {
            if (index($line_split[$i], $s) != -1) { # check if $s is a substring
                $line_split[$i] =~ s/$s/$variables{$s}/ee;
            }
        }
    }
    return join(' ', @line_split); # for conversion in print
}

sub convert_if_while {
    $line = shift;
    $space_count = get_space_count($line);
    $line =~ s/(^\s*|\$|\n)//g;
    $line =~ s/\s*\(/ /g;
    $line =~ s/\s*\)\s*{/:/g;
    $line =~ s/ eq / == /g;
    $line =~ s/ ne / <> /g;
    if ($line =~ /<>/) {
        $line =~ s/while/for/g;
        $line =~ s/=/in/g;
        $line =~ s/<>/fileinput.input()/g;
    }
    if ($line =~ /STDIN/) {
        $line =~ s/while/for/g;
        $line =~ s/=/in/g;
        $line =~ s/STDIN/sys.stdin/g;
    }
    for ($i = 0; $i < $space_count; $i++) { print " "; }
    print "$line\n";
}

sub convert_for {
    $line = shift;
    $line =~ s/(\(|\)|\$|\n|\s*{)//g;
    $line =~ s/\@ARGV/sys.argv[1:]/g;
    @line_split = split(/ /, $line);
    switch ($line) {
        case (/foreach/) {
            force_add_variable($line_split[1]);
            if ($line_split[2] =~ /\.\./) {
                @range = split(/\.\./, $line_split[2]);
                if ($range[1] eq "#ARGV") {
                    print "for $line_split[1] in range(len(sys.argv) - @{[$range[0] + 1]}):\n";
                } else { print "for $line_split[1] in range($range[0], @{[$range[1] + 1]}):\n"; }           
            } else { print "for $line_split[1] in $line_split[2]:\n"; }
        }
    }
}

sub convert_else {
    $line = shift;
    $line =~ s/(}\s*|\n)//g;
    $line =~ s/\s*{/:/g;
    print "$line\n";
}

sub convert_elsif {
    $line = shift;
    $line =~ s/(}\s*|\$|\n|\))//g;
    $line =~ s/\s*\(/ /g;
    $line =~ s/elsif/elif/g;
    $line =~ s/\s*{/:/g;
    print "$line\n";
}

sub convert_closed_brackets {
    # do nothing
}

sub get_space_count {
    $line = shift;
    $line =~ /^(\s*)/;
    return length $1;
}

sub convert_chomp {
    $line = shift;
    $space_count = get_space_count($line);
    $line =~ s/(^\s*|\$|;|\n)//g;
    @line_split = split(/ /, $line);
    for ($i = 0; $i < $space_count; $i++) { print " "; }
    print "$line_split[1] = $line_split[1].rstrip()\n";
}

sub convert_join {
    $line = shift;
    $line =~ tr/\//'/;
    (@split) = $line =~ /(.*)join.*'(.*)',\s*(.*)/;
    for (@split) { s/(\$|;|\(|\)|join)//g; }
    $split[2] = convert_array($split[2]);
    return "$split[0]'$split[1]'.join(map(str, $split[2]))";
}