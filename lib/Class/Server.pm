#!/usr/bin/perl -w
#
# Class/Server.pm
# 
#
use strict;

package Class::Server;

use Net::OpenSSH;
use Class::Utils qw/today now config unxss/;


=pod

=head1 NAME

Class::Server - Utilities for handling Server-related data

=head1 SYNOPSIS

    use Class::Server;
    $c = Class::Server->new( $context, $title );

=head1 INHERITS

Class::Server inherits from B<Class::AppUser>.

=cut

#
# Parent classes.
use Cwd;
use Class::Appuser;

#our @ISA;
#@ISA = ( qw/Class::AppUser/ );
eval `cat lib/Class/Autoload.pl`;

=head1 ADMINISTRIVIA

=over

=item B<new( $context, $server )>

Accept a title (either as a ServerID or as a DBIx::Class::Row object)
and create a fresh Class::Server object from it. A context must be
provided.

Return the Class::Server object, or undef if the Server couldn't be
found.

=cut

# Constructor
sub new
{
  my
    $proto = shift;
  my
    $class = ref( $proto ) || $proto;
  my
    %selfh;
  my
    $self = \%selfh;
#
# What did we get?
  my
    $context = shift;
  my
    $argserver = shift;
  my
    $server = $argserver;
  unless( ref( $argserver) )
  {
    $server = $context->model( 'cashregister::Server' )->find( $argserver );
  }
#$context->log->debug("title ".ref($title));

  return( undef )
    unless $server;
  $self->{server_dbrecord} = $server;
  $self->{context} = $context;
  bless( $self, $class );

# #
  # Store parent fields for subsequent retrieval when required.
  # $self->{lazy_fields} = {};
  # foreach my $p( $self->inherits )
  # {
  #   foreach my $f( Class::Utils::get_fields_from_class_name($context, $p) )
  #   {
  #     $self->{lazy_fields}->{$f} = $p
  # 	unless exists($self->{lazy_fields}->{$f});
  #   }
  # }

#
# Done.
  return( $self );
}

=item B<dbrecord()>

Return the DBIx::Class::Row object for this server.

=cut
# Get the database object
sub dbrecord
{
  my
    $self = shift;
  return( $self->{server_dbrecord} );
}
sub server_dbrecord
{
  my
    $self = shift;
  return( $self->{server_dbrecord} );
}

=item B<context()>

Get the Catalyst context for this server.

=cut
# Get the Catalyst context
sub context
{
  my
    $self = shift;
  return( $self->{context} );
}

=item B<keys()>

For internal use only.  Return an array of the names of the key fields
for this table in the database.

=cut
sub keys
{
  return ( ('ip host desc type') );
}

=head1 METHODS

=over

=item B<serverid>

=item B<userid( [$userid] )>

Get/set accessors for database fields.

=cut
# Get server id.
sub ip
{
  my
    $self = shift;
  return( $self->server_dbrecord->get_column('ip') );
}

sub host
{
  my
    $self = shift;
  my
    $in = shift;
  $self->server_dbrecord->set_column('host', $in)
    if(defined($in));
  return( $self->server_dbrecord->get_column('host') );
}


# Get/set description.
sub description
{
  my
    $self = shift;
  my
    $description = shift;
  $self->server_dbrecord->set_column('description', $description)
    if defined($description);
  return( $self->server_dbrecord->get_column('description') );
}


# Get/set server_login.
sub server_login
{
  my
    $self = shift;
  my
    $server_login = shift;
  $self->server_dbrecord->set_column('server_login', $server_login)
    if defined($server_login);
  return( $self->server_dbrecord->get_column('server_login') );
}

# Get/set server_login_key.
sub server_login_key
{
  my
    $self = shift;
  my
    $server_login_key = shift;
  $self->server_dbrecord->set_column('server_login_key', $server_login_key)
    if defined($server_login_key);
  return( $self->server_dbrecord->get_column('server_login_key') );
}

# Get/set passphrase.
sub passphrase
{
  my
    $self = shift;
  my
    $passphrase = shift;
  $self->server_dbrecord->set_column('passphrase', $passphrase)
    if defined($passphrase);
  return( $self->server_dbrecord->get_column('passphrase') );
}


