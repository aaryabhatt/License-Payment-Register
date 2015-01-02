#!/usr/bin/perl -w
#
# Class/ServerInuse.pm
#
#created on 2014-07-18
#Tirveni Yadav
#


use strict;
use warnings;

our $VERSION = "1.00";

=head1 ServerInuse

=cut

package Class::ServerInuse;

#import Class Utils functions
use Class::Utils qw(makeparm selected_language unxss trim commify_series
		  get_array_from_argument get_keyval_from_arrayofhash
		  intersection sort_array);



=head2 new ($context,id,reverseofdomain)

Create ServerInuse Object

=cut

sub new
{
  my $proto       = shift;
  my $context     = shift;
  my $arg_ip	  = shift;
  my $reverseofdomain  = int(shift);
  my $type  = shift;

  #Class
  my $class = ref($proto) || $proto;
  my %selfh;
  my $self = \%selfh;

  $context->log->debug("C/ServerInuse/new: arg_ip:$arg_ip");

  #
  # What did we get?
  my $row;

  if(ref($arg_ip) )
  {
   $row = $arg_ip;
  }
  elsif ( $arg_ip && $reverseofdomain )
  {
    $row = $context->model('cashregister::ServerInuse')->find
      (
       {
	ip		=> $arg_ip,
	reverseofdomain	=> $reverseofdomain,
	type		=> $type,
       }
      );
  }

  $context->log->info("C/ServerInuse/new ROW: $row");
  return (undef)  unless $row;

  $self->{serverinuse_dbrecord}	= $row;
  $self->{context}		= $context;

  bless( $self, $class );

  return $self;

}

#END method new

=head2 dbrecord

Return the DBIx::Class::Row object for this Trip. Get the database object.

=cut

sub dbrecord
{
  my $self = shift;

  return ( $self->{serverinuse_dbrecord} );

}

#End method create

=head2 ip

Get ip of the Serverinuse

=cut

sub ip
{
  my $self = shift;

  return( $self->dbrecord->get_column('ip') );
}

=head2 type

Get type of the Serverinuse

=cut

sub type
{
  my $self = shift;

  return( $self->dbrecord->get_column('type') );
}

=head2 reverseofdomain

get reverseofdomain of the Serverinuse

=cut

sub reverseofdomain
{
  my $self = shift;

  my $r_s_reverseofdomain = $self->dbrecord->get_column('reverseofdomain');
  return $r_s_reverseofdomain;

}


#End method

=head2 valid

Set/Get valid of the Serverinuse

=cut

sub valid
{
  my $self = shift;

#Set Valid
  my  $valid = int(shift);
  if($valid == 1 || $valid == 0)
  {
    $self->dbrecord->set_column('valid', $valid)
  }

  return( $self->dbrecord->get_column('valid') );

}


=head2 priority

Get/Set priority of the Serverinuse

=cut

sub priority
{
  my $self = shift;

#Set Priority
  my  $priority = int(shift);
  if($priority > 0)
  {
    $self->dbrecord->set_column('priority', $priority)
  }

  return( $self->dbrecord->get_column('priority') );

}



=cut

=back

=cut

1;
