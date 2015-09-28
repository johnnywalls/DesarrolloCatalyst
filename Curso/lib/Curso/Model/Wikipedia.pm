package Curso::Model::Wikipedia;
use strict;
use warnings;
use base 'Catalyst::Model::Adaptor';

__PACKAGE__->config( 
    class       => 'WWW::Wikipedia',
    constructor => 'new',
    args        => { language => 'es' },
);

sub mangle_arguments {
  my ($self, $args) = @_;
  return %$args; # WWW::Wikipedia necesita un hash simple con los parámetros al constructor
}

1;
