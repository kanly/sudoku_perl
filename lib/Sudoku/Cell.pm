package Sudoku::Cell;

use Moose;
use Sudoku::Board;

has 'board' => (isa => 'Sudoku::Board', is => 'ro', required => 1);
has 'row' => (isa => 'Int', is => 'ro', required => 1);
has 'col' => (isa => 'Int', is => 'ro', required => 1);
has 'value' => (isa => 'Int', is => 'rw', required => 1, default => 0);
has 'sector' => (isa => 'Int', is => 'ro', lazy => 1, builder => 'evaluate_sector' );

sub evaluate_sector {
    my $self = shift;
    $self->board->evaluate_sector($self->row, $self->col);
}

sub remaining_values {
    my $self = shift;
    my $b = $self->board;
    my $ra_value_set = $b->value_set;
    my $ra_values_in_col = $b->values_in_col($self->col);
    my $ra_values_in_row = $b->values_in_row($self->row);
    my $ra_values_in_sector = $b->values_in_sector($self->sector);
    
    my %values_to_be_excluded = ();
    @values_to_be_excluded{@$ra_values_in_col} = 1;
    @values_to_be_excluded{@$ra_values_in_row} = 1;
    @values_to_be_excluded{@$ra_values_in_sector} = 1;
    
    my @remaining_values = grep { ! defined $values_to_be_excluded{$_} } @$ra_value_set;
    
    if (scalar @remaining_values == 1) {
        $self->value($remaining_values[0]);
    } else {
        ...
    }
    
}



1;
