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

# evaluate possible remaining values filtering out values already setted in
# this cell's row, column and sector
sub remaining_values {
    my $self = shift;
    my $b = $self->board;
    my $ra_value_set = $b->value_set;
    my @values_in_col = $b->values_in_col($self->col);
    my @values_in_row = $b->values_in_row($self->row);
    my @values_in_sector = $b->values_in_sector($self->sector);

    my %values_to_be_excluded = ();
    @values_to_be_excluded{@values_in_col} = 1;
    @values_to_be_excluded{@values_in_row} = 1;
    @values_to_be_excluded{@values_in_sector} = 1;

    return grep { !exists $values_to_be_excluded{$_} } @$ra_value_set;
}

# try to assign a value to this cell
sub solve {
    my $self = shift;
    return if($self->is_solved());

    my @remaining_values = $self->remaining_values();
    if (scalar @remaining_values == 1) {
        $self->value($remaining_values[0]);
    } else {
        $self->try_with_possible_values_in_sector(@remaining_values) or
        $self->try_with_possible_values_in_col(@remaining_values) or
        $self->try_with_possible_values_in_row(@remaining_values)
    }
}

# generic method that try to assign a value to this cell
# checking if this cell is the only one that can have a value
# by filtering @rem_values with @other_poss_values
sub try_with_possible_values {
    #init
    my $self = shift;

    my $rh_params = {
        other_poss_values 	=> {},
        rem_values 			=> [],
        @_
    };

    my %other_cells_poss_values = %{ $rh_params->{'other_poss_values'} };

    # filter remaining values
    my @remaining_values = grep { !exists $other_cells_poss_values{$_} } @{ $rh_params->{'rem_values'} };

    # check if there is a solution
    if (scalar @remaining_values == 1) {
        $self->value($remaining_values[0]);
        return $remaining_values[0];
    } else {
        return undef;
    }
}

# try to assign a value to this cell checking if this cell
# is the only one that can have a value in her sector
sub try_with_possible_values_in_sector {
    my ($self, @remaining_values) = @_;
    return $self->try_with_possible_values(
            other_poss_values => {$self->board->other_possible_values_in_sector($self)},
            rem_values => \@remaining_values,
    );
}

# try to assign a value to this cell checking if this cell
# is the only one that can have a value in her column
sub try_with_possible_values_in_col {
    my ($self, @remaining_values) = @_;
    return $self->try_with_possible_values(
            other_poss_values => {$self->board->other_possible_values_in_col($self)},
            rem_values => \@remaining_values,
    );
}

# try to assign a value to this cell checking if this cell
# is the only one that can have a value in her row
sub try_with_possible_values_in_row {
    my ($self, @remaining_values) = @_;
    return $self->try_with_possible_values(
            other_poss_values => {$self->board->other_possible_values_in_row($self)},
            rem_values => \@remaining_values,
    );
}


sub is_solved {
  my $self = shift;

  return $self->value;
}

1;
