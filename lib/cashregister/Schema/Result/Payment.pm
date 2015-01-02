package cashregister::Schema::Result::Payment;

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

cashregister::Schema::Result::Payment

=cut

__PACKAGE__->table("payment");

=head1 ACCESSORS

=head2 paymentid

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0
  sequence: 'payment_paymentid_seq'

=head2 license_no

  data_type: 'text'
  is_foreign_key: 1
  is_nullable: 1

=head2 amount

  data_type: 'text'
  is_nullable: 1

=head2 payment_date

  data_type: 'timestamp'
  is_nullable: 1

=head2 payment_status

  data_type: 'text'
  is_nullable: 1

=head2 receivedby

  data_type: 'text'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "paymentid",
  {
    data_type         => "integer",
    is_auto_increment => 1,
    is_nullable       => 0,
    sequence          => "payment_paymentid_seq",
  },
  "license_no",
  { data_type => "text", is_foreign_key => 1, is_nullable => 1 },
  "amount",
  { data_type => "text", is_nullable => 1 },
  "payment_date",
  { data_type => "timestamp", is_nullable => 1 },
  "payment_status",
  { data_type => "text", is_nullable => 1 },
  "receivedby",
  { data_type => "text", is_nullable => 1 },
);
__PACKAGE__->set_primary_key("paymentid");

=head1 RELATIONS

=head2 cancel_report

Type: might_have

Related object: L<cashregister::Schema::Result::CancelReport>

=cut

__PACKAGE__->might_have(
  "cancel_report",
  "cashregister::Schema::Result::CancelReport",
  { "foreign.paymentid" => "self.paymentid" },
  { cascade_copy => 0, cascade_delete => 0 },
);

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


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2014-12-31 17:06:43
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:RyqI8EtNkwiD4/uBLxi9nQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
