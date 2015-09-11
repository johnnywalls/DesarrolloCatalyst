package Curso::Controller::Peliculas::Reportes;
use Moose;
use namespace::autoclean;
use utf8;

BEGIN { extends 'Catalyst::Controller'; }

=head1 NAME

Curso::Controller::Peliculas::Reportes - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut

sub index :Path :Args(0) {
  my ( $self, $c ) = @_;

  $c->stash->{ template } = 'message.tt2';
  $c->stash->{ message } = 'Esta es la acción index en Peliculas::Reportes';
}

=head2 inventario_categorias

=cut

sub inventario_categorias :Local {
  my ( $self, $c ) = @_;

  $c->stash->{ inventarios } = [ $c->model('DVD::ReporteInventarioCategoria')->search({})->all ];
}

=head2 pagos_mensuales

=cut

sub pagos_mensuales :Local {
  my ( $self, $c ) = @_;

  my $inicio = $c->request->params->{ inicio };
  my $fin = $c->request->params->{ fin };

  if ( $inicio && $fin ) {
    my $pagos = $c->model('DVD::ReportePagosMensuales')->search({}, { bind => [ $inicio, $fin ] });
    $c->stash->{ pagos } = [ $pagos->all ];
  }
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
