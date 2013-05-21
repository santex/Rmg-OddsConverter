use lib "./lib";
use Test::More ( tests => 10+1 );

use_ok( 'Rmg::OddsConverter' );


foreach my $ind ( 0 .. 9 )
{
    subtest "probability " . $ind => sub {
        my $p = rand(1);
        my $oc = new_ok( 'Rmg::OddsConverter' => [ probability => $p ] );
        ok( printf "list:%s" ,$ind);
        ok( printf "prop:%s" ,$p);
        ok( print  "dec:" .$oc->decimal);
        ok( print  "roi:".$oc->roi."\n\n");


    };
}

