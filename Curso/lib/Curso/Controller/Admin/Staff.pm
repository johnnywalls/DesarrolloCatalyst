package Curso::Controller::Admin::Staff;
use Moose;
use namespace::autoclean;
use utf8;
use Try::Tiny;

BEGIN { extends 'Catalyst::Controller::HTML::FormFu'; }

=head1 NAME

Curso::Controller::Admin::Staff - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 auto

Verificación de roles

=cut

sub auto :Private {
  my ( $self, $c ) = @_;
  unless ( $c->check_user_roles('Administrator') ) {
    $c->detach('/acceso_denegado');
    return 0;
  }
  return 1;
}

=head2 index

Mostrar todos los empleados

=cut

sub index :Path :Args(0) {
  my ( $self, $c ) = @_;

  $c->stash->{ empleados } = [
    $c->model('DVD::Staff')->search({},{ order_by => 'last_name, first_name' })->all
  ];
}

=head2 crear

Crear una nueva categoría. URL: /admin/categoria/crear

=cut

sub crear : Local : Args(0) : FormConfig {
  my ( $self, $c ) = @_;

  my $form = $c->stash->{ form };

  # En primera instancia sólo demostraremos la obtención de datos desde el formulario
  my $datos;
  use Data::Dumper;
  if ( $form->submitted ){
    # 'params' nos retorna los campos con valores válidos
    $datos = $form->params;
    $c->log->debug( "Datos del formulario usando params:" . Dumper($datos) );

  }

  if ( $form->submitted_and_valid ) {
    # FALTA: procesar datos
  }
  elsif ( $form->submitted && $form->has_errors ) {
    $c->stash->{ error_msg } = Curso->config->{ mensaje_datos_invalidos };
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
