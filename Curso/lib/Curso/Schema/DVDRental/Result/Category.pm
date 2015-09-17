use utf8;
package Curso::Schema::DVDRental::Result::Category;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Curso::Schema::DVDRental::Result::Category

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

=head1 TABLE: C<category>

=cut

__PACKAGE__->table("category");

=head1 ACCESSORS

=head2 category_id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0
  sequence: 'category_category_id_seq'

=head2 name

  data_type: 'varchar'
  is_nullable: 0
  size: 25

=head2 last_update

  data_type: 'timestamp'
  default_value: current_timestamp
  is_nullable: 0
  original: {default_value => \"now()"}

=cut

__PACKAGE__->add_columns(
  "category_id",
  {
    data_type         => "integer",
    is_auto_increment => 1,
    is_nullable       => 0,
    sequence          => "category_category_id_seq",
  },
  "name",
  { data_type => "varchar", is_nullable => 0, size => 25 },
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

=item * L</category_id>

=back

=cut

__PACKAGE__->set_primary_key("category_id");

=head1 UNIQUE CONSTRAINTS

=head2 C<uk_category_name>

=over 4

=item * L</name>

=back

=cut

__PACKAGE__->add_unique_constraint("uk_category_name", ["name"]);

=head1 RELATIONS

=head2 film_categories

Type: has_many

Related object: L<Curso::Schema::DVDRental::Result::FilmCategory>

=cut

__PACKAGE__->has_many(
  "film_categories",
  "Curso::Schema::DVDRental::Result::FilmCategory",
  { "foreign.category_id" => "self.category_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2015-09-16 19:59:15
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:OAyqF5/zjMNWF2JRFxpxow


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
