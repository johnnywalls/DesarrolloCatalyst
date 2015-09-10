use utf8;
package Curso::Schema::DVDRental::Result::Customer;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Curso::Schema::DVDRental::Result::Customer

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

=head1 TABLE: C<customer>

=cut

__PACKAGE__->table("customer");

=head1 ACCESSORS

=head2 customer_id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0
  sequence: 'customer_customer_id_seq'

=head2 store_id

  data_type: 'smallint'
  is_nullable: 0

=head2 first_name

  data_type: 'varchar'
  is_nullable: 0
  size: 45

=head2 last_name

  data_type: 'varchar'
  is_nullable: 0
  size: 45

=head2 email

  data_type: 'varchar'
  is_nullable: 1
  size: 50

=head2 address_id

  data_type: 'smallint'
  is_foreign_key: 1
  is_nullable: 0

=head2 activebool

  data_type: 'boolean'
  default_value: true
  is_nullable: 0

=head2 create_date

  data_type: 'date'
  default_value: ('now'::text)::date
  is_nullable: 0

=head2 last_update

  data_type: 'timestamp'
  default_value: current_timestamp
  is_nullable: 1
  original: {default_value => \"now()"}

=head2 active

  data_type: 'integer'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "customer_id",
  {
    data_type         => "integer",
    is_auto_increment => 1,
    is_nullable       => 0,
    sequence          => "customer_customer_id_seq",
  },
  "store_id",
  { data_type => "smallint", is_nullable => 0 },
  "first_name",
  { data_type => "varchar", is_nullable => 0, size => 45 },
  "last_name",
  { data_type => "varchar", is_nullable => 0, size => 45 },
  "email",
  { data_type => "varchar", is_nullable => 1, size => 50 },
  "address_id",
  { data_type => "smallint", is_foreign_key => 1, is_nullable => 0 },
  "activebool",
  { data_type => "boolean", default_value => \"true", is_nullable => 0 },
  "create_date",
  {
    data_type     => "date",
    default_value => \"('now'::text)::date",
    is_nullable   => 0,
  },
  "last_update",
  {
    data_type     => "timestamp",
    default_value => \"current_timestamp",
    is_nullable   => 1,
    original      => { default_value => \"now()" },
  },
  "active",
  { data_type => "integer", is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</customer_id>

=back

=cut

__PACKAGE__->set_primary_key("customer_id");

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
  { "foreign.customer_id" => "self.customer_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 rentals

Type: has_many

Related object: L<Curso::Schema::DVDRental::Result::Rental>

=cut

__PACKAGE__->has_many(
  "rentals",
  "Curso::Schema::DVDRental::Result::Rental",
  { "foreign.customer_id" => "self.customer_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2015-08-04 17:21:56
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:CoOorykEdBbKsG+QO1AdYw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
