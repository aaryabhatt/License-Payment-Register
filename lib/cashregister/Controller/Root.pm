package cashregister::Controller::Root;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller' }

use Class::Appuser;
use Class::Utils;

#
# Sets the actions in this controller to be registered with no prefix
# so they function identically to actions created in MyApp.pm
#
__PACKAGE__->config(namespace => '');

=head1 NAME

cashregister::Controller::Root - Root Controller for cashregister

=head1 DESCRIPTION

[enter your description here]

=head1 METHODS

=head2 index

The root page (/)

=cut

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;

    # Hello World
    #    $c->response->body( $c->welcome_message );
	$c->stash->{template} = 'home.tt';
        $c->log->info("root/index: home")

}

=head2 default

Standard 404 error page

=cut

sub default :Path {
    my ( $self, $c ) = @_;
    $c->response->body( 'Page not found' );
    $c->response->status(404);
}


=head2 auto

Auto runs after the begin but before any action.
Checks if the user is logged.

=cut

sub auto : Private
{
  my ( $self, $c ) = @_;

  my $m = "R/auto";

#
## Sanity Check
  my ( $i_action, $i_user_exist, $i_login );
  $i_action = $c->action();
  $c->log->debug("$m We are here(auto): $i_action");

## Comment: USER Handling starts from here.

  $i_user_exist = $c->user_exists;
  $c->log->debug("$m action:$i_action , ".
        ": Does User Exists:$i_user_exist ..");

  if ($i_user_exist)
  {
    $i_login = $c->user->get('userid');
    $c->log->info("$i_action: LoginID: $i_login ..");

    my %ah = ( user => $i_login );
    $c->stash->{hello} = \%ah;
  }
  ##UNKN is logged if no user exist
else
  {
    $i_login = 'UNKN';
  }

  $c->log->info("$i_action: --Login: $i_login ");
  my $obj_user        = Class::Appuser->new( $c, $i_login );
  $c->log->info("$i_action: --Object_user: $obj_user ");
  my $user_role       = $obj_user->role;
  my $privilege_exist = $obj_user->privilege_exist($c);

  $c->log->debug("$m Role: $user_role ..");

##Handle Backend Admin Menu
  if($user_role =~ 'ADMIN' || $user_role =~ 'ACCOUNT'
    || $user_role =~ 'CASHIER'  )
  {
    $c->stash->{backend_menu} = 1;
  }

  ##Have to check for Admin role also
  $c->log->debug("$m , $i_login,  $user_role");
  if ( !$privilege_exist )
  {
    $c->log->debug("$m :: NO Such Privilege.");
    $c->response->redirect( $c->uri_for('/home') );
    return 0;
  }
  else
  {
    $c->log->info("$m action:$i_action: " .
                "PRIVILEGE EXISTS: $privilege_exist" );
my $action_allowed = $obj_user->user_allowed($c);
    $c->log->info("$m action:$i_action: " .
                "Action Allowed: $action_allowed" );

    if ( $action_allowed > 0 )
    {
      $c->log->info("$m action: $i_action is ALLOWED");
  return 1;
    }
    elsif($action_allowed == 0 && $user_role ne 'GUEST')
    {
      $c->log->info("$m action: No Permissions");
    }
    else
    {
      $c->log->info("**R**$i_action: $i_action is Not Allowed.Redirecting.");
      $c->response->redirect( $c->uri_for('/login') );
      return 0;
    }
  }

#IF nothing works then move to Home
   $c->response->redirect( $c->uri_for('/') );

# Comment: Action and USer END

}





=head2 end

Attempt to render a view, if needed.

=cut

sub end : ActionClass('RenderView') {}

=head1 AUTHOR

amit,,,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