=back

=head1 INFORMATIONAL METHODS

=over

=back

=head1 OPERATIONAL METHODS

=over

=item B<create( $context, $attribs )>

Create a server with the given attributes.  Available attributes are:

=over

=item $attribs->ip

=item $attribs->host

=item $attribs->description

=item $attribs->type

User ID of the user creating this record.  Defaults to the current
user.

=back

Returns the Class::Server object corresponding to the newly-created
record.

=cut
# Create server record
sub create
{
  my  $context = shift;
  my  $attribs = shift;
  my  $serverrec;

  my $rs_server = $context->model('cashregister::Server')->find_or_create($attribs);
  my $server = Class::Server->new($context,$rs_server);

  my $e_type	= 'SRVADD';
  my $e_change	= 'ADD';
  my $exception = Class::Exception::server_log_add
    ($context,$e_type,$attribs->{ip},$e_change)  if($server);




  return $server;

}


=head2 delete_all

Delete the Server.

=cut

sub delete_all
{
  my $self	= shift;

  my $c		= $self->context;

  my $ip		= $self->ip;
  my $being_used	= $self->check_use;
  my $server_deleted	= 0;

  my $rs_inuse = $c->model('cashregister::ServerInuse')->search
    (
     ip => $ip
    );

  my $server_rs = $self->dbrecord;

  $c->log->debug("DELETE The Server: $ip, Uses:$being_used");
  if ($being_used == 0)
  {
    my $code_in_txn = sub
    {
      $rs_inuse->delete;
      $server_rs->delete;
      $server_deleted++;
    };
    $c->model("cashregister")->txn_do($code_in_txn);
  }

  return $server_deleted;

}


=head2 connect

Return Net::Openssh object.

=cut

sub connect
{
    my $self = shift;

    my $m = "C/S/connect";
    my $c = $self->context;

    my $host	= $self->ip;
    my $user	= $self->server_login;
    my $key_name	= $self->server_login_key;
    my $passphrase	= $self->passphrase;

    my $ssh_dir = config(qw/keys_dir private dir/);
    my $ssh_key= "$ssh_dir/$key_name";

    my $ssh_connection;
    $c->log->info("$m Connection using: $ssh_key");

    if ($ssh_dir && $host && $user && $ssh_key && $passphrase)
    {

      my %con_hash_key =
	(
	 host	    => $host,
	 user	    => $user,
	 key_path   => $ssh_key,
	 passphrase => $passphrase,
         master_opts => [-o => "StrictHostKeyChecking=no" ],
	);

      $ssh_connection = Net::OpenSSH->new(%con_hash_key);

    }

    return $ssh_connection;

}


=head2 get_uses()

Get ServerTypes in an array for the Server Object

=cut

sub get_uses
{
  my $server  = shift;
  my $c = shift;

  my $arr_use = shift;

  my $m = "S/add_use";
  my $context = $server->context;
  my $ip = $server->ip;

  my $rs_iuse = $context->model('cashregister::ServerInuse')->
    search({ip=>$ip});

  my @list;
  while (my $row = $rs_iuse->next() )
  {
    my $type = $row->get_column('type');
    push(@list,$type);
  }

  return @list;

}


=head2 add_use($c, $attribs)

Add ServerType for the Server.

=cut

sub add_use
{
  my $server  = shift;
  my $arr_use = shift;

  my $m = "S/add_use";
  my $context = $server->context;
  my $ip = $server->ip;

  $context->log->debug("$m $ip @$arr_use");

  foreach my $type (@$arr_use)
  {

    $context->log->debug("$m $ip Adding $type");

   my %h =
   (
	ip	=> $ip,
	type	=> $type,
   );
    my $rs_iuse =
      $context->model('cashregister::ServerInuse')->find_or_create(\%h);
  }

}

=head2 check_use

Check if Server is being used for any domain.
Checks in ServerDomain

=cut

sub check_use
{
  my
    $self = shift;

  my $ip = $self->ip;

  my 
	$rs_inuse = $self->context->model('cashregister::ServerDomain')->search
	(
	 {
	 ip => $ip,
	 },
	);

  return $rs_inuse;

}


=head2 get_server_types ($context, $type, [, $selected  ])

