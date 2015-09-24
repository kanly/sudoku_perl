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

subtest 'other possible values in' => sub {
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

    my $cell4 = @{$inst->cells}[4];
    my %other_poss_val_sec1 = $inst->other_possible_values_in(
        requesting_cell    => $cell4,
        predicate          => $inst->can('is_empty_and_in_same_sector'),
    );

    ok(exists $other_poss_val_sec1{1}, "1 in sec1");
    ok(exists $other_poss_val_sec1{2}, "2 in sec1");
    ok(exists $other_poss_val_sec1{3}, "3 in sec1");
    ok(exists $other_poss_val_sec1{6}, "6 in sec1");
    ok(exists $other_poss_val_sec1{8}, "8 in sec1");
    ok(exists $other_poss_val_sec1{9}, "9 in sec1");

    my %other_poss_val_row0 = $inst->other_possible_values_in(
        requesting_cell    => $cell4,
        predicate          => $inst->can('is_empty_and_in_same_row')
    );


    ok(exists $other_poss_val_row0{1}, "1 in row0");
    ok(exists $other_poss_val_row0{3}, "3 in row0");
    ok(exists $other_poss_val_row0{4}, "4 in row0");
    ok(exists $other_poss_val_row0{5}, "5 in row0");
    ok(exists $other_poss_val_row0{6}, "6 in row0");
    ok(exists $other_poss_val_row0{7}, "7 in row0");
    ok(exists $other_poss_val_row0{8}, "8 in row0");
    ok(exists $other_poss_val_row0{9}, "9 in row0");


    my %other_poss_val_col4 = $inst->other_possible_values_in(
        requesting_cell    => $cell4,
        predicate          => $inst->can('is_empty_and_in_same_col')
    );

    ok(exists $other_poss_val_col4{1}, "1 in col4");
    ok(exists $other_poss_val_col4{2}, "2 in col4");
    ok(exists $other_poss_val_col4{3}, "3 in col4");
    ok(exists $other_poss_val_col4{4}, "4 in col4");
    ok(exists $other_poss_val_col4{5}, "5 in col4");
    ok(exists $other_poss_val_col4{6}, "6 in col4");
    ok(exists $other_poss_val_col4{8}, "8 in col4");
    ok(exists $other_poss_val_col4{9}, "9 in col4");
};

subtest 'other possible values in sector' => sub {
     my $inst = Sudoku::Board->new(
        input => [
            [0,0,0,3,0,1,2,0,0],
            [0,0,8,0,0,4,0,0,0],
            [0,0,1,0,7,0,0,8,0],
            [0,0,0,0,0,0,0,0,0],
            [0,0,0,0,0,0,0,0,0],
            [0,0,0,0,0,0,0,0,0],
            [0,0,0,0,0,0,0,0,0],
            [0,0,0,0,0,0,0,0,0],
            [0,0,0,0,0,0,0,0,0],
        ],
    );

    my $cell4 = @{$inst->cells}[4];

    my %other_possible_values = $inst->other_possible_values_in_sector($cell4);

    ok(!exists $other_possible_values{8}, "No one can be 8");
    ok(exists $other_possible_values{2}, "Some can be 2");
    ok(!exists $other_possible_values{3}, "No one can be 3");
};


subtest 'other possible values in column' => sub {
     my $inst = Sudoku::Board->new(
        input => [
            [0,0,0,3,0,1,2,0,0],
            [0,0,8,0,0,4,0,0,0],
            [0,0,1,0,7,0,0,8,0],
            [0,0,0,8,0,0,0,0,0],
            [0,0,0,0,0,0,0,0,0],
            [0,0,0,0,0,0,0,0,0],
            [0,0,8,0,0,0,0,0,0],
            [0,0,8,0,0,0,0,0,0],
            [0,0,8,0,0,0,0,0,0],
        ],
    );

    my $cell4 = @{$inst->cells}[4];

    my %other_possible_values = $inst->other_possible_values_in_col($cell4);

    ok(!exists $other_possible_values{8}, "No one can be 8");
    ok(exists $other_possible_values{2}, "Some can be 2");
    ok(!exists $other_possible_values{7}, "No one can be 7");
};


subtest 'other possible values in row' => sub {
     my $inst = Sudoku::Board->new(
        input => [
            [0,0,0,3,0,1,2,0,0],
            [0,0,8,0,0,4,0,0,0],
            [0,0,1,0,7,0,0,8,0],
            [0,0,0,8,8,8,0,0,0],
            [0,0,0,0,0,0,0,0,0],
            [0,0,0,0,0,0,0,0,0],
            [0,0,8,0,0,0,0,0,0],
            [0,0,8,0,0,0,0,0,0],
            [0,0,8,0,0,0,0,0,0],
        ],
    );

    my $cell4 = @{$inst->cells}[4];

    my %other_possible_values = $inst->other_possible_values_in_row($cell4);

    ok(!exists $other_possible_values{8}, "No one can be 8");
    ok(exists $other_possible_values{7}, "Some can be 7");
    ok(!exists $other_possible_values{2}, "No one can be 2");
};

subtest 'is solved' => sub {
     my $board = Sudoku::Board->new(
        input => [
            [1,2,3,4,5,6,7,8,9],
            [1,2,3,4,5,6,7,8,9],
            [1,2,3,4,5,6,7,8,9],
            [1,2,3,4,5,6,7,8,9],
            [1,2,3,4,5,6,7,8,9],
            [1,2,3,4,5,6,7,8,9],
            [1,2,3,4,5,6,7,8,9],
            [1,2,3,4,5,6,7,8,9],
            [1,2,3,4,5,6,7,8,9],
        ],
    );

    ok($board->is_solved, "board 'solved'");

};

subtest 'solve simple' => sub {
   my $board = Sudoku::Board->new(
        input => [
            [0,0,0,0,1,0,8,0,0],
            [0,0,7,0,3,5,0,9,6],
            [0,3,5,0,4,0,7,2,0],
            [0,9,0,0,0,0,6,0,3],
            [6,0,0,8,2,3,0,0,9],
            [5,0,3,0,0,0,0,7,0],
            [0,4,8,0,5,0,9,6,0],
            [1,6,0,7,8,0,3,0,0],
            [0,0,9,0,6,0,0,0,0],
        ],
    );

    $board->solve();
    ok($board->is_solved, "board solved");
};

subtest 'solve medium' => sub {
   my $board = Sudoku::Board->new(
        input => [
            [8,0,0,0,0,0,0,0,0],
            [0,0,0,8,0,1,0,5,0],
            [5,4,3,0,0,0,6,8,0],
            [0,0,0,5,2,0,3,0,8],
            [0,8,0,0,1,0,0,9,0],
            [3,0,6,0,9,8,0,0,0],
            [0,3,5,0,0,0,7,2,6],
            [0,9,0,2,0,4,0,0,0],
            [0,0,0,0,0,0,0,0,5],
        ],
    );

    $board->solve();
    ok($board->is_solved, "board solved");
};

subtest 'solve hard' => sub {
   my $board = Sudoku::Board->new(
        input => [
            [0,0,0,2,0,0,6,0,0],
            [0,6,2,5,0,1,0,7,0],
            [0,1,0,0,0,0,0,0,9],
            [0,7,0,0,3,9,0,0,0],
            [8,0,0,1,0,5,0,0,6],
            [0,0,0,7,6,0,0,2,0],
            [7,0,0,0,0,0,0,8,0],
            [0,3,0,9,0,7,5,6,0],
            [0,0,5,0,0,4,0,0,0],
        ],
    );

    $board->solve();
    ok(!$board->is_solved, "hard board not solved");
};

done_testing;