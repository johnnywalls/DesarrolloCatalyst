use utf8;
package Curso::Schema::DVDRental::Result::Film;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Curso::Schema::DVDRental::Result::Film

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

=head1 TABLE: C<film>

=cut

__PACKAGE__->table("film");

=head1 ACCESSORS

=head2 film_id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0
  sequence: 'film_film_id_seq'

=head2 title

  data_type: 'varchar'
  is_nullable: 0
  size: 255

=head2 description

  data_type: 'text'
  is_nullable: 1

=head2 release_year

  data_type: 'year'
  is_nullable: 1
  size: 4

=head2 language_id

  data_type: 'smallint'
  is_foreign_key: 1
  is_nullable: 0

=head2 rental_duration

  data_type: 'smallint'
  default_value: 3
  is_nullable: 0

=head2 rental_rate

  data_type: 'numeric'
  default_value: 4.99
  is_nullable: 0
  size: [4,2]

=head2 length

  data_type: 'smallint'
  is_nullable: 1

=head2 replacement_cost

  data_type: 'numeric'
  default_value: 19.99
  is_nullable: 0
  size: [5,2]

=head2 rating

  data_type: 'enum'
  default_value: 'G'
  extra: {custom_type_name => "mpaa_rating",list => ["G","PG","PG-13","R","NC-17"]}
  is_nullable: 1

=head2 last_update

  data_type: 'timestamp'
  default_value: current_timestamp
  is_nullable: 0
  original: {default_value => \"now()"}

=head2 special_features

  data_type: 'text[]'
  is_nullable: 1

=head2 fulltext

  data_type: 'tsvector'
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "film_id",
  {
    data_type         => "integer",
    is_auto_increment => 1,
    is_nullable       => 0,
    sequence          => "film_film_id_seq",
  },
  "title",
  { data_type => "varchar", is_nullable => 0, size => 255 },
  "description",
  { data_type => "text", is_nullable => 1 },
  "release_year",
  { data_type => "year", is_nullable => 1, size => 4 },
  "language_id",
  { data_type => "smallint", is_foreign_key => 1, is_nullable => 0 },
  "rental_duration",
  { data_type => "smallint", default_value => 3, is_nullable => 0 },
  "rental_rate",
  {
    data_type => "numeric",
    default_value => 4.99,
    is_nullable => 0,
    size => [4, 2],
  },
  "length",
  { data_type => "smallint", is_nullable => 1 },
  "replacement_cost",
  {
    data_type => "numeric",
    default_value => 19.99,
    is_nullable => 0,
    size => [5, 2],
  },
  "rating",
  {
    data_type => "enum",
    default_value => "G",
    extra => {
      custom_type_name => "mpaa_rating",
      list => ["G", "PG", "PG-13", "R", "NC-17"],
    },
    is_nullable => 1,
  },
  "last_update",
  {
    data_type     => "timestamp",
    default_value => \"current_timestamp",
    is_nullable   => 0,
    original      => { default_value => \"now()" },
  },
  "special_features",
  { data_type => "text[]", is_nullable => 1 },
  "fulltext",
  { data_type => "tsvector", is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</film_id>

=back

=cut

__PACKAGE__->set_primary_key("film_id");

=head1 RELATIONS

=head2 film_actors

Type: has_many

Related object: L<Curso::Schema::DVDRental::Result::FilmActor>

=cut

__PACKAGE__->has_many(
  "film_actors",
  "Curso::Schema::DVDRental::Result::FilmActor",
  { "foreign.film_id" => "self.film_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 film_categories

Type: has_many

Related object: L<Curso::Schema::DVDRental::Result::FilmCategory>

=cut

__PACKAGE__->has_many(
  "film_categories",
  "Curso::Schema::DVDRental::Result::FilmCategory",
  { "foreign.film_id" => "self.film_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 inventories

Type: has_many

Related object: L<Curso::Schema::DVDRental::Result::Inventory>

=cut

__PACKAGE__->has_many(
  "inventories",
  "Curso::Schema::DVDRental::Result::Inventory",
  { "foreign.film_id" => "self.film_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 language

Type: belongs_to

Related object: L<Curso::Schema::DVDRental::Result::Language>

=cut

__PACKAGE__->belongs_to(
  "language",
  "Curso::Schema::DVDRental::Result::Language",
  { language_id => "language_id" },
  { is_deferrable => 0, on_delete => "RESTRICT", on_update => "CASCADE" },
);


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2015-08-04 17:21:56
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:1LM+/ekbUZV+js7H1KOlmg


# You can replace this text with custom code or comments, and it will be preserved on regeneration

=head1 CUSTOM METHODS

=head2 categories

Type: many_to_many

Related object: L<Curso::Schema::DVDRental::Result::Category>

=cut

__PACKAGE__->many_to_many( 'categories' => 'film_categories', 'category' );

=head2 categories_names

Returns the names of all categories associated with this film, as single string

=cut

sub categories_names {
  my $self = shift;
  return join ', ', $self->categories->get_column('name')->all;
}

=head2 recent_rentals

Returns the resultset of recent rentals registered for this film.  Accepts optional filter
and limit parameters

=cut

sub recent_rentals {
  my $self = shift;
  my $filters = shift if @_;
  my $limit = shift if @_;

  $limit = 10 unless defined $limit;
  $filters->{ 'inventory.film_id' } = $self->id;

  my $schema = $self->result_source->schema;
  return $schema->resultset('Rental')->search( $filters, {
    join => [ 'inventory', 'customer' ],
    rows => $limit,
    order_by => { '-desc' => 'rental_date' },
  });
}

__PACKAGE__->meta->make_immutable;
1;
