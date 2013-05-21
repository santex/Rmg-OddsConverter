package Rmg::OddsConverter;
use Moose;

=head1 NAME

Rmg::OddsConverter

=head1 SYNOPSIS

    my $oc = Rmg::OddsConverter->new(probability => 0.5);
    print $oc->decimal;    # '2.00' (always to 2 decimal places)
    print $oc->roi;             # '100%' (always whole numbers or 'Inf.')


    Or use the bash

Example:

    highroller AAPL GOOG



=cut

use strict;
use Scalar::Util qw(looks_like_number);
use Carp;

use vars qw( $VERSION );

$VERSION = '0.01';

=head1 METHODS


=over

=item B<new()>

Instanciate a new Rmg::OddsConverter object
a parameter is needed to start the conversion.

=over

=item List of possible parameters:

=over

=item I<monte>

=item I<decimal>

=item I<roi>

=item I<probability>

=item I<fractional>

=item I<win_break>


=back

Example:

  my $oc = Rmg::OddsConverter->new( probability => 0.5 );

=back

=back

=cut

has 'monte' => (
    isa      => 'Any',
    is       => 'rw',
    required => 0,
    trigger  => \&_monte
);

has 'probability' => (
    isa      => 'Num',
    is       => 'rw',
    required => 0,
    trigger  => \&_probability
);
has 'fractional' => (
    isa      => 'Num',
    is       => 'rw',
    required => 0,
    trigger  => \&_fractional
);
has 'decimal' => (
    isa      => 'Num',
    is       => 'rw',
    required => 0,
    trigger  => \&_decimal
);
has 'win_break' => (
    isa      => 'Num',
    is       => 'rw',
    required => 0,
    trigger  => \&_win_break
);
has 'roi' => (
    isa      => 'Num',
    is       => 'rw',
    required => 0,
    trigger  => \&_roi
);
has 'moneyline' => (
    isa      => 'Str',
    is       => 'rw',
    required => 0,
    trigger  => \&_moneyline
);
has 'probability_not_rounded' => (
    isa      => 'Num',
    is       => 'rw',
    required => 0
);
has 'fractional_not_rounded' => (
    isa      => 'Num',
    is       => 'rw',
    required => 0
);
has 'decimal_not_rounded' => (
    isa      => 'Num',
    is       => 'rw',
    required => 0
);
has 'win_break_not_rounded' => (
    isa      => 'Num',
    is       => 'rw',
    required => 0
);
has 'roi_not_rounded' => (
    isa      => 'Num',
    is       => 'rw',
    required => 0
);
has 'moneyline_not_rounded' => (
    isa      => 'Str',
    is       => 'rw',
    required => 0
);

=over

=item B<monte>

Without parameter, return the monte ( return on investment ) for the object instantiate with the parameter from the method B<new()>

Example:

  print $oc->monte . "\n";

With a parameter, re-initialise the object instance with that monte value
and return the new monte value.

Example:

  print $oc->monte( 50 ) . "\n";

=back

=over


=item B<decimal>

Without parameter, return the decimal odds for the object instantiate with the parameter from the method B<new()>

Example:

  print $oc->decimal . "\n";

With a parameter, re-initialise the object instance with that decimal value
and return the new decimal odds value.

Example:

  print $oc->decimal( 3 ) . "\n";

=back

=over

=item B<roi>

Without parameter, return the roi ( return on investment ) for the object instantiate with the parameter from the method B<new()>

Example:

  print $oc->roi . "\n";

With a parameter, re-initialise the object instance with that roi value
and return the new roi value.

Example:

  print $oc->roi( 50 ) . "\n";

=back

=over

=item B<fractional>

Without parameter, return the fractional odds for the object instantiate with the parameter from the method B<new()>

Example:

  print $oc->fractional . "\n";

With a parameter, re-initialise the object instance with that fractional odds value
and return the new fractional odds value

Example:

  print $oc->fractional( 50 ) . "\n";

=back

=over

=item B<win_break>

Without parameter, return the win to break even odds for the object instantiate with the parameter from the method B<new()>

Example:

  print $oc->win_break . "\n";

With a parameter, re-initialise the object instance with that win_break odds value
and return the new win to break odds value

Example:

  print $oc->win_break( 90 ) . "\n";

=back

=over

=item B<probability>

Without parameter, return the probability odds for the object instantiate with the parameter from the method B<new()>

Example:

  print $oc->probability . "\n";

With a parameter, re-initialise the object instance with that probability odds value
and return the new win to probability odds value

Example:

  print $oc->probability( 90 ) . "\n";

=back

=over

=item B<moneyline>

Without parameter, return the moneyline odds for the object instantiate with the parameter from the method B<new()>

Example:

  print $oc->moneyline . "\n";

