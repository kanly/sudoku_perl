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
        solve

        try_with_possible_values 		try_with_possible_values_in_sector
        try_with_possible_values_in_col try_with_possible_values_in_row
    ];
};

subtest 'remaing_values' => sub {
    my $board = Sudoku::Board->new(
        input => [
            [0,0,0,0,3,0,0,0,0],
            [0,0,0,0,0,0,0,0,0],
            [0,1,0,0,0,0,6,0,0],
            [0,0,0,0,0,0,0,0,0],
            [0,0,0,0,5,0,0,0,0],
            [0,0,0,0,0,0,0,0,0],
            [0,0,0,0,0,0,0,0,0],
            [0,0,0,0,2,0,0,0,0],
            [0,0,0,0,0,0,0,0,0],
        ],
    );
    #2,4
    my $cell = get_cell($board, 2, 4);
    my @remaining_values = $cell->remaining_values();
    is(scalar @remaining_values, 4, "there should be 4 remaining values");
    is_deeply(\@remaining_values, [4,7,8,9], "remaining values should be (4,7,8,9)");
};

subtest 'try_with_possible_values' => sub {
    my $board = empty_board();
    my $cell = get_cell($board, 0, 0);

    my $result = $cell->try_with_possible_values(
        other_poss_values	=> {3=>1, 5=>undef},
        rem_values 			=> [4,5,6,1]
    );

    is($result, undef, "No result should have been found");

    $result = $cell->try_with_possible_values(
        other_poss_values	=> {3=>1, 5=>undef},
        rem_values 			=> [3,5,1],
    );

    is($result, 1, "Result should be 1");
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

sub get_cell {
    my ($board, $row, $col) = @_;
    return (grep { $_->row==$row && $_->col==$col } @{$board->cells})[0];
}

done_testing;