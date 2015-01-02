package cashregister::Controller::Login;
use Moose;
use namespace::autoclean;

BEGIN {extends 'Catalyst::Controller'; }
use Class::Utils qw(unxss trim config);

=head1 NAME

cashregister::Controller::Login - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut

#sub index :Path :Args(0) {
#    my ( $self, $c ) = @_;
#
#    $c->response->body('Matched cashregister::Controller::Login in Login.');
#}


sub index :Path :Args(0)
{

  my ( $self, $c ) = @_;

# Input Types
  my $aparams = $c->request->params;
  my $i_action = "L/index";

# Page and Template
  $c->stash->{template} = 'src/User/login.tt';

  # Get the username and password from form
  my $app_userid        = trim($c,$aparams->{userid});
  my $password          = trim($c,$aparams->{password});
  $c->log->debug("$i_action: $app_userid:$password");

  # If the username and password values were found in form
  if ($app_userid && $password )
  {

    my $app_user = $c->find_user({ userid => $app_userid });
    $c->log->debug("$i_action: User Obj: $app_user");
    if ($app_user)
    {

      my $encoded_password =
        Class::Appuser::encode_password($c,$password);
      $c->log->debug("$i_action: Encoded PW: $encoded_password");

      $c->log->debug("$i_action: Going for authentication.");
      if(
         $c->authenticate({
                           userid       => $app_userid,
#   password => $password, #Simple Un-Encrypted Password
                          password     => $encoded_password,
                          })
         )
      {
        #      $c->set_authenticated($app_user); 
        $c->log->info("L/index: We are through");
        $c->response->redirect('/');
        return;
      }
      else
      {
        $c->stash(error_msg => "Wrong username or password.");
      }
    }
    else
    {
      # Set an error message
      $c->stash(error_msg => "Wrong username Or password.");
    }
  }
  else
  {
    # Set an error message
    $c->stash(error_msg => "");
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