With a parameter, re-initialise the object instance with that moneyline odds value
and return the new win to moneyline odds value

Example:

  print $oc->moneyline( 90 ) . "\n";

=back

=cut

  sub _monte {


    my ( $self ) = @_;

    my $bet  = shift;
    my $cont = shift;
       $cont = "AAPL" unless $cont;

    my @highroller =
        split("\n", `yahooquote --verbose $cont | egrep -i "(^LAST:|^52)" | tr -d " " | sed "s/52-WeekRange://" | sed "s/Last://"| tr "-" " "`);

 #   print @highroller;


    my $out = sprintf("%s\t%s\t%s\n%s\t%s\t%s",
                      "bet",
                      "decimal",
                      "roi",
                      $bet,
                      $self->decimal,    # '2.00' (always to 2 decimal places)
                      $self->roi);       # '100%' (always whole numbers or 'Inf.')

          my $n = length($out)-8;

          return sprintf("\n%s\n%s","-"x$n,$out);

  }



sub _probability
{
    my ( $self ) = @_;

    $self->{ probability_not_rounded } = $self->{ probability };
    $self->{ probability } = sprintf( "%.2f", $self->{ probability } );
    if ( $self->{ probability_not_rounded } < 0 )
    {
        croak 'No negative probabilities';

    }
    elsif ( $self->{ probability_not_rounded } > 1 )
    {
        croak 'No probabilities > 1';
    }
    elsif ( $self->{ probability_not_rounded } == 0 )
    {
        $self->{ decimal } = $self->{ decimal_not_rounded } = 'Inf.';
        $self->{ roi }     = $self->{ roi_not_rounded }     = 'Inf.';
        $self->{ fractional_not_rounded } = 0;
        $self->{ fractional }             = sprintf( "%.2f", $self->{ fractional_not_rounded } );
        $self->{ moneyline }              = '-Inf.';
    }
    elsif ( $self->{ probability_not_rounded } == 1 )
    {
        $self->{ decimal_not_rounded }    = 1;
        $self->{ decimal }                = sprintf( "%.2f", $self->{ decimal_not_rounded } );
        $self->{ roi_not_rounded }        = 0;
        $self->{ roi }                    = sprintf( "%.0f%%", $self->{ roi_not_rounded } );
        $self->{ fractional_not_rounded } = 0;
        $self->{ fractional }             = sprintf( "%.2f", $self->{ fractional_not_rounded } );
        $self->{ moneyline }              = '+Inf.';
    }
    else
    {
        $self->{ win_break_not_rounded }  = $self->{ probability_not_rounded } * 100;
        $self->{ win_break }              = sprintf( "%.2f", $self->{ win_break_not_rounded } );
        $self->{ decimal_not_rounded }    = ( 100 / $self->{ win_break_not_rounded } );
        $self->{ fractional_not_rounded } = $self->{ decimal_not_rounded } - 1;
        $self->{ decimal }                = sprintf( "%.2f", $self->{ decimal_not_rounded } );
        $self->{ fractional }             = sprintf( "%.2f", $self->{ fractional_not_rounded } );
        $self->{ moneyline }              = $self->{ fractional_not_rounded } < 1 ? -( 100 / $self->{ fractional_not_rounded } ) : $self->{ fractional_not_rounded } * 100;
        $self->{ roi_not_rounded }        = 100 * $self->{ fractional_not_rounded };
        $self->{ roi }                    = sprintf( "%.0f%%", $self->{ roi_not_rounded } );
    }

    return $self;
}

sub _roi
{
    my ( $self ) = @_;
    $self->{ roi_not_rounded }         = $self->{ roi };
    $self->{ roi }                     = sprintf( "%.0f%%", $self->{ roi_not_rounded } );
    $self->{ fractional_not_rounded }  = $self->{ roi_not_rounded } / 100;
    $self->{ fractional }              = sprintf( "%.2f", $self->{ fractional_not_rounded } );
    $self->{ decimal_not_rounded }     = $self->{ fractional_not_rounded } + 1;
    $self->{ decimal }                 = sprintf( "%.2f", $self->{ decimal_not_rounded } );
    $self->{ moneyline_not_rounded }   = $self->{ fractional_not_rounded } < 1 ? -( 100 / $self->{ fractional_not_rounded } ) : $self->{ fractional_not_rounded } * 100;
    $self->{ moneyline }               = sprintf( "%.2f", $self->{ moneyline_not_rounded } );
    $self->{ win_break_not_rounded }   = 100 / ( $self->{ fractional_not_rounded } + 1 );
    $self->{ win_break }               = sprintf( "%.2f", $self->{ win_break_not_rounded } );
    $self->{ probability_not_rounded } = $self->{ win_break_not_rounded } / 100;
    $self->{ probability }             = sprintf( "%.2f", $self->{ probability_not_rounded } );

    return $self;
}

