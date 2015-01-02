#!/usr/bin/perl -w
#
# Class/Appuser.pm

#
# Created on 2014-07-15
# Tirveni Yadav
#

use strict;
use warnings;

our $VERSION = "1.00";

=head1 Appuser

=cut

package Class::Appuser;

use Digest::SHA qw/sha1_hex/;
use String::MkPasswd qw(mkpasswd);  # To generate Random Password.

=head2 new

Create Appuser object.

=cut

sub new
{
  my $proto		= shift;
  my $context    = shift;
  my $arg_userid = shift;

  my $class = ref($proto) || $proto;
  my %selfh;
  my $self = \%selfh;

  $context->log->debug("C/appuser/new ROW:$arg_userid");

  my $rs_user    = $arg_userid;

  unless ( ref($arg_userid) )
  {
    $rs_user = $context->model('cashregister::Appuser')->find($arg_userid);
  }

	return (undef)
    unless $rs_user;

  $self->{buser_dbrecord} = $rs_user;
  $self->{context}        = $context;
  bless( $self, $class );

return $self;

}
#END new

=head2 dbrecord

Return the DBIx::Class::Row object for this Appuser.Get the database object.

=cut

sub dbrecord
{
  my $self = shift;
  return ( $self->{buser_dbrecord} );
}
#END dbrecord

=head2 create

create new User.

=cut

sub create
{
  my $context = shift;
  my $pars    = shift;

  my $mrec = $context->model('cashregister::Appuser')->find_or_create($pars);
  return ( Class::Appuser->new( $context, $mrec ) );

}
#END Create

=head2 create_with_pass ($context , $attribs)

This method generates a password for the User (Role client).

=cut

sub create_with_pass
{
  my $context	= shift;
  my $attribs	= shift;

  my $user_obj ;
  my $fx = "C/Appuser/create_with_pass";

  my $str_password = mkpasswd();
  $context->log->debug("$fx passwd: $str_password");

  my $userid  = $attribs->{userid};
  $user_obj = Class::Appuser->new($context,$userid);

  $attribs->{password}	= $str_password;
  $attribs->{role}	= 'CLIENT';

  $user_obj = Class::Appuser::create($context,$attribs)
    if(! $user_obj );

  return $user_obj;

}

=head1 Get/Set methods

=head2 userid

get/set date_joined of the User

=cut

sub userid
{
  my $self = shift;

  #Return the date_joined of the Appuser
  my $r_userid = $self->dbrecord->get_column('userid');
return $r_userid;

}
#END userid

=head2 aname

get/set name of the User

=cut

sub aname
{
  my $self = shift;
  my $name = shift;

  #Set the Name if input is given
  $self->buser_dbrecord->set_column( 'name', $name )
    if defined($name);

  #Return the name of the Appuser
  my $rname = $self->dbrecord->get_column('name');
return $rname;

}
#END method aname

=head2 details

get/set details of the User

=cut

sub details
{
  my $self    = shift;
  my $details = shift;

  #Set the Details if input is given
  $self->buser_dbrecord->set_column( 'details', $details )
    if defined($details);

  #Return the details of the Appuser
  my $rdetails = $self->dbrecord->get_column('details');
return $rdetails;

}
#END method details

=head2  active

get/set active of the User

=cut

sub active
{
  my $self   = shift;
  my $active = shift;

  #Set the Active if input is given
  $self->buser_dbrecord->set_column( 'active', $active )
    if defined($active);

  #Return the active of the Appuser
  my $ractive = $self->dbrecord->get_column('active');
return $ractive;

}
#END method active

=head2 date_joined

get/set date_joined of the User

=cut

sub date_joined
{
  my $self = shift;

  #Return the date_joined of the Appuser
  my $rdate_joined = $self->dbrecord->get_column('date_joined');
return $rdate_joined;

}
#END method date_joined

=head2 role

get role of the User

=cut

sub role
{
  my $self = shift;

  #Return the role of the Appuser
  my $r_role = $self->dbrecord->get_column('role');
return $r_role;

}
#END method role

=head2 role_name

get role of the User

=cut

sub role_name
{
  my $self    = shift;
  my $context = shift;

  my $rs_role = $self->role;
  my $r_name;

  my $mrec = $context->model('cashregister::Roles')->find( {role => $rs_role,} );

  if ($mrec)
  {
    $r_name = $mrec->get_column('description');
  }

return $r_name;

}
#END method role_name

=head1 Authorisation

=head2 user_allowed

check if user is allowed to use this action

=cut

sub user_allowed
{

  my $self = shift;
  my $c    = shift;    #context

  my $role   = $self->role;
  my $action = $c->action();

  $action = "/$action";
  $c->log->info("C/appuser/user_allowed: ROLE: $role CHECK: $action");

  my $rs_access = $c->model('cashregister::Access')->search( {role => $role,} );

  while ( my $r = $rs_access->next() )
  {
    my $r_access = $r->get_column('privilege');
    my $access   = "$r_access";

    $c->log->info("C/appuser/user_allowed: CMP :: $action == $access ");
    if ( $action eq $r_access )
    {
	$c->log->info("C/appuser/user_allowed: FOUND Go Ahead");
	return 1;
    }

  }

return 0;

}
#END method user_allowed

=head2 privilege_exist

check if privilege exist is allowed to use this action

=cut

sub privilege_exist
{

  my $self   = shift;
  my $c      = shift;          #context
  my $action = $c->action();

  $action = "/$action";
  $c->log->info("C/appuser/privilege_exist: CHECK if $action exist in cashregister");

  my $rs_privilege =
    $c->model('cashregister::Privilege')->search( {privilege => $action,} );

  $c->log->info("C/appuser/privilege_exist: $rs_privilege");

  if ( $rs_privilege > 0 )
  {
    $c->log->info("C/appuser/privilege_exist: FOUND Go Ahead $action");
  return 1;
  }
  else
  {
    $c->log->info("C/appuser/privilege_exist: **STOP** $action");
  return 0;
  }

}
#END method privilege exist


=head2 changeallowed($c,$role_first ,$role_second ) Private

This Fn returns TRUE if the First Role can make changes to the Second
Role.

=cut

sub changeallowed
{
  my $c           = shift;
  my $first_role  = shift;
  my $second_role = shift;

  return undef;

}

=item B<encode_password($context, $password )>

Encode a plain-text password into the format required by the
Authentication module for storage in the DB.  Currently only handles
SHA-1 hashes.

Return the encoded password, which can be stored in the database.

=cut
# Encode a password
sub encode_password
{
  my
    $context = shift;
  my
    $password = shift;

  if ($password)
  {
    use Digest::SHA qw/sha1_base64/;
    return( sha1_base64($password) );
  }

  return( undef );

}




=back

=cut

1;
