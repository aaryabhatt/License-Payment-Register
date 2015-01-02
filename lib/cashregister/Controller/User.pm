package cashregister::Controller::User;
use Moose;
use namespace::autoclean;

BEGIN {extends 'Catalyst::Controller'; }

use Class::Utils qw(makeparm selected_language unxss chomp_date trim);

=head1 NAME

cashregister::Controller::User - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut

#sub index :Path :Args(0) {
#    my ( $self, $c ) = @_;

#    $c->response->body('Matched cashregister::Controller::User in User.');
#}

sub index :Path
{

  my $self                = shift;
  my $c                   = shift;

  $c->response->body
    ('Matched cashregister::Controller::User in Itinerary.');

  $c->redirect('/user/list');

}

=head2 list

List Users

=cut

sub list :Path('/user/list')
{

  my $self              = shift;
  my $c                 = shift;

  my $fn_name           ;#= shift;
  my $startpage         = shift;
  my $desired_page      = shift || 1 ;

  my $f = "User/list";
  $c->log->debug("$f spage:$fn_name, StartPage: $startpage,".
                 " desired_page:$desired_page");

##USer Operating
#
  my ( $i_user_exist, $i_login );
  my ($obj_user,$logged_user_role);

  $logged_user_role='GUEST';
  $i_login = 'UNKN';

  $i_user_exist = $c->user_exists;

  if ($i_user_exist)
  {
    $i_login = $c->user->get('userid');
    $obj_user = Class::Appuser->new( $c, $i_login );
    $logged_user_role = trim($c,$obj_user->role);
  }
$c->log->debug("$f i_login:$i_login");
  $c->log->debug("$f Logged user obj:$obj_user");
  $c->log->debug("$f Logged Role: -$logged_user_role-");


  if ($obj_user && !($logged_user_role eq 'ADMIN' )
      &&  !($logged_user_role eq 'MANAGER')  )
  {

    $c->log->debug("$f User Pref. for Role: $logged_user_role. ");

    if (     $logged_user_role eq 'STAFF' )
    {

      $c->log->debug("$f $logged_user_role cmp GUEST ");
      my $str_redirect = "/user/modify/userid=$i_login";
      $c->log->debug("$f REDIRECT URL:$str_redirect");

 ##Redirect
      $c->res->redirect( $c->uri_for($str_redirect) );
      $c->detach();

    }

  }
  elsif ($logged_user_role eq 'GUEST' )
  {

    $c->log->debug("$f $logged_user_role. GUEST");
    my $str_redirect = "/home";
    $c->log->debug("$f REDIRECT URL:$str_redirect");
    ##Redirect
    $c->res->redirect( $c->uri_for($str_redirect) );
    $c->detach();

  }
 my $rows_per_page = 10;
  my @order_list = ('userid','role');

  my %page_attribs;
  my $user_searchterm = $c->session->{'TripSearchTerm'};
  %page_attribs =
    (
     desiredpage  => $desired_page,
     startpage    => $startpage,
     rowsperpage  => $rows_per_page,
     inputsearch  => $user_searchterm,
     order        => \@order_list,
     listname     => 'Users',
     namefn       => 'list',
     nameclass    => 'user',
    );
 my $table_users = $c->model('cashregister::Appuser')->search() ;
  my $rs_users = Class::General::paginationx
    ( $c, \%page_attribs,$table_users );

  my @list;
  while ( my $user = $rs_users->next() )
  {

    my $str_active      = 'No';
    my $active          = $user->active;
    $str_active= 'Yes'
      if ($active);
 push
      (@list,
       {
        userid          => $user->userid,
        name            => $user->name,
        details         => $user->details,
        active          => $str_active,
        role            => $user->get_column('role'),
       }
      );

  }

  $c->stash->{users} = \@list;
  $c->stash->{page} = {'title' => 'List Users' };
  $c->stash->{template} = 'src/User/list.tt';


}
=head2 modify

Modify Users.

Need to move most of logic to the Class.

=cut