Get Server_type from Table Server_type

=cut

sub get_server_types
{
  my $c                 = shift;
  my $i_server_type	= shift;
  my $in_selected       = shift;

  my $f = "C/G/get_server_types";

  $in_selected = unxss($in_selected);
  $c->log->debug("$f Start SELECTED:$in_selected");
  my @list;

  my $type = $i_server_type;

  my @order = ('type');
  my $servers_rs = $c->model('cashregister::ServerType')->search
    ({ },
     {order_by=> @order,}
    );

  while ( my $server_row = $servers_rs->next )
  {

    my $type		= $server_row->type;
    my $description	= $server_row->description;

    my $selected;
    if ($type eq $in_selected)
    {
      $c->log->debug("$f Start IN:$in_selected,CODE:$type");
      $selected='SELECTED';
    }

    push(@list,
         {
	  type   => $type,
	  description => $description,
	  selected => $selected,
         }
        );

  }

  return @list;

}



=head2 get_servers_type_obj ($context,$server_type)

Get Servers objects for HOST Servers

=cut

sub get_servers_type_obj
{
  my $c                 = shift;
  my $i_server_type	= shift;

  my $f = "C/G/get_servers_type_obj";

  $c->log->debug("$f Start type:$i_server_type");
  my @list;

  my $type;

  if($i_server_type eq 'MAIL' || $i_server_type eq 'DNS' ||
	 $i_server_type eq 'HOST'  )
    {
	$type = $i_server_type;
    }

  my @order = ('ip');
  my $servers_rs = $c->model('cashregister::ServerInuse')->search
    ({type => $type, },
     {order_by=> @order,}
    );

  while ( my $server_row = $servers_rs->next )
  {

    my $ip      = $server_row->get_column('ip');
    my $type	= $server_row->type;
    my $server  = Class::Server->new($c,$ip);

    push(@list,$server);
  }

  return @list;

}


=head2 get_servers_for_type ($context [, $selected  ])

Get Servers from Table Server

=cut

sub get_servers_for_type
{
  my $c                 = shift;
  my $i_server_type	= shift;
  my $in_selected       = shift;

  my $f = "C/G/get_servers_for_type";

  $in_selected = $in_selected;
  $c->log->debug("$f Start SELECTED:$in_selected");
  my @list;

  my $type;

  if($i_server_type eq 'MAIL' || $i_server_type eq 'DNS' ||
	 $i_server_type eq 'HOST'  )
    {
	$type = $i_server_type;
    }


  my @order = ('ip');
  my $servers_rs = $c->model('cashregister::ServerInuse')->search
    ({type => $type, },
     {order_by=> @order,}
    );

  while ( my $server_row = $servers_rs->next )
  {

    my $ip      = $server_row->get_column('ip');
    my $type	= $server_row->type;
#    $c->log->debug("$f ip:$ip , $in_selected");
    my $server = Class::Server->new($c,$ip);
    my $description = $server->description;
    my $host	= $server->host;
    my $priority;

    my $selected;
    if ( ref($in_selected) eq 'ARRAY')
    {
      $c->log->debug("$f Selected Array. checkbox");
      foreach my $ln( @$in_selected )
      {
        my $sel_ip	= $ln->{ip};
        my $sel_pri	= $ln->{priority};
        if ($ip eq $sel_ip)
        {
          $priority = $sel_pri;
          $c->log->debug("$f ARR. check $ip - $sel_ip, $priority");
        }
      }
    }
    elsif ( $in_selected && ( $ip eq $in_selected) )
    {
      $c->log->debug("$f Start IN:$in_selected,ip:$ip");
      $selected='SELECTED';
    }

    push(@list,
         {
          ip     => $ip,
          type   => $type,
	  host => $host,
	  description => $description,
	  selected => $selected,
	  priority => $priority,
         }
        );

  }

  return @list;

}

=head2 create_bind_options

create bind options

=cut

