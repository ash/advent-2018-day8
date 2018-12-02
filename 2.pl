grammar G {
    rule TOP {
        <variable-declaration>* %% ';'
    }

    rule variable-declaration {
        | <scalar-declaration>
        | <array-declaration>
    }

    rule scalar-declaration {
        'my' '$' <variable-name>
    }

    rule array-declaration {
        'my' '@' <variable-name>
    }

    token variable-name {
        \w+
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
}

G.parse('my $s; my @a;', :actions(A.new));
