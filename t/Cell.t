#!perl

use strict;
use warnings;

use Test::More;

BEGIN {
    use_ok('Sudoku::Cell');
    use_ok('Sudoku::Board');
}

subtest 'constructor' => sub {
    
    
    my $inst = Sudoku::Cell->new (
        board => empty_board(),
        row   => 3,
        col   => 5,
    );
    
    isa_ok($inst, 'Sudoku::Cell');
    
    is($inst->row, 3, 'checking row value');
    is($inst->col, 5, 'checking col value');
    
    can_ok($inst, $_) foreach qw[
        evaluate_sector
        
        remaining_values
    ];
};

sub empty_board {
    return Sudoku::Board->new(
        input => [
            [0,0,0,0,0,0,0,0,0],
            [0,0,0,0,0,0,0,0,0],
            [0,0,0,0,0,0,0,0,0],
            [0,0,0,0,0,0,0,0,0],
            [0,0,0,0,0,0,0,0,0],
            [0,0,0,0,0,0,0,0,0],
            [0,0,0,0,0,0,0,0,0],
            [0,0,0,0,0,0,0,0,0],
            [0,0,0,0,0,0,0,0,0],
        ],
    );
}

done_testing;