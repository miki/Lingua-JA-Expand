package Lingua::JA::Expand;

use strict;
use warnings;
use Carp;
use base qw(Lingua::JA::Expand::Base);
use UNIVERSAL::require;

our $VERSION = '0.00003';

__PACKAGE__->mk_accessors qw(_tokenizer _datasource);

sub new {
    my $class = shift;
    my %args  = @_;
    my $self  = $class->SUPER::new( \%args );
}

sub expand {
    my $self      = shift;
    my $word      = shift;
    my $threshold = shift || 30;
    my $text_ref  = $self->datasource->extract_text(\$word);
    my $word_set  = $self->tokenizer->tokenize( $text_ref, $threshold );
    return $word_set;
}

sub tokenize {
    my $self      = shift;
    my $text      = shift;
    my $threshold = shift || 30;
    my $word_set  = $self->tokenizer->tokenize( \$text, $threshold );
    return $word_set;
}

sub tokenizer {
    my $self = shift;
    $self->_class_loader( tokenizer => 'Tokenizer::MeCab' );
}

sub datasource {
    my $self = shift;
    $self->_class_loader( datasource => 'DataSource::YahooSearch' );
}

sub _class_loader {
    my $self          = shift;
    my $class_type    = shift;
    my $default_class = shift;
    my $accessor      = '_' . $class_type;
    $self->$accessor or $self->$accessor(
        sub {
            my $class;
            my $config = $self->config || {};
            if ( $config->{$class_type} ) {
                $class = $config->{$class_type};
            }
            else {
                $class = __PACKAGE__ . '::' . $default_class;
            }
            $class->require or croak $@;
            $class->new($config);
          }
          ->()
    );
}

1;

__END__

=head1 NAME

Lingua::JA::Expand - word expander by associatives

=head1 SYNOPSIS

  use Lingua::JA::Expand;
  use Data::Dumper;

  my $exp = Lingua::JA::Expand->new(%conf);

  # expand the word by associatives 
  my $word_set = $exp->expand($word);
  print Dumper $word_set;

  # you can tokenize a document by extract featured words. 
  my $word_set = $exp->tokenize($text);
  print Dumper $word_set;

=head1 DESCRIPTION

Lingua::JA::Expand is word expander by associatives

=head1 METHODS

=head2 new()

=head2 expand()

=head2 tokenize()

=head2 tokenizer()

=head2 datasource()

=head1 AUTHOR

Takeshi Miki E<lt>miki@cpan.orgE<gt>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 SEE ALSO

=cut
