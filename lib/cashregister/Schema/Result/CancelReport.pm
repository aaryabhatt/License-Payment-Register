package cashregister::Schema::Result::CancelReport;

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

cashregister::Schema::Result::CancelReport

=cut

__PACKAGE__->table("cancel_report");

=head1 ACCESSORS

=head2 paymentid

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 cancel_date

  data_type: 'timestamp'
  is_nullable: 1

=head2 userid

  data_type: 'text'
  is_foreign_key: 1
  is_nullable: 1

=head2 description

  data_type: 'text'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "paymentid",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "cancel_date",
  { data_type => "timestamp", is_nullable => 1 },
  "userid",
  { data_type => "text", is_foreign_key => 1, is_nullable => 1 },
  "description",
  { data_type => "text", is_nullable => 1 },
);
__PACKAGE__->set_primary_key("paymentid");

=head1 RELATIONS

=head2 paymentid

Type: belongs_to

Related object: L<cashregister::Schema::Result::Payment>

=cut

__PACKAGE__->belongs_to(
  "paymentid",
  "cashregister::Schema::Result::Payment",
  { paymentid => "paymentid" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);

=head2 userid

Type: belongs_to

Related object: L<cashregister::Schema::Result::Appuser>

=cut

__PACKAGE__->belongs_to(
  "userid",
  "cashregister::Schema::Result::Appuser",
  { userid => "userid" },
  {
    is_deferrable => 1,
    join_type     => "LEFT",
    on_delete     => "CASCADE",
    on_update     => "CASCADE",
  },
);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2014-12-31 17:06:43
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:2vAqSzKsCzl61m0v48YGCg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
