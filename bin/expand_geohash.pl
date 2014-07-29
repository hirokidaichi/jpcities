use strict;
use warnings;

use Geo::Hash::XS;
use File::Slurp qw/read_file/;

my $basefile = "geohash5.csv";
my $gh       = Geo::Hash::XS->new();
my @lines    = read_file($basefile);
my @base32 =
  qw/0 1 2 3 4 5 6 7 8 9 b c d e f g 
     h j k m n p q r s t u v w x y z/;

for my $line (@lines) {
    my @geo = split /,/, $line;
    my $geo = $geo[0];
    for my $s (@base32) {
        my $geo6 = "$geo$s";
        my ( $la, $lo ) = $gh->decode($geo6);
        print "$geo6,$la,$lo\n";
    }
}


