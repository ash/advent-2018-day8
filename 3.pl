grammar G {
    rule TOP {
        [
            | <variable-declaration>
            | <assignment>
        ]
        * %% ';'
    }

    rule variable-declaration {
        'my' [
            | <scalar-declaration>
            | <array-declaration>
        ]
    }

    rule scalar-declaration {
        '$' <variable-name>
    }

    rule array-declaration {
        '@' <variable-name>
    }

    rule assignment {
        '$' <variable-name> <index>? '=' <value>
    }

    rule index {
        '[' <value> ']'
    }

    token variable-name {
        \w+
    }

    token value {
        \d+
    }
}

class A {
    has %!var;

    method TOP($/) {
        dd %!var;
    }

    method scalar-declaration($/) {
        %!var{$<variable-name>} = 0;
    }

    method array-declaration($/) {
        %!var{$<variable-name>} = [];
    }

    multi method assignment($/ where !$<index>) {
        %!var{$<variable-name>} = +$<value>;
    }

    multi method assignment($/ where $<index>) {
        %!var{$<variable-name>}[$<index><value>] = +$<value>;
    }
}

G.parse('my $s; my @a; $s = 3; $a[1] = 4', :actions(A.new));
