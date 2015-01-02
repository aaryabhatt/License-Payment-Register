package cashregister::Schema::Result::LicenseHolder;

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

cashregister::Schema::Result::LicenseHolder

=cut

__PACKAGE__->table("license_holder");

=head1 ACCESSORS

=head2 customerid

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0
  sequence: 'license_holder_customerid_seq'

=head2 license_no

  data_type: 'text'
  is_foreign_key: 1
  is_nullable: 1

=head2 title

  data_type: 'text'
  is_nullable: 1

=head2 name

  data_type: 'text'
  is_nullable: 1

=head2 relativename

  data_type: 'text'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "customerid",
  {
    data_type         => "integer",
    is_auto_increment => 1,
    is_nullable       => 0,
    sequence          => "license_holder_customerid_seq",
  },
  "license_no",
  { data_type => "text", is_foreign_key => 1, is_nullable => 1 },
  "title",
  { data_type => "text", is_nullable => 1 },
  "name",
  { data_type => "text", is_nullable => 1 },
  "relativename",
  { data_type => "text", is_nullable => 1 },
);
__PACKAGE__->set_primary_key("customerid");

=head1 RELATIONS

=head2 license_no

Type: belongs_to

Related object: L<cashregister::Schema::Result::License>

=cut

__PACKAGE__->belongs_to(
  "license_no",
  "cashregister::Schema::Result::License",
  { license_no => "license_no" },
  {
    is_deferrable => 1,
    join_type     => "LEFT",
    on_delete     => "CASCADE",
    on_update     => "CASCADE",
  },
);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2014-12-31 17:02:07
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:eF1ABpJVHKKmHKzVgY0nfw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
