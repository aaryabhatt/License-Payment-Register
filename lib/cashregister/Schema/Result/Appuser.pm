package cashregister::Schema::Result::Appuser;

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

cashregister::Schema::Result::Appuser

=cut

__PACKAGE__->table("appuser");

=head1 ACCESSORS

=head2 userid

  data_type: 'text'
  is_nullable: 0

=head2 name

  data_type: 'text'
  is_nullable: 1

=head2 details

  data_type: 'text'
  is_nullable: 1

=head2 password

  data_type: 'text'
  is_nullable: 1

=head2 date_joined

  data_type: 'date'
  is_nullable: 1

=head2 active

  data_type: 'smallint'
  is_nullable: 1

=head2 role

  data_type: 'char'
  is_foreign_key: 1
  is_nullable: 1
  size: 8

=cut

__PACKAGE__->add_columns(
  "userid",
  { data_type => "text", is_nullable => 0 },
  "name",
  { data_type => "text", is_nullable => 1 },
  "details",
  { data_type => "text", is_nullable => 1 },
  "password",
  { data_type => "text", is_nullable => 1 },
  "date_joined",
  { data_type => "date", is_nullable => 1 },
  "active",
  { data_type => "smallint", is_nullable => 1 },
  "role",
  { data_type => "char", is_foreign_key => 1, is_nullable => 1, size => 8 },
);
__PACKAGE__->set_primary_key("userid");

=head1 RELATIONS

=head2 role

Type: belongs_to

Related object: L<cashregister::Schema::Result::Role>

=cut

__PACKAGE__->belongs_to(
  "role",
  "cashregister::Schema::Result::Role",
  { role => "role" },
  {
    is_deferrable => 1,
    join_type     => "LEFT",
    on_delete     => "CASCADE",
    on_update     => "CASCADE",
  },
);

=head2 cancel_reports

Type: has_many

Related object: L<cashregister::Schema::Result::CancelReport>

=cut

__PACKAGE__->has_many(
  "cancel_reports",
  "cashregister::Schema::Result::CancelReport",
  { "foreign.userid" => "self.userid" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2014-12-31 17:02:07
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:Q2V7xPt60NXghtZxoN+M4A


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