sub modify :Path('/user/modify')
{

  my $self              = shift;
  my $c                 = shift;
 $c->stash->{page} = {'title' => 'Modify User' };
  $c->stash->{template} = 'src/User/add.tt';

    # Input Types
  my $pars      = makeparm(@_);
  my $aparams   = $c->request->params;

  my $fn = "User/modify";

##USer Operating
#
  my $i_login = $c->user->get('userid');
  my $obj_user = Class::Appuser->new( $c, $i_login );
  $c->log->debug("$fn Logged user obj:$obj_user");
  my $logged_user_role = trim($c,$obj_user->role);

##User Selected for modification.
##
 my $sel_userid = $pars->{userid} || $aparams->{userid};
  $c->log->debug("$fn IN User id:$sel_userid");
  $sel_userid  = unxss($sel_userid);
  my $sel_user = Class::Appuser->new($c,$sel_userid);
  $c->log->debug("$fn IN user obj:$sel_user");
  my $sel_role = trim($c,$sel_user->role);
  my $current_active_ness = $sel_user->active;

  my $change_allowed;

=head3 Check if Change is allowed

IF the user-operating and user-selected are same. Then Change is
allowed.

OR Check through ChangeAllowed fx

=cut

  $c->log->info("$fn Selected Role:-$sel_role-");
  my $user_is_self ;
  if($sel_role eq 'GUEST')
  {
    $c->log->info("$fn Cannot be modified. As selected Role:$sel_role");
  }
  elsif ( $i_login eq $sel_userid)
  {
    $user_is_self = 1;
    $c->stash->{user_is_self} = $user_is_self;
    $c->log->info("$fn Same User");
    $change_allowed = 1;
  }
  elsif($sel_user)
  {  my $userid    = $c->user->get('userid');

    $change_allowed = Class::Appuser::changeallowed
      ($c,$logged_user_role,$sel_role)
        if($sel_role && $logged_user_role);
  }
=head3 Make changes

If the userid if submitted Or change_allowed is set.

After the change come back to the same page.With new info.

=cut

  if ( $change_allowed && ($aparams->{userid}) )
  {
    $c->log->debug("$fn Inside if Update User");

    my $name    = unxss($aparams->{name});
    my $rs_user = $sel_user->dbrecord;
    $c->log->debug("$fn Inside RS: $rs_user, NEW Name: $name");

    $rs_user->name($name);
    $name = $rs_user->name;
    $c->log->debug("$fn Inside Name is Set: $name");

    my $user_is_active   = int($aparams->{active})
      if($aparams->{active});
    $c->log->debug("$fn Inside Old Act:$current_active_ness".
                   " New Act:$user_is_active ");


    my ($in_enc_password, $e_stored_password);
    my $in_current_pass ;
    if($user_is_self)
    {
      $in_current_pass = trim($c,$aparams->{passwordc});
      $c->log->debug("Inside Current PW: $in_current_pass");

      $in_enc_password =
        Class::Appuser::encode_password($c,$in_current_pass);
      $e_stored_password = $rs_user->password;
      $c->log->debug("Inside Current PW: $in_current_pass:".
                    "$in_enc_password cmp $e_stored_password ");
    }
    elsif($current_active_ness ne $user_is_active)
    {
      my $make_active = 0;
      if( $user_is_active eq 200)
      {
        $make_active = 1 ;
      }
      $rs_user->active($make_active);
    }

    my ($a_pass,$b_pass);
    $a_pass = trim($c,$aparams->{passworda});
    $b_pass = trim($c,$aparams->{passwordb});
=head3 Password Handling

Change password if current password is same as stored in db for self
user. And both new pw are same.

OR

Change password if both new passwords are same for other users.

=cut

    if($user_is_self && $in_current_pass &&
       $in_enc_password eq $e_stored_password)
    {
      change_password($c,$rs_user,$a_pass,$b_pass);
    }
    elsif( !($user_is_self) && $a_pass && $b_pass)
    {
      change_password($c,$rs_user,$a_pass,$b_pass);
    }

    my $in_details = $aparams->{details};
 my $stored_details = $rs_user->details;

    if($in_details ne $stored_details)
    {
      $rs_user->details($in_details);
    }

    $rs_user->update;

    my $str_redirect = "/user/modify/userid=$sel_userid";
    $c->log->debug("$fn REDIRECT URL:$str_redirect");

##Redirect
    $c->res->redirect( $c->uri_for($str_redirect) );
    $c->detach();

  }
#Update/Modify End.


=head3 Display 

Display the latest info.

=cut
#Display the current Values

  my $userinfo;
  $userinfo->{userid}  = $sel_user->userid;
  $userinfo->{name}    = $sel_user->aname;
  $userinfo->{details} = $sel_user->details;
  $userinfo->{active}  = $sel_user->active;

  $c->stash->{userinfo} = $userinfo;

}

=head2

=cut
sub change_password
{
  my $c = shift;
  my $rs_appuser = shift;

  my $a_pass =shift;
  my $b_pass =shift;

  if ($a_pass == $b_pass)
  {
    my $new_password = Class::Appuser::encode_password($c,$a_pass);
    $c->log->debug("Inside Encoded Password: $new_password");
    $rs_appuser->password($new_password);
    return 1;
  }
  else
  {
    return 0;
  }

}



=head1 AUTHOR

amit,,,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
