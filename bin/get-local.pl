use strict;
use warnings;
use File::Slurp qw/read_file/;
use DBI;

my $dbh = DBI->connect( "dbi:Pg:dbname=gis;host=localhost",
    "daichi.hiroki", "", { RaiseError => 1 } );

my $query =
"SELECT n03_001,n03_003,n03_004 FROM shapes WHERE ST_Within(ST_GeomFromText('POINT(%0.12f  %0.12f)'), geom);";
binmode( STDOUT, ":utf8" );
binmode( STDERR, ":utf8" );
my @geo6 = read_file("geo6.csv");

my $count = 0;
for my $line (@geo6) {
    my ( $geo6, $la, $lo ) = split /,/, $line;
    my $r = $dbh->selectrow_arrayref( sprintf( $query, $lo, $la ) );
    next unless $r;
    my $csv = join ",",
      map { chomp $_; $_ }
      map { defined $_ ? $_ : "" } ( $geo6, $la, $lo, @$r );
    print $csv;
    print "\n";
    $count++;
    if ( $count % 50 == 0 ) {
        print STDERR $count;
        print STDERR " ";
        print STDERR $csv;
        print STDERR "\n";
    }

}
$dbh->disconnect;
