use utf8;
package Curso::Schema::DVDRental::Result::Store;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Curso::Schema::DVDRental::Result::Store

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

=head1 TABLE: C<store>

=cut

__PACKAGE__->table("store");

=head1 ACCESSORS

=head2 store_id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0
  sequence: 'store_store_id_seq'

=head2 manager_staff_id

  data_type: 'smallint'
  is_foreign_key: 1
  is_nullable: 0

=head2 address_id

  data_type: 'smallint'
  is_foreign_key: 1
  is_nullable: 0

=head2 last_update

  data_type: 'timestamp'
  default_value: current_timestamp
  is_nullable: 0
  original: {default_value => \"now()"}

=cut

__PACKAGE__->add_columns(
  "store_id",
  {
    data_type         => "integer",
    is_auto_increment => 1,
    is_nullable       => 0,
    sequence          => "store_store_id_seq",
  },
  "manager_staff_id",
  { data_type => "smallint", is_foreign_key => 1, is_nullable => 0 },
  "address_id",
  { data_type => "smallint", is_foreign_key => 1, is_nullable => 0 },
  "last_update",
  {
    data_type     => "timestamp",
    default_value => \"current_timestamp",
    is_nullable   => 0,
    original      => { default_value => \"now()" },
  },
);

=head1 PRIMARY KEY

=over 4

=item * L</store_id>

=back

=cut

__PACKAGE__->set_primary_key("store_id");

=head1 UNIQUE CONSTRAINTS

=head2 C<idx_unq_manager_staff_id>

=over 4

=item * L</manager_staff_id>

=back

=cut

__PACKAGE__->add_unique_constraint("idx_unq_manager_staff_id", ["manager_staff_id"]);

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

=head2 manager_staff

Type: belongs_to

Related object: L<Curso::Schema::DVDRental::Result::Staff>

=cut

__PACKAGE__->belongs_to(
  "manager_staff",
  "Curso::Schema::DVDRental::Result::Staff",
  { staff_id => "manager_staff_id" },
  { is_deferrable => 0, on_delete => "RESTRICT", on_update => "CASCADE" },
);


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2015-08-04 17:21:56
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:i3e6C2d3wzFvmBDKiZhsyA


# You can replace this text with custom code or comments, and it will be preserved on regeneration

=head1 CUSTOM METHODS

=head2 name

=cut

sub name {
  my $self = shift;
  return $self->address->address . ' (' . $self->address->district . ', '. $self->address->city->city . ')'
}

__PACKAGE__->meta->make_immutable;
1;
