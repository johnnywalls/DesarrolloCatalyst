package Curso::Model::Google;
use Moose;
use namespace::autoclean;

extends 'Catalyst::Model';

=head1 NAME

Curso::Model::Google - Catalyst Model

=head1 DESCRIPTION

Catalyst Model.

=cut

__PACKAGE__->config(
  referer => 'http://www.cpan.com'
);

use REST::Google::Search::Blogs;

sub search {
  my ($self, $query) = @_;

  REST::Google::Search->http_referer( $self->{referer} );

  my $res = REST::Google::Search->new( q => $query, rsz => 5, safe => 'active' );
  die "response status failure" if $res->responseStatus != 200;
  return $res;
}


=encoding utf8

=head1 AUTHOR

Juan Paredes,,,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
