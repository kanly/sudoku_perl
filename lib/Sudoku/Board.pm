package Sudoku::Board;

use Moose;
use Sudoku::Cell;

has 'input' => (isa => 'ArrayRef', is => 'ro', required => 1);
has 'value_set' => (isa => 'ArrayRef', is => 'ro', default => sub {[1 .. 9]});
has 'cells' => (isa => 'ArrayRef', is => 'ro', builder => 'build_cells_array', lazy => 1);

#builder method, it builds the cells array starting from the input attribute
sub build_cells_array {
    my $self = shift;
    my $r_values_array = $self->input;

    my @cells;

    for (my $row_index=0; $row_index < scalar @{$r_values_array}; $row_index++) {
        my @row = @{$r_values_array->[$row_index]};
        for (my $col_index=0; $col_index < scalar @row; $col_index++) {
            my $val = $row[$col_index];
            push @cells, Sudoku::Cell->new(
                board   => $self,
                row     => $row_index,
                col     => $col_index,
                value   => $val,
            );
        }
    }

    return \@cells;
}

#try to solve the sudoku
sub solve {
    my $self = shift;

    my $i = 0;
    my @cells=@{$self->cells};

    while ( !$self->is_solved() ){
        $_->solve() foreach (@cells);

        $i++;
        return "unsolvable" if $i == 50;
    }

    use feature 'say';
    use Data::Dump 'pp';

    say "Sudoku solved in [$i] iterations";
    say pp $self->to_matrix();

    return $i;
}

sub to_matrix {
    my $self = shift;
    my @values = map {
        $_->value;
    } @{$self->cells};
    my @matrix;
    push @matrix, [ splice @values, 0, 9 ] while @values;
    return @matrix;
}

sub is_solved {
   my $self = shift;
   my $i = 0;
   my @cells = @{$self->cells};

   $i++ while ( ( $i < scalar @cells ) && $cells[$i]->is_solved );
   return $i==scalar @cells;
}

#values already setted in a given row
sub values_in_row {
    my ($self, $row) = @_;
    return map {$_->value} grep {$_->row==$row && $_->value != 0} @{$self->cells};
}

#values already setted in a given column
sub values_in_col {
    my ($self, $col) = @_;
    return map {$_->value} grep {$_->col==$col && $_->value != 0} @{$self->cells};
}

#values already setted in a given sector
sub values_in_sector {
    my ($self, $sector) = @_;
    return
        map {$_->value}
            grep {
                $_->value != 0 && $self->evaluate_sector($_->row,$_->col) == $sector
            }
            @{$self->cells};
}

# Possible values of other cells in same sector
sub other_possible_values_in_sector {
    my ($self, $requesting_cell) = @_;

    return $self->other_possible_values_in(
        requesting_cell	=> $requesting_cell,
        predicate 		=> $self->can('is_empty_and_in_same_sector'),
    );
}

# Possible values of other cells in same row
sub other_possible_values_in_row {
    my ($self, $requesting_cell) = @_;

    return $self->other_possible_values_in(
        requesting_cell	=> $requesting_cell,
        predicate 		=> $self->can('is_empty_and_in_same_row'),
    );
}

# Possible values of other cells in same column
sub other_possible_values_in_col {
    my ($self, $requesting_cell) = @_;

    return $self->other_possible_values_in(
        requesting_cell	=> $requesting_cell,
        predicate 		=> $self->can('is_empty_and_in_same_col'),
    );
}

#generic method to retrieve possible values of other cells that satisfies the given predicate
sub other_possible_values_in {

    #reading params
    my $self = shift;

    my %arg_ref = @_;


    my $requesting_cell = $arg_ref{'requesting_cell'};
    my $predicate = $arg_ref{'predicate'};

    #setting other vars
    my %other_poss_values = ();

    #build other_poss_values hash
    foreach my $cell (@{$self->cells}) {
        if(&{$predicate}($cell, $requesting_cell)) {
            @other_poss_values{$cell->remaining_values()} = 1;
        }
    }

    return %other_poss_values;
}

#evaluate sector of a given ($row, $col) identified cell
sub evaluate_sector {
    my ($self, $row, $col) = @_;
    {
        use integer;
        return $col / 3 + ($row / 3) * 3;
    }
}

#test if a cell is empty, not the same as requesting_cell and in the same sector as requesting_cell
sub is_empty_and_in_same_sector {
    my ($cell, $requesting_cell) = @_;

    return $cell->value == 0
              && !( $requesting_cell->row == $cell->row && $requesting_cell->col == $cell->col )
              && $cell->sector == $requesting_cell->sector;
}

#test if a cell is empty, not the same as requesting_cell and in the same row as requesting_cell
sub is_empty_and_in_same_row {
    my ($cell, $requesting_cell) = @_;

    return $cell->value == 0
              && !( $requesting_cell->row == $cell->row && $requesting_cell->col == $cell->col )
              && $cell->row == $requesting_cell->row;
}

#test if a cell is empty, not the same as requesting_cell and in the same col as requesting_cell
sub is_empty_and_in_same_col {
    my ($cell, $requesting_cell) = @_;

    return $cell->value == 0
              && !( $requesting_cell->row == $cell->row && $requesting_cell->col == $cell->col )
              && $cell->col == $requesting_cell->col;
}


1;