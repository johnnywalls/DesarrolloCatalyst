use utf8;
package Curso::Schema::DVDRental::Result::FilmList;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Curso::Schema::DVDRental::Result::FilmList

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
__PACKAGE__->table_class("DBIx::Class::ResultSource::View");

=head1 TABLE: C<film_list>

=cut

__PACKAGE__->table("film_list");

=head1 ACCESSORS

=head2 fid

  data_type: 'integer'
  is_nullable: 1

=head2 title

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 description

  data_type: 'text'
  is_nullable: 1

=head2 category

  data_type: 'varchar'
  is_nullable: 1
  size: 25

=head2 price

  data_type: 'numeric'
  is_nullable: 1
  size: [4,2]

=head2 length

  data_type: 'smallint'
  is_nullable: 1

=head2 rating

  data_type: 'enum'
  extra: {custom_type_name => "mpaa_rating",list => ["G","PG","PG-13","R","NC-17"]}
  is_nullable: 1

=head2 actors

  data_type: 'text'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "fid",
  { data_type => "integer", is_nullable => 1 },
  "title",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "description",
  { data_type => "text", is_nullable => 1 },
  "category",
  { data_type => "varchar", is_nullable => 1, size => 25 },
  "price",
  { data_type => "numeric", is_nullable => 1, size => [4, 2] },
  "length",
  { data_type => "smallint", is_nullable => 1 },
  "rating",
  {
    data_type => "enum",
    extra => {
      custom_type_name => "mpaa_rating",
      list => ["G", "PG", "PG-13", "R", "NC-17"],
    },
    is_nullable => 1,
  },
  "actors",
  { data_type => "text", is_nullable => 1 },
);


# Created by DBIx::Class::Schema::Loader v0.07042 @ 2015-05-22 11:11:49
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:80M/EbUDdZmx5Sxnsos2yg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
