use utf8;
package Curso::Schema::DVDRental::Result::SaleByFilmCategory;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Curso::Schema::DVDRental::Result::SaleByFilmCategory

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

=head1 TABLE: C<sales_by_film_category>

=cut

__PACKAGE__->table("sales_by_film_category");

=head1 ACCESSORS

=head2 category

  data_type: 'varchar'
  is_nullable: 1
  size: 25

=head2 total_sales

  data_type: 'numeric'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "category",
  { data_type => "varchar", is_nullable => 1, size => 25 },
  "total_sales",
  { data_type => "numeric", is_nullable => 1 },
);


# Created by DBIx::Class::Schema::Loader v0.07042 @ 2015-05-22 11:11:49
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:ZRx2c5vtc5cDtMfYKZsctg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
