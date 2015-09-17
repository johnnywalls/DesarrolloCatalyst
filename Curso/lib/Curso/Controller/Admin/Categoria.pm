package Curso::Controller::Admin::Categoria;
use Moose;
use utf8;

use MooseX::MethodAttributes;
use Types::Standard qw/Int/;
use Try::Tiny;

BEGIN { extends 'Catalyst::Controller'; }

=head1 NAME

Curso::Controller::Admin::Categorias - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

Mostrar todas las categorías. Corresponde a la URL /admin/categoria/ (sin argumentos)

=cut

sub index :Path :Args(0) {
  my ( $self, $c ) = @_;

  $c->stash->{ categorias } = [
    $c->model('DVD::Category')->search({},{ order_by => 'name' })->all
  ];
}

=head2 base

Recuperar registro de una categoría dada (acción base para cadena)

=cut

sub base : PathPart('admin/categoria') :Chained('/') : CaptureArgs(Int) {
  my ( $self, $c, $id ) = @_;

  # Buscar la categoría en la BD dado su ID
  my $categoria = $c->model('DVD::Category')->find( $id );
  if ( $categoria ) {
    $c->stash->{ categoria } = $categoria;
  }
  else {
    # Categoría no encontrada
    $c->response->redirect( $c->uri_for('/categorias') );
  }
}

=head2 detalle

Mostrar detalle de una categoría dada. URL: /admin/categoria/[id]

=cut

sub detalle : PathPart('') : Chained('base') : Args(0) {
  my ( $self, $c ) = @_;
  # Aquí, ya tenemos el registro deseado en el stash, no necesitamos nada más :-)
}

=head2 editar

Editar datos de una categoría dada. URL: /admin/categoria/[id]/editar

=cut

sub editar : Chained('base') : Args(0) {
  my ( $self, $c ) = @_;
  # Recuperamos el registro deseado desde el stash
  my $categoria = $c->stash->{ categoria };

  # Si ya tenemos datos enviados, actualizar la categoría
  my $params = $c->request->params;
  if ( keys %$params ) {
    my $datos = { name => $params->{name} };
    try {
      $categoria->update( $datos );
      $c->response->redirect( $c->uri_for('/admin/categoria/' . $categoria->id ) );
    }
    catch {
      my $error = $_;
      my $mensaje = 'No se pudo realizar la acción: ';
      # En caso de falla, identificar motivos conocidos para mostrar un mensaje adecuado
      if ( $error =~ m/uk_category_name/ ) {
        $mensaje .= 'El nombre dado para la categoría ya está siendo utilizado.';
      }
      else {
        # Si el motivo de la falla no es conocido de antemano, aquí mostramos el mensaje
        # completo de error. Esto podría variar según el perfil de usuario o la aplicación
        $mensaje .= $error;
      }
      $c->stash->{ error_msg } = $mensaje;
    };
  }
}

=head2 eliminar

Eliminar el registro de una categoría dada. URL: /admin/categoria/[id]/eliminar

=cut

sub eliminar : Chained('base') : Args(0) {
  my ( $self, $c ) = @_;
  # Recuperamos el registro deseado desde el stash
  my $categoria = $c->stash->{ categoria };

  # Las reglas para permitir eliminar un registro pueden variar según la aplicación.
  # Aquí, permitiremos eliminar una categoría siempre que no hayan películas asociadas
  if ( $categoria->film_categories->count == 0 ) {
    try {
      $categoria->delete;
      $c->response->redirect( $c->uri_for('/admin/categoria/' ) );
    }
    catch {
      my $error = $_;
      my $mensaje = 'No se pudo realizar la acción: ' . $error;
      $c->log->debug( $mensaje );
      $c->response->redirect( $c->uri_for('/admin/categoria/' . $categoria->id) );
    };
  }
}

=head2 crear

Crear una nueva categoría. URL: /admin/categoria/crear

=cut

sub crear : Local : Args(0) {
  my ( $self, $c ) = @_;

  # Si ya tenemos datos enviados, crear el nuevo registro
  my $params = $c->request->params;
  my $categoria;
  if ( keys %$params ) {
    my $datos = { name => $params->{name} };
    try {
      $categoria = $c->model('DVD::Category')->create( $datos );
      $c->response->redirect( $c->uri_for('/admin/categoria/' . $categoria->id ) );
    }
    catch {
      my $error = $_;
      my $mensaje = 'No se pudo realizar la acción: ';
      # En caso de falla, identificar motivos conocidos para mostrar un mensaje adecuado
      if ( $error =~ m/uk_category_name/ ) {
        $mensaje .= 'El nombre dado para la categoría ya está siendo utilizado.';
      }
      else {
        # Si el motivo de la falla no es conocido de antemano, aquí mostramos el mensaje
        # completo de error. Esto podría variar según el perfil de usuario o la aplicación
        $mensaje .= $error;
      }
      $c->stash->{ error_msg } = $mensaje;
    };
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
