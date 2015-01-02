package cashregister::Schema::Result::Access;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';

__PACKAGE__->load_components("InflateColumn::DateTime", "TimeStamp", "EncodedColumn");

=head1 NAME

cashregister::Schema::Result::Access

=cut

__PACKAGE__->table("access");

=head1 ACCESSORS

=head2 role

  data_type: 'char'
  is_foreign_key: 1
  is_nullable: 0
  size: 8

=head2 privilege

  data_type: 'text'
  is_foreign_key: 1
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "role",
  { data_type => "char", is_foreign_key => 1, is_nullable => 0, size => 8 },
  "privilege",
  { data_type => "text", is_foreign_key => 1, is_nullable => 0 },
);
__PACKAGE__->set_primary_key("role", "privilege");

=head1 RELATIONS

=head2 role

Type: belongs_to

Related object: L<cashregister::Schema::Result::Role>

=cut

__PACKAGE__->belongs_to(
  "role",
  "cashregister::Schema::Result::Role",
  { role => "role" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);

=head2 privilege

Type: belongs_to

Related object: L<cashregister::Schema::Result::Privilege>

=cut

__PACKAGE__->belongs_to(
  "privilege",
  "cashregister::Schema::Result::Privilege",
  { privilege => "privilege" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2014-12-31 17:02:07
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:onTe3swHO+qtqlGXNeOV8w


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
