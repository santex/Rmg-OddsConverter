use lib './lib';
use Test::More ( tests => 9 );
use Test::Exception;

use_ok( 'Rmg::OddsConverter' );

new_ok( 'Rmg::OddsConverter' => [ probability => 0 ] );
new_ok( 'Rmg::OddsConverter' => [ probability => 0.1 ] );
new_ok( 'Rmg::OddsConverter' => [ probability => 1 ] );
new_ok( 'Rmg::OddsConverter' => [ probability => 5e-2 ] );

dies_ok { OddConverter->new } 'No empty constructors';

dies_ok { OddsConverter->new( probability => -1 ) } 'No negative probabilities';
dies_ok { OddsConverter->new( probability => 1.1 ) } 'No probabilities > 1';
dies_ok { OddsConverter->new( probability => 'one' ) } 'No non-numeric probabilities';