sub create_bind_options
{
  my $c = shift;

  my $fn = "S/create_bind_options";
  $c->log->info("$fn: start");

  my @all_parent_domains = Class::Domain::get_parent_domains($c);

  my $filename = "named.conf.local";
  my $conf_file_dir = config(qw/src_dir config bind/);
  my $conf_file = "$conf_file_dir/$filename";
  #   my $conf_file = "/tmp/bind.conf";## Testing Purpose.

  $c->log->info("$fn: start $conf_file_dir $conf_file");

  my $fhen;
  open($fhen, '>', $conf_file) or die "Could not open file '$conf_file' $!";
  my $dst_bind_opt_dir	= config(qw/dst_dir config zone/);

  foreach my $dom (@all_parent_domains) {

	my $name = $dom->{nameofdomain};

    my  $conf_data_dom = << "EOF";
zone $name {
         type master;
         file "$dst_bind_opt_dir/$name.hosts";
         };

EOF

    print $fhen $conf_data_dom;

  }

  close $fhen;
  return $conf_file;
  #$c->log->info("$fn Done");
}



=head2 copy_bind_zone($c,$ssh_connection,$domain)

This function copies Zone File for a domain to the server.

=cut

sub copy_bind_zone
{
	my $c			= shift;
	my $ssh_connection	= shift;
	my $domain		= shift;


	my $nameofdomain  = $domain->nameofdomain;

	my $dst_zone_dir = config(qw/dst_dir config zone/);
	my $zone_file_dir = config(qw/src_dir config zone/);
	my $zone_file	  = "$zone_file_dir/$nameofdomain.hosts";

	$ssh_connection;

	$ssh_connection->scp_put($zone_file,$dst_zone_dir);

	my $status = $ssh_connection->error;

	return $status;

}



=head2 copy_bind_option($c,$ssh_connection)

This function copies Zone File for a domain to the server.

=cut

sub copy_bind_option
{
	my $c			= shift;
	my $ssh_connection	= shift;

	my $file_name		= "named.conf.local";
	my $dst_bind_opt_dir	= config(qw/dst_dir config bind/);
	my $bind_opt_file_dir	= config(qw/src_dir config bind/);
	my $bind_opt_file	= "$bind_opt_file_dir/$file_name";

	$ssh_connection;

	$ssh_connection->scp_put($bind_opt_file,$dst_bind_opt_dir);

	my $status = $ssh_connection->error;

	return $status;


}



=head2 bind_restart($c,$ssh_connection)

This function copies Restarts the Bind server.

=cut

sub bind_restart
{
	my $c			= shift;
	my $ssh_connection	= shift;

	my $bind_service	= config(qw/commands restart bind/);

	my $cmd = "$bind_service restart";

	$ssh_connection->system($cmd);
	my $status = $ssh_connection->error;

	return $status;


}

=head2 apache_enable_domain($c,$ssh_connection, $nameofdomain)

This function copies Enables a domain

=cut

sub apache_enable_domain
{
	my $c			= shift;
	my $ssh_connection	= shift;
	my $nameofdomain	= shift;

	my $apache_enable	= config(qw/commands enable apache/);

	my $cmd = "$apache_enable $nameofdomain";

	$ssh_connection->system($cmd);
	my $status = $ssh_connection->error;

	return $status;


}


=head2 apache_restart($c,$ssh_connection)

This function copies Restarts the Apache server.

=cut

sub apache_restart
{
	my $c			= shift;
	my $ssh_connection	= shift;

	my $apache_service	= config(qw/commands restart apache/);

	my $cmd = "$apache_service restart";

	$ssh_connection->system($cmd);
	my $status = $ssh_connection->error;

	return $status;


}

=head2 create_clone_domain_dir_tree($c,$ssh_connection,$domain,$clone_domain)

This function creates a domain folder in /home/web/$domain.name

And creates a languages sub folder

=cut

