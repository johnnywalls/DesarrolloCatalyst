use utf8;
package Curso::Schema::DVDRental::Result::Staff;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Curso::Schema::DVDRental::Result::Staff

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 COMPONENTS LOADED

=over 4

=item * L<DBIx::Class::InflateColumn::DateTime>

=back

=cut

__PACKAGE__->load_components("InflateColumn::DateTime");

=head1 TABLE: C<staff>

=cut

__PACKAGE__->table("staff");

=head1 ACCESSORS

=head2 staff_id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0
  sequence: 'staff_staff_id_seq'

=head2 first_name

  data_type: 'varchar'
  is_nullable: 0
  size: 45

=head2 last_name

  data_type: 'varchar'
  is_nullable: 0
  size: 45

=head2 address_id

  data_type: 'smallint'
  is_foreign_key: 1
  is_nullable: 0

=head2 email

  data_type: 'varchar'
  is_nullable: 1
  size: 50

=head2 store_id

  data_type: 'smallint'
  is_nullable: 0

=head2 active

  data_type: 'boolean'
  default_value: true
  is_nullable: 0

=head2 username

  data_type: 'varchar'
  is_nullable: 0
  size: 16

=head2 password

  data_type: 'varchar'
  is_nullable: 1
  size: 40

=head2 last_update

  data_type: 'timestamp'
  default_value: current_timestamp
  is_nullable: 0
  original: {default_value => \"now()"}

=head2 picture

  data_type: 'bytea'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "staff_id",
  {
    data_type         => "integer",
    is_auto_increment => 1,
    is_nullable       => 0,
    sequence          => "staff_staff_id_seq",
  },
  "first_name",
  { data_type => "varchar", is_nullable => 0, size => 45 },
  "last_name",
  { data_type => "varchar", is_nullable => 0, size => 45 },
  "address_id",
  { data_type => "smallint", is_foreign_key => 1, is_nullable => 0 },
  "email",
  { data_type => "varchar", is_nullable => 1, size => 50 },
  "store_id",
  { data_type => "smallint", is_nullable => 0 },
  "active",
  { data_type => "boolean", default_value => \"true", is_nullable => 0 },
  "username",
  { data_type => "varchar", is_nullable => 0, size => 16 },
  "password",
  { data_type => "varchar", is_nullable => 1, size => 40 },
  "last_update",
  {
    data_type     => "timestamp",
    default_value => \"current_timestamp",
    is_nullable   => 0,
    original      => { default_value => \"now()" },
  },
  "picture",
  { data_type => "bytea", is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</staff_id>

=back

=cut

__PACKAGE__->set_primary_key("staff_id");

=head1 RELATIONS

=head2 address

Type: belongs_to

Related object: L<Curso::Schema::DVDRental::Result::Address>

=cut

__PACKAGE__->belongs_to(
  "address",
  "Curso::Schema::DVDRental::Result::Address",
  { address_id => "address_id" },
  { is_deferrable => 0, on_delete => "RESTRICT", on_update => "CASCADE" },
);

=head2 payments

Type: has_many

Related object: L<Curso::Schema::DVDRental::Result::Payment>

=cut

__PACKAGE__->has_many(
  "payments",
  "Curso::Schema::DVDRental::Result::Payment",
  { "foreign.staff_id" => "self.staff_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 rentals

Type: has_many

Related object: L<Curso::Schema::DVDRental::Result::Rental>

=cut

__PACKAGE__->has_many(
  "rentals",
  "Curso::Schema::DVDRental::Result::Rental",
  { "foreign.staff_id" => "self.staff_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 store

Type: might_have

Related object: L<Curso::Schema::DVDRental::Result::Store>

=cut

__PACKAGE__->might_have(
  "store",
  "Curso::Schema::DVDRental::Result::Store",
  { "foreign.manager_staff_id" => "self.staff_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07042 @ 2015-05-22 11:11:49
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:qHIkwwi3CZPsMWPv95L0SQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
