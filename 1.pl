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

    method variable-declaration($/) {
        if $<scalar-declaration> {
            %!var{$<scalar-declaration><variable-name>} = 0;
        }
        elsif $<array-declaration> {
            %!var{$<array-declaration><variable-name>} = [];
        }
    }
}

G.parse('my $s; my @a;', :actions(A.new));
