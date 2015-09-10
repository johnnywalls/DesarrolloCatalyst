use utf8;
package Curso::Schema::DVDRental::Result::CustomerList;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Curso::Schema::DVDRental::Result::CustomerList

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
__PACKAGE__->table_class("DBIx::Class::ResultSource::View");

=head1 TABLE: C<customer_list>

=cut

__PACKAGE__->table("customer_list");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_nullable: 1

=head2 name

  data_type: 'text'
  is_nullable: 1

=head2 address

  data_type: 'varchar'
  is_nullable: 1
  size: 50

=head2 postal_code

  data_type: 'varchar'
  is_nullable: 1
  size: 10

=head2 phone

  data_type: 'varchar'
  is_nullable: 1
  size: 20

=head2 city

  data_type: 'varchar'
  is_nullable: 1
  size: 50

=head2 country

  data_type: 'varchar'
  is_nullable: 1
  size: 50

=head2 notes

  data_type: 'text'
  is_nullable: 1

=head2 sid

  data_type: 'smallint'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_nullable => 1 },
  "name",
  { data_type => "text", is_nullable => 1 },
  "address",
  { data_type => "varchar", is_nullable => 1, size => 50 },
  "postal_code",
  { data_type => "varchar", is_nullable => 1, size => 10 },
  "phone",
  { data_type => "varchar", is_nullable => 1, size => 20 },
  "city",
  { data_type => "varchar", is_nullable => 1, size => 50 },
  "country",
  { data_type => "varchar", is_nullable => 1, size => 50 },
  "notes",
  { data_type => "text", is_nullable => 1 },
  "sid",
  { data_type => "smallint", is_nullable => 1 },
);


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2015-09-09 19:41:59
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:IiFt5zZCrK0GITcoGXBGbg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
