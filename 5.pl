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
        '$' <variable-name> <index>? '=' <expression>
    }

    multi token op(1) {
        '+' | '-'
    }

    multi token op(2) {
        '*' | '/'
    }

    rule expression {
        <expr(1)>
    }

    multi rule expr($n) {
        <expr($n + 1)>+ %% <op($n)>
    }

    multi rule expr(3) {
        | <value>
        | '(' <expression> ')'
    }

    rule index {
        '[' <value> ']'
    }

    token variable-name {
        \w+
    }

    token value {
        | '-'? \d+
        | '-'? \d+ '.' \d+
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
        use MONKEY-SEE-NO-EVAL;
        %!var{$<variable-name>} = EVAL($<expression>);
    }

    multi method assignment($/ where $<index>) {
        use MONKEY-SEE-NO-EVAL;
        %!var{$<variable-name>}[$<index><value>] = EVAL($<expression>);
    }
}

G.parse('my $a; $a = 6 + 5 * (4 - 3);', :actions(A.new));
