package Curso::View::TT::Plano;
use Moose;
use namespace::autoclean;

extends 'Catalyst::View::TT';

__PACKAGE__->config(
    TEMPLATE_EXTENSION => '.tt',
    render_die => 1,
);

=head1 NAME

Curso::View::TT::Plano - TT View for Curso

=head1 DESCRIPTION

TT View for Curso.

=head1 SEE ALSO

L<Curso>

=head1 AUTHOR

Juan Paredes,,,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
