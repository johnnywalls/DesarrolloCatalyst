use utf8;
package Curso::Schema::DVDRental::Result::Rental;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Curso::Schema::DVDRental::Result::Rental

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

=item * L<DBIx::Class::TimeStamp>

=back

=cut

__PACKAGE__->load_components("InflateColumn::DateTime", "TimeStamp");

=head1 TABLE: C<rental>

=cut

__PACKAGE__->table("rental");

=head1 ACCESSORS

=head2 rental_id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0
  sequence: 'rental_rental_id_seq'

=head2 rental_date

  data_type: 'timestamp'
  is_nullable: 0

=head2 inventory_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 customer_id

  data_type: 'smallint'
  is_foreign_key: 1
  is_nullable: 0

=head2 return_date

  data_type: 'timestamp'
  is_nullable: 1

=head2 staff_id

  data_type: 'smallint'
  is_foreign_key: 1
  is_nullable: 0

=head2 last_update

  data_type: 'timestamp'
  default_value: current_timestamp
  is_nullable: 0
  original: {default_value => \"now()"}

=head2 expected_return_date

  data_type: 'timestamp'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "rental_id",
  {
    data_type         => "integer",
    is_auto_increment => 1,
    is_nullable       => 0,
    sequence          => "rental_rental_id_seq",
  },
  "rental_date",
  { data_type => "timestamp", is_nullable => 0 },
  "inventory_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "customer_id",
  { data_type => "smallint", is_foreign_key => 1, is_nullable => 0 },
  "return_date",
  { data_type => "timestamp", is_nullable => 1 },
  "staff_id",
  { data_type => "smallint", is_foreign_key => 1, is_nullable => 0 },
  "last_update",
  {
    data_type     => "timestamp",
    default_value => \"current_timestamp",
    is_nullable   => 0,
    original      => { default_value => \"now()" },
  },
  "expected_return_date",
  { data_type => "timestamp", is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</rental_id>

=back

=cut

__PACKAGE__->set_primary_key("rental_id");

=head1 UNIQUE CONSTRAINTS

=head2 C<idx_unq_rental_rental_date_inventory_id_customer_id>

=over 4

=item * L</rental_date>

=item * L</inventory_id>

=item * L</customer_id>

=back

=cut

__PACKAGE__->add_unique_constraint(
  "idx_unq_rental_rental_date_inventory_id_customer_id",
  ["rental_date", "inventory_id", "customer_id"],
);

=head1 RELATIONS

=head2 customer

Type: belongs_to

Related object: L<Curso::Schema::DVDRental::Result::Customer>

=cut

__PACKAGE__->belongs_to(
  "customer",
  "Curso::Schema::DVDRental::Result::Customer",
  { customer_id => "customer_id" },
  { is_deferrable => 0, on_delete => "RESTRICT", on_update => "CASCADE" },
);

=head2 inventory

Type: belongs_to

Related object: L<Curso::Schema::DVDRental::Result::Inventory>

=cut

__PACKAGE__->belongs_to(
  "inventory",
  "Curso::Schema::DVDRental::Result::Inventory",
  { inventory_id => "inventory_id" },
  { is_deferrable => 0, on_delete => "RESTRICT", on_update => "CASCADE" },
);

=head2 payments

Type: has_many

Related object: L<Curso::Schema::DVDRental::Result::Payment>

=cut

__PACKAGE__->has_many(
  "payments",
  "Curso::Schema::DVDRental::Result::Payment",
  { "foreign.rental_id" => "self.rental_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 staff

Type: belongs_to

Related object: L<Curso::Schema::DVDRental::Result::Staff>

=cut

__PACKAGE__->belongs_to(
  "staff",
  "Curso::Schema::DVDRental::Result::Staff",
  { staff_id => "staff_id" },
  { is_deferrable => 0, on_delete => "NO ACTION", on_update => "NO ACTION" },
);


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2015-09-09 19:41:59
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:RKaIsoE5QwY2JszH7T2caA

__PACKAGE__->add_columns(
  rental_date => {
    data_type => 'timestamp',
    set_on_create => 1,
  },
  last_update => {
    data_type => 'timestamp',
    set_on_create => 1,
    set_on_update => 1,
  }
);

=head1 CUSTOM METHODS

=head2 returned

Returns a string indicating if the given rental has already been returned

=cut

sub returned {
  my $self = shift;
  return ( $self->return_date ) ? 'Sí' : 'No';
}

# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
