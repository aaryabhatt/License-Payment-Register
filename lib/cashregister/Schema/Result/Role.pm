package cashregister::Schema::Result::Role;

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

cashregister::Schema::Result::Role

=cut

__PACKAGE__->table("roles");

=head1 ACCESSORS

=head2 role

  data_type: 'char'
  is_nullable: 0
  size: 8

=head2 description

  data_type: 'text'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "role",
  { data_type => "char", is_nullable => 0, size => 8 },
  "description",
  { data_type => "text", is_nullable => 1 },
);
__PACKAGE__->set_primary_key("role");

=head1 RELATIONS

=head2 accesses

Type: has_many

Related object: L<cashregister::Schema::Result::Access>

=cut

__PACKAGE__->has_many(
  "accesses",
  "cashregister::Schema::Result::Access",
  { "foreign.role" => "self.role" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 appusers

Type: has_many

Related object: L<cashregister::Schema::Result::Appuser>

=cut

__PACKAGE__->has_many(
  "appusers",
  "cashregister::Schema::Result::Appuser",
  { "foreign.role" => "self.role" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2014-12-31 17:02:07
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:KvaOuOQIfYESSFtZL/9y2Q


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
