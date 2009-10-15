package Lingua::JA::Expand::DataSource::YahooSearch;
use strict;
use warnings;
use base qw(Lingua::JA::Expand::DataSource);
use Carp;
use LWP::UserAgent;
use XML::TreePP;

__PACKAGE__->mk_accessors($_) for qw(_xml);

sub new {
    my $class = shift;
    my $self  = $class->SUPER::new(@_);
    $self->_prepare;
    return $self;
}

sub extract_text {
    my $self     = shift;
    my $word_ref = shift;
    my $xml      = $self->raw_data($word_ref);
    my $text;
    if ( ref $xml->{ResultSet}->{Result} eq 'ARRAY' ) {
        my @items = @{ $xml->{ResultSet}->{Result} };
        for my $item (@items) {
            $text .= $item->{Title}   if $item->{Title};
            $text .= ' ';
            $text .= $item->{Summary} if $item->{Summary};
        }
    }
    return \$text;
}

sub raw_data {
    my $self = shift;
    if ( @_ > 0 || !$self->_xml ) {
        my $word_ref = shift;
        $$word_ref =~ s/([^\w ])/'%'.unpack('H2', $1)/eg;
        $$word_ref =~ tr/ /+/;
        my $url = $self->{url} . $$word_ref;
        my $req = HTTP::Request->new( GET => $url );
        my $res = $self->{user_agent}->request($req);
        my $xml = $self->{xml_treepp}->parse( $res->content );
        $self->_xml($xml);
    }
    else {
        return $self->_xml;
    }
}

sub _prepare {
    my $self                 = shift;
    my %LWP_UserAgent_config = ();
    if ( ref $self->config->{LWP_UserAgent} eq 'HASH' ) {
        %LWP_UserAgent_config = %{ $self->config->{LWP_UserAgent} };
    }
    $self->{user_agent} = LWP::UserAgent->new(%LWP_UserAgent_config);
    my %XML_TreePP_config = ();
    if ( ref $self->config->{XML_TreePP} eq 'HASH' ) {
        %XML_TreePP_config = %{ $self->config->{XML_TreePP} };
    }
    $self->{xml_treepp} = XML::TreePP->new(%XML_TreePP_config);
    my $yahoo_api_appid = $self->config->{yahoo_api_appid};
    croak("you must set your own 'yahoo_api_app_id'") if !$yahoo_api_appid;
    $self->{url} =
        'http://search.yahooapis.jp/WebSearchService/V1/webSearch?appid='
      . $yahoo_api_appid
      . '&results=50&adult_ok=1&query=';
}

1;

__END__

=head1 NAME

Lingua::JA::Expand::DataSource::YahooSearch - DataSource depend on Yahoo Web API 

=head1 SYNOPSIS

  use Lingua::JA::Expand::DataSource::YahooSearch;

  my %conf = (
    yahoo_api_appid => 'xxxxxxxxxxxxx',
  );
  my $datasource = Lingua::JA::Expand::DataSource::YahooSearch->new(\%conf);
  my $text_ref   = $datasource->extract_text(\$word);
  my $xml_ref    = $datasource->raw_xml(\$word); 

=head1 DESCRIPTION

Lingua::JA::Expand::DataSource::YahooSearch is DataSource depend on Yahoo Web API 
You must set your own 'yahoo_api_appid',

=head1 METHODS

=head2 new()

=head2 extract_text()

=head2 raw_data()

=head1 AUTHOR

Takeshi Miki E<lt>miki@cpan.orgE<gt>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 SEE ALSO

=cut

