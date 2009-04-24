use strict;
use warnings;
use Lingua::JA::Expand::DataSource::YahooSearch;
use Test::More tests => 1;

my $datasource = Lingua::JA::Expand::DataSource::YahooSearch->new;

isa_ok($datasource, 'Lingua::JA::Expand::DataSource::YahooSearch');


