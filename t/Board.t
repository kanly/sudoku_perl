#!perl

use strict;
use warnings;

use Test::More;

BEGIN {
    use_ok('Sudoku::Board');
}

subtest 'constructor' => sub {
    my $inst = Sudoku::Board->new(
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
    
    isa_ok($inst, 'Sudoku::Board');
    my $ra_input = $inst->input;
    is(scalar @$ra_input, 9, 'checking input size');
    my $cells = $inst->cells;
    is(scalar @$cells, 81, 'checking cells creation');
    
    can_ok( $inst, $_ ) foreach qw[
        values_in_row
        values_in_col
        values_in_sector
        
        evaluate_sector
    ];
};

subtest 'testing evaluate_sector' => sub {
    my $inst = Sudoku::Board->new(
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
    
    is($inst->evaluate_sector(2,2), 0, 'sector of [2,2]');
    is($inst->evaluate_sector(4,2), 3, 'sector of [4,2]');
    is($inst->evaluate_sector(6,3), 7, 'sector of [6,3]');
    is($inst->evaluate_sector(6,6), 8, 'sector of [6,6]');
    is($inst->evaluate_sector(3,4), 4, 'sector of [3,4]');
    is($inst->evaluate_sector(5,6), 5, 'sector of [5,6]');
    is($inst->evaluate_sector(2,4), 1, 'sector of [2,4]');
};

subtest 'values in row' => sub {
    my $inst = Sudoku::Board->new(
        input => [
            [0,0,0,0,0,0,0,0,0],
            [0,0,0,0,0,0,0,0,0],
            [0,0,0,0,0,0,0,0,0],
            [2,0,4,3,0,0,7,0,0],
            [0,0,0,0,0,0,0,0,0],
            [0,0,0,0,0,0,0,0,0],
            [0,0,0,0,0,0,0,0,0],
            [0,0,0,0,0,0,0,0,0],
            [0,0,0,0,0,0,0,0,0],
        ],
    );
    
    is(scalar $inst->values_in_row(0), 0, 'empty row');
    is(scalar $inst->values_in_row(3), 4, 'non-empty row');
};

subtest 'values in column' => sub {
    my $inst = Sudoku::Board->new(
        input => [
            [0,0,0,1,0,0,0,0,0],
            [0,0,0,0,0,0,0,0,0],
            [0,0,0,0,0,0,0,0,0],
            [0,0,0,5,0,0,0,0,0],
            [0,0,0,0,0,0,0,0,0],
            [0,0,0,0,0,0,0,0,0],
            [0,0,0,9,0,0,0,0,0],
            [0,0,0,0,0,0,0,0,0],
            [0,0,0,3,0,0,0,0,0],
        ],
    );
    
    is(scalar $inst->values_in_col(0), 0, 'empty column');
    is(scalar $inst->values_in_col(3), 4, 'non-empty column');
};

subtest 'values in sector' => sub {
    my $inst = Sudoku::Board->new(
        input => [
            [0,0,0,0,0,0,2,0,0],
            [0,0,0,5,0,4,0,0,0],
            [0,0,1,0,7,0,0,0,0],
            [0,0,0,0,0,0,0,0,0],
            [0,0,0,0,0,0,0,0,0],
            [0,0,0,0,0,0,0,0,0],
            [0,0,0,0,0,0,0,0,0],
            [0,0,0,0,0,0,0,0,0],
            [0,0,0,0,0,0,0,0,0],
        ],
    );
    
    is(scalar $inst->values_in_sector(5), 0, 'empty sector');
    is(scalar $inst->values_in_sector(1), 3, 'non-empty sector');
};

done_testing;