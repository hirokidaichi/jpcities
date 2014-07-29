use strict;
use warnings;
use TokyoCabinet;
use File::Slurp qw/read_file/;
use Encode qw/encode decode/;
use Encode::Guess;
my $hdb = TokyoCabinet::HDB->new;

# open the database
if ( !$hdb->open( "tc/geohash6.tch", $hdb->OWRITER | $hdb->OCREAT ) ) {
    my $ecode = $hdb->ecode();
    printf STDERR ( "open error: %s\n", $hdb->errmsg($ecode) );
}

my @csv = read_file("./geohash6.csv");
my $size = scalar @csv;
my $count = 0;

for my $line( @csv ){
    chomp $line;
    if( $count ++ % 5000 == 0 ){
        printf("%d/%d \n",$count,$size);
    }
    my ($ge,$la,$lo,@other) = split /,/,$line;
    $hdb->put($ge,join ",",@other);
}
