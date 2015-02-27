package cashregister::Schema::Result::License;

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

cashregister::Schema::Result::License

=cut

__PACKAGE__->table("license");

=head1 ACCESSORS

=head2 licenseid

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0
  sequence: 'license_licenseid_seq'

=head2 categoryid

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 1

=head2 license_no

  data_type: 'text'
  is_nullable: 0

=head2 license_type

  data_type: 'text'
  is_nullable: 1

=head2 validity_start

  data_type: 'date'
  is_nullable: 1

=head2 validity_end

  data_type: 'date'
  is_nullable: 1

=head2 entry_date

  data_type: 'timestamp'
  default_value: current_timestamp
  is_nullable: 1
  original: {default_value => \"now()"}

=cut

__PACKAGE__->add_columns(
  "licenseid",
  {
    data_type         => "integer",
    is_auto_increment => 1,
    is_nullable       => 0,
    sequence          => "license_licenseid_seq",
  },
  "categoryid",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 1 },
  "license_no",
  { data_type => "text", is_nullable => 0 },
  "license_type",
  { data_type => "text", is_nullable => 1 },
  "validity_start",
  { data_type => "date", is_nullable => 1 },
  "validity_end",
  { data_type => "date", is_nullable => 1 },
  "entry_date",
  {
    data_type     => "timestamp",
    default_value => \"current_timestamp",
    is_nullable   => 1,
    original      => { default_value => \"now()" },
  },
);
__PACKAGE__->set_primary_key("license_no");

=head1 RELATIONS

=head2 address

Type: might_have

Related object: L<cashregister::Schema::Result::Address>

=cut

__PACKAGE__->might_have(
  "address",
  "cashregister::Schema::Result::Address",
  { "foreign.license_no" => "self.license_no" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 cancel_reports

Type: has_many

Related object: L<cashregister::Schema::Result::CancelReport>

=cut

__PACKAGE__->has_many(
  "cancel_reports",
  "cashregister::Schema::Result::CancelReport",
  { "foreign.license_no" => "self.license_no" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 categoryid

Type: belongs_to

Related object: L<cashregister::Schema::Result::LicenseCategory>

=cut

__PACKAGE__->belongs_to(
  "categoryid",
  "cashregister::Schema::Result::LicenseCategory",
  { categoryid => "categoryid" },
  {
    is_deferrable => 1,
    join_type     => "LEFT",
    on_delete     => "CASCADE",
    on_update     => "CASCADE",
  },
);

=head2 license_holders

Type: has_many

Related object: L<cashregister::Schema::Result::LicenseHolder>

=cut

__PACKAGE__->has_many(
  "license_holders",
  "cashregister::Schema::Result::LicenseHolder",
  { "foreign.license_no" => "self.license_no" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 payments

Type: has_many

Related object: L<cashregister::Schema::Result::Payment>

=cut

__PACKAGE__->has_many(
  "payments",
  "cashregister::Schema::Result::Payment",
  { "foreign.license_no" => "self.license_no" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2015-01-30 20:03:01
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:buOTQ64JOcGb/HU0TI3elg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
