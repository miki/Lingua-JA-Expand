use strict;
use warnings;
use Lingua::JA::Expand;
use Test::More tests => 3;
use Data::Dumper;

# load default class
{
    my $exp = Lingua::JA::Expand->new;
    isa_ok($exp, 'Lingua::JA::Expand');

    my $tokenizer = $exp->tokenizer;
    isa_ok($tokenizer, 'Lingua::JA::Expand::Tokenizer::MeCab');

    my $datasource = $exp->datasource;
    isa_ok($datasource, 'Lingua::JA::Expand::DataSource::YahooSearch');
}
