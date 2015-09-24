package Curso::Controller::Admin::Staff;
use Moose;
use utf8;
use Try::Tiny;
use MooseX::MethodAttributes;
use Types::Standard qw/Int/;

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
    $c->model('DVD::Staff')->search({},{ order_by => 'username' })->all
  ];
}

=head2 crear

Crear una nueva categoría. URL: /admin/categoria/crear

=cut

sub crear : Local : Args(0) : FormConfig {
  my ( $self, $c ) = @_;

  my $form = $c->stash->{ form };
  my $staff;

  if ( $form->submitted_and_valid ) {
    try {
      $c->model('DVD')->txn_do( sub {
        # Crear usuario
        $staff = $form->model->create( {resultset => 'Staff'} );
      });
      # FALTA: carga de foto
      $c->response->redirect(
        $c->uri_for( '/admin/staff/' . $staff->id, 
                      { mid => $c->set_status_msg("Empleado registrado exitosamente") } )
      );
    }
    catch {
      my $error = $_;
      $c->stash->{ error_msg } = 'No se pudo completar la acción: ' . $error;
    };
  }
  elsif ( $form->submitted && $form->has_errors ) {
    $c->stash->{ error_msg } = Curso->config->{ mensaje_datos_invalidos };
  }
}

=head2 base

Recuperar registro de un empleado dado (acción base para cadena)

=cut

sub base : PathPart('admin/staff') :Chained('/') : CaptureArgs(Int) {
  my ( $self, $c, $id ) = @_;

  # Buscar el empleado en la BD dado su ID
  my $staff = $c->model('DVD::Staff')->find( $id );
  if ( $staff ) {
    $c->stash->{ staff } = $staff;
  }
  else {
    # Empleado no encontrado
    $c->response->redirect( $c->uri_for('/staff') );
  }
}

=head2 detalle

Mostrar detalle de un empleado dado. URL: /admin/staff/[id]

=cut

sub detalle : PathPart('') : Chained('base') : Args(0) {
  my ( $self, $c ) = @_;

}

=head2 editar

Editar datos de un empleado dado. URL: /admin/staff/[id]/editar

=cut

sub editar : Chained('base') : Args(0) : FormConfig('admin/staff/crear') {
  my ( $self, $c ) = @_;

  my $form = $c->stash->{ form };
  my $staff = $c->stash->{ staff };
  # cargar los datos actuales en el formulario
  $form->model->default_values( $staff );

  # colocamos el objeto que se está editando en el 'stash' privado del formulario
  # para poder referenciarlo al comparar los nombres únicos de usuario
  $form->stash->{ staff } = $staff;

  # Ilustraremos un breve ejemplo de la modificación del comportamiento del formulario dinámicamente.
  # Podemos agregar, eliminar o modificar elementos del formulario. Aquí, sólo modificaremos
  # la restricción en el campo de contraseña para que no sea obligatoria (sólo se procesará
  # el valor en caso de especificar una nueva contraseña, si se deja en blanco, se ignorará)

  # Primero, obtenemos el campo de contraseña deseado
  my $campo_password = $form->get_field({ name => 'password', type => 'Password' });

  # Obtenemos ahora el constraint 'Required' asociado a dicho campo
  my $constraint_password_requerido = $campo_password->get_constraint( { type => 'Required' } );

  # Hacemos que el constraint no se aplique, asignando un valor que nunca estará presente
  # en la condición (el campo 'active' sólo estaría en 0|1
  $constraint_password_requerido->{ 'when' }->{ 'value' } = -1;

  # Modificamos también el comentario del campo
  $campo_password->comment_xml('<div class="help-block"><span class="glyphicon glyphicon-info-sign" aria-label="Nota"></span> Introduzca sólo si desea modificar la contraseña</div>');

  # Siempre que realicemos modificaciones 'manuales' o dinámicas (es decir, vía código),
  # debemos invocar al método 'process' del formulario
  $form->process;

  if ( $form->submitted_and_valid ) {
    try {
      $c->model('DVD')->txn_do( sub {
        # Actualizar usuario
        $form->model->update( $staff );
      });
      # FALTA: carga de foto
      $c->response->redirect(
        $c->uri_for( '/admin/staff/' . $staff->id, 
                      { mid => $c->set_status_msg("Empleado actualizado exitosamente") } )
      );
    }
    catch {
      my $error = $_;
      $c->stash->{ error_msg } = 'No se pudo completar la acción: ' . $error;
    };
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