sub _win_break
{
    my ( $self ) = @_;

    if ( $self->{ win_break } < 0 || $self->{ win_break } >= 100 )
    {
        croak "Win_break must in the range ]0,100[";
    }

    $self->{ win_break_not_rounded } = $self->{ win_break };
    $self->{ win_break }             = sprintf( "%.2f", $self->{ win_break_not_rounded } );
    $self->{ probability }           = $self->{ win_break_not_rounded } / 100;
    _probability( $self );

    return $self;
}

sub _fractional
{
    my ( $self ) = @_;

    if ( $self->{ fractional } < 0 )
    {
        croak 'Fractional must be a positive value';
    }

    $self->{ fractional_not_rounded } = $self->{ fractional };
    $self->{ fractional }             = sprintf( "%.2f", $self->{ fractional_not_rounded } );
    $self->{ roi }                    = 100 * $self->{ fractional_not_rounded };
    _roi( $self );

    return $self;
}

sub _decimal
{
    my ( $self ) = @_;

    if ( $self->{ decimal } < 1 )
    {
        croak "Decimal must be greater than 1";
    }

    $self->{ decimal_not_rounded } = $self->{ decimal };
    $self->{ decimal }             = sprintf( "%.2f", $self->{ decimal_not_rounded } );
    $self->{ fractional }          = $self->{ decimal_not_rounded } - 1;
    _fractional( $self );

    return $self;
}

sub _moneyline
{
    my ( $self ) = @_;

    if ( $self->{ moneyline } =~ /^\+\/-(\d+)/ )
    {
        if ( $1 == 100 )
        {
            $self->{ moneyline } = 100;
        }
        else
        {
            carp "Moneyline value must be a numerical value positive, negative or the special value '+/-100'";
        }
    }

    $self->{ moneyline_not_rounded } = $self->{ moneyline };
    $self->{ moneyline }             = sprintf( "%.2f", $self->{ moneyline_not_rounded } );
    $self->{ fractional }            = $self->{ moneyline_not_rounded } < 0 ? -( 100 / $self->{ moneyline_not_rounded } ) : $self->{ moneyline_not_rounded } / 100;
    _fractional( $self );

    return $self;
}

=head1 EXAMPLE



  #!/usr/bin/perl

  use strict;
  use feature qw( say );
  use Data::Dumper;
  use Finance::YahooQuote;
  use Rmg::OddsConverter;

  push @ARGV,"AAPL" unless($ARGV[0]);


  my $p = rand(1);
  my $m = 0;
  my $oc = undef;
  say "@"x30;

  foreach(@ARGV){

    my $cmd = 'yahooquote --verbose '.$_.' | egrep -i "(^LAST:|^52)" | '.
              'tr -d " " | sed "s/52-WeekRange://" | sed "s/Last://"| tr "-" " "';
    my @highroller = split("\n| ",`$cmd`);

    $oc = Rmg::OddsConverter->new( probability => $p );

    say sprintf("%s %s %s","@"x10,"rand prop 0..1","@"x10);
    say "Contract:".$_;
    say "Last:$highroller[0]";
    say "rand(1) = $p";
    say "decimal=" . $oc->decimal;
    say "fractional=" . $oc->fractional;
    say "probability=" . $oc->probability;
    say "roi=" . $oc->roi;
    say "monte=".$oc->monte($p,$_);
    say "\n"x3;

    say sprintf("%s %s %s","@"x10,"LAST - 52WeekLow","@"x10);
    $m = $highroller[0]-$highroller[1];
    say "new from (LAST - 52WeekLow) ($m)\$";
    say "decimal=" . $oc->decimal;
    say "fractional=" . $oc->fractional;
    say "probability=" . $oc->probability;
    say "roi=" . $oc->roi;
    say  "monte=".$oc->monte($m,$_);

  }



  BEGIN{
      printf "%s", "\n"x3;


  }
1;


=head1 AUTHOR

Hagen Geissler <santex@cpan.org>

May 2013

=head1 LICENSE

Under the GNU GPL2


    This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public
    License as published by the Free Software Foundation; either version 2 of the License,
    or (at your option) any later version.

    This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
    without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
    See the GNU General Public License for more details.

    You should have received a copy of the GNU General Public License along with this program;
    if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

    Rmg::OddsConverter   Copyright (C) 2013 Hagen Geissler.  Rmg::OddsConverter comes with ABSOLUTELY NO WARRANTY;
    for details See: L<http://www.gnu.org/licenses/gpl.html>
    This is free software, and you are welcome to redistribute it under certain conditions;


=cut

1;

# ABSTRACT:codeing test

