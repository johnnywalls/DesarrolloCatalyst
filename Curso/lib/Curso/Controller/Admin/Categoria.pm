package Curso::Controller::Admin::Categoria;
use Moose;
use utf8;

use MooseX::MethodAttributes;
use Types::Standard qw/Int/;
use Try::Tiny;

BEGIN { extends 'Catalyst::Controller::HTML::FormFu'; }

=head1 NAME

Curso::Controller::Admin::Categorias - Catalyst Controller

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

sub editar : Chained('base') : Args(0) : FormConfig {
  my ( $self, $c ) = @_;

  my $form = $c->stash->{ form };

  # Recuperamos el registro deseado desde el stash
  my $categoria = $c->stash->{ categoria };

  # llenar datos del formulario
  $form->default_values( { name => $categoria->name } );
}

=head2 editar_FORM_VALID

Se invoca cuando se han enviado y validadado exitosamente los datos del formulario

=cut

sub editar_FORM_VALID {
  my ( $self, $c ) = @_;

  my $form = $c->stash->{ form };
  my $datos = { name => $form->param_value('name') };
  my $categoria = $c->stash->{ categoria };

  try {
    $categoria->update( $datos );
    $c->response->redirect(
      $c->uri_for( '/admin/categoria/' . $categoria->id, 
                    { mid => $c->set_status_msg("Cambios guardados exitosamente") } )
    );
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

=head2 editar_FORM_NOT_VALID

Se invoca cuando se han enviado los datos del formulario pero no han pasado la validación

=cut

sub editar_FORM_NOT_VALID {
  my ( $self, $c ) = @_;
  $c->stash->{ error_msg } = 'Existen datos inválidos. Por favor, revise el formulario para corregirlos e intente nuevamente.';
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
      $c->response->redirect(
        $c->uri_for('/admin/categoria/',
                    { mid => $c->set_status_msg("Categoría eliminada exitosamente") } )
      );
    }
    catch {
      my $error = $_;
      my $mensaje = 'No se pudo realizar la acción: ' . $error;
      $c->response->redirect(
        $c->uri_for('/admin/categoria/' . $categoria->id,
                    { mid => $c->set_error_msg( $mensaje ) } )
      );
    };
  }
  else {
    $c->response->redirect(
      $c->uri_for('/admin/categoria/' . $categoria->id,
                  { mid => $c->set_error_msg( 'No se puede eliminar esta categoría' ) } )
    );
  }
}

=head2 crear

Crear una nueva categoría. URL: /admin/categoria/crear

=cut

sub crear : Local : Args(0) : FormConfig('admin/categoria/editar') {
  my ( $self, $c ) = @_;

  my $form = $c->stash->{ form };
  # Si ya tenemos datos enviados, crear el nuevo registro
  my $categoria;
  if ( $form->submitted_and_valid ) {
    my $datos = { name => $form->param_value('name') };
    try {
      $categoria = $c->model('DVD::Category')->create( $datos );
      $c->response->redirect(
        $c->uri_for('/admin/categoria/' . $categoria->id,
                    { mid => $c->set_status_msg("Categoría creada exitosamente") } )
      );
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
