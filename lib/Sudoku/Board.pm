package Sudoku::Board;

use Moose;
use Sudoku::Cell;

has 'input' => (isa => 'ArrayRef', is => 'ro', required => 1);
has 'value_set' => (isa => 'ArrayRef', is => 'ro', default => sub {[1 .. 9]});
has 'cells' => (isa => 'ArrayRef', is => 'ro', builder => 'build_cells_array', lazy => 1);

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

sub values_in_row {
    my ($self, $row) = @_;
    return map {$_->value} grep {$_->row==$row && $_->value != 0} @{$self->cells}; 
}

sub values_in_col {
    my ($self, $col) = @_;
    return map {$_->value} grep {$_->col==$col && $_->value != 0} @{$self->cells}; 
}

sub values_in_sector {
    my ($self, $sector) = @_;
    return map {$_->value} grep {
        $_->value != 0 && $self->evaluate_sector($_->row,$_->col) == $sector
    }
    @{$self->cells};
}

sub evaluate_sector {
    my ($self, $row, $col) = @_;
    {
        use integer;
        return $col / 3 + ($row / 3) * 3;
    }
}

1;