sub create_clone_domain_dir_tree
{
  my $c                   = shift;
  my $ssh_connection      = shift;
  my $domain              = shift;
  my $clone_domain        = shift;

  my $f ="S/create_clone_domain_dir_tree";
  my $self_host = $ssh_connection->get_host;

  my $domain_d_host = $domain->get_server_host;
  my $clone_d_host  = $clone_domain->get_server_host;

  $c->log->debug("$f SELF IP:$self_host, Domain IP:$domain_d_host,".
		 " Clone IPt:$clone_d_host");

  my $name	  = $domain->nameofdomain;
  my $clone_name  = $clone_domain->nameofdomain;

  my $base_dir    = config(qw/dst_dir config web/);

  my $local_src    = config(qw/src_dir config clone/);
  my $copy_opts = {recursive => 1, glob => 1, timeout => 100,
		   copy_attrs => 1};

  if ($domain_d_host eq $clone_d_host)
  {
    my $copy_cmd = "cp -r";
    ##Copy the Clone Domain, If bothe domain's Host server are same.
    my $cmd1 = "$copy_cmd $base_dir/$clone_name $base_dir/$name";
    $c->log->debug("$f Clone Domain: $cmd1");
    $ssh_connection->system($cmd1);
  }
  elsif ($self_host eq $domain_d_host)
  {
    ##Copy when the Domain's Host is the SAME IP.
    my $clone_server  = Class::Server->new($c,$clone_d_host);
    my $clone_ssh = $clone_server->connect;

    my $domain_server = Class::Server->new($c,$domain_d_host);
    my $dom_ssh = $domain_server->connect;

    my $src_dir = "$base_dir/$clone_name";
    $c->log->debug("$f Clone from:($clone_d_host) $src_dir -> $local_src");
    $clone_ssh->scp_get($copy_opts,$src_dir,$local_src);

    my $local_dir = "$local_src/$clone_name";
    my $dst_dir = "$base_dir/$name";
    $c->log->debug("$f Clone to: ($domain_d_host)".
		   " $local_dir -> $dst_dir");
    $dom_ssh->scp_put($copy_opts,$local_dir,$dst_dir);
  }

  ##Else Copy the Clone domain locally, then copy it to the Domain's
  ## remote server.


  my $status = $ssh_connection->error;
  return $status;


}


=head2 create_domain_dir_tree($c,$ssh_connection, $domain)

This function creates a domain folder in /home/web/$domain.name

And creates a languages sub folder

=cut

sub create_domain_dir_tree
{
	my $c			= shift;
	my $ssh_connection	= shift;
	my $domain		= shift;

	my $f="S/create_domain_dir_tree";
	my $name = $domain->nameofdomain;

	my $base_dir	= config(qw/dst_dir config web/);

	my $mkdir_cmd = "mkdir -p";
	my $cmd1 = "$mkdir_cmd  $base_dir/$name";
	$c->log->debug("$f Clone Domain: $cmd1");

	$ssh_connection->system($cmd1);

	my $default_language = $domain->default_language;

	my @languages = $domain->get_languages($c);
	push(@languages,$default_language);

	$c->log->debug("$f All Languages: @languages");


	foreach my $code(@languages)
	{
	  my $cmd ="$mkdir_cmd  $base_dir/$name/$code";
	  $ssh_connection->system($cmd);
	  my $err_cmd = $ssh_connection->error;
	  $c->log->debug("$f Add $code : $code");
	}

	my $status = $ssh_connection->error;
	return $status;

}


=head2 edit_domain_dir_tree($c,$ssh_connection, $domain)

This function creates a domain folder in /home/web/$domain.name

Creates a languages sub folder.

Currently Does not delete a folder which is not in default languages.

Should we move it or delete it.

=cut

sub edit_domain_dir_tree
{
	my $c			= shift;
	my $ssh_connection	= shift;
	my $domain		= shift;

	my $fn = "S/edit_domain_dir_tree";
	$c->log->info("$fn: Start");

	my $name = $domain->nameofdomain;

	my $base_dir	= config(qw/dst_dir config web/);

	my $mkdir_cmd = "mkdir -p";

	my $default_language = $domain->default_language;

	my $cmd1 = "$mkdir_cmd  $base_dir/$name";
	$ssh_connection->system($cmd1);
	my $cmd2 = "$mkdir_cmd  $base_dir/$name/$default_language";
	$ssh_connection->system($cmd1);

	my @languages = $domain->get_languages($c);
	foreach my $code(@languages)
	{
	  my $cmd ="$mkdir_cmd  $base_dir/$name/$code";
	  $ssh_connection->system($cmd);
	  $c->log->info("$fn: Create Directory for $code");
	}

	my $status = $ssh_connection->error;
	return $status;

}





=back

=cut

1;
