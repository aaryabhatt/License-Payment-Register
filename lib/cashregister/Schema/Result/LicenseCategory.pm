package cashregister::Schema::Result::LicenseCategory;

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

cashregister::Schema::Result::LicenseCategory

=cut

__PACKAGE__->table("license_category");

=head1 ACCESSORS

=head2 categoryid

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0
  sequence: 'license_category_categoryid_seq'

=head2 categoryname

  data_type: 'text'
  is_nullable: 1

=head2 categorydescription

  data_type: 'text'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "categoryid",
  {
    data_type         => "integer",
    is_auto_increment => 1,
    is_nullable       => 0,
    sequence          => "license_category_categoryid_seq",
  },
  "categoryname",
  { data_type => "text", is_nullable => 1 },
  "categorydescription",
  { data_type => "text", is_nullable => 1 },
);
__PACKAGE__->set_primary_key("categoryid");

=head1 RELATIONS

=head2 licenses

Type: has_many

Related object: L<cashregister::Schema::Result::License>

=cut

__PACKAGE__->has_many(
  "licenses",
  "cashregister::Schema::Result::License",
  { "foreign.categoryid" => "self.categoryid" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2014-12-31 17:02:07
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:orZg7qeXP4dl3UKCaowM9Q


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
