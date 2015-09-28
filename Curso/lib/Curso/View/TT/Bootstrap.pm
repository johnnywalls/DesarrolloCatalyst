package Curso::View::TT::Bootstrap;

use strict;
use base 'Catalyst::View::TT';

__PACKAGE__->config({
    INCLUDE_PATH => [
        Curso->path_to( 'root', 'src' ),
        Curso->path_to( 'root', 'lib' )
    ],
    PRE_PROCESS  => 'config/main',
    WRAPPER      => 'site/wrapper',
    ERROR        => 'error.tt2',
    TIMER        => 0,
    render_die   => 1,
    expose_methods => [ qw/ unescape / ]
});

=head1 NAME

Curso::View::TT::Bootstrap - Catalyst TT Twitter Bootstrap View

=head1 SYNOPSIS

See L<Curso>

=head1 DESCRIPTION

Catalyst TTSite View.

=head2 unescape

Remover los caracteres de escape con URI::Escape

=cut

sub unescape {
  my ($self, $c, $cadena) = @_;
  use URI::Escape;

  return uri_unescape( $cadena ) if $cadena;
  return undef;
}

=head1 AUTHOR

Juan Paredes,,,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;

