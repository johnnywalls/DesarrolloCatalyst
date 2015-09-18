use utf8;
package Curso::Schema::DVDRental::Result::StaffRole;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Curso::Schema::DVDRental::Result::StaffRole

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

=head1 TABLE: C<staff_role>

=cut

__PACKAGE__->table("staff_role");

=head1 ACCESSORS

=head2 role_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 staff_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "role_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "staff_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</role_id>

=item * L</staff_id>

=back

=cut

__PACKAGE__->set_primary_key("role_id", "staff_id");

=head1 RELATIONS

=head2 role

Type: belongs_to

Related object: L<Curso::Schema::DVDRental::Result::Role>

=cut

__PACKAGE__->belongs_to(
  "role",
  "Curso::Schema::DVDRental::Result::Role",
  { role_id => "role_id" },
  { is_deferrable => 0, on_delete => "NO ACTION", on_update => "NO ACTION" },
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


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2015-09-18 01:41:01
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:mBBiwcB8iL8UT16ayq1O+Q


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
