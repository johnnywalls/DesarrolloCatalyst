use utf8;
package Curso::Schema::DVDRental::Result::FilmCategory;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Curso::Schema::DVDRental::Result::FilmCategory

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

=head1 TABLE: C<film_category>

=cut

__PACKAGE__->table("film_category");

=head1 ACCESSORS

=head2 film_id

  data_type: 'smallint'
  is_foreign_key: 1
  is_nullable: 0

=head2 category_id

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
  "film_id",
  { data_type => "smallint", is_foreign_key => 1, is_nullable => 0 },
  "category_id",
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

=item * L</film_id>

=item * L</category_id>

=back

=cut

__PACKAGE__->set_primary_key("film_id", "category_id");

=head1 RELATIONS

=head2 category

Type: belongs_to

Related object: L<Curso::Schema::DVDRental::Result::Category>

=cut

__PACKAGE__->belongs_to(
  "category",
  "Curso::Schema::DVDRental::Result::Category",
  { category_id => "category_id" },
  { is_deferrable => 0, on_delete => "RESTRICT", on_update => "CASCADE" },
);

=head2 film

Type: belongs_to

Related object: L<Curso::Schema::DVDRental::Result::Film>

=cut

__PACKAGE__->belongs_to(
  "film",
  "Curso::Schema::DVDRental::Result::Film",
  { film_id => "film_id" },
  { is_deferrable => 0, on_delete => "RESTRICT", on_update => "CASCADE" },
);


# Created by DBIx::Class::Schema::Loader v0.07042 @ 2015-05-22 11:11:49
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:BdM+C6WeUBRiWwpbLbJF/A


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
