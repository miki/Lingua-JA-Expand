use strict;
use warnings;
use Lingua::JA::Expand;

print "Input your 'Yahoo API appid':";
my $appid = <STDIN>;
chomp $appid;
warn(
"You must set your own yahoo_api_appid, but now this program will try to 'test' for temporary"
) if !$appid;
$appid ||= 'test';
my %config = ( yahoo_api_appid => $appid );

loop();

sub loop {
    print "Input keyword: ";
    my $keyword = <STDIN>;
    my $exp     = Lingua::JA::Expand->new(%config);
    my $result  = $exp->expand($keyword);
    print "-" x 100, "\n";
    for ( sort { $result->{$b} <=> $result->{$a} } keys %$result ) {
        print sprintf( "%0.5f", $result->{$_} ), "\t", $_, "\n";
    }
    print "\n";
    loop();
}