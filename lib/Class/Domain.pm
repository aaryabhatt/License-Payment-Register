#!/usr/bin/perl -w
#
# Class/Domain.pm
# 
#
use strict;

package Class::Domain;

use Class::Utils qw/today now config/;
use Class::Exception;


=pod

=head1 NAME

Class::Domain - Utilities for handling Domain-related data

=head1 SYNOPSIS
    use Class::Domain;
    $c = Class::Domain->new( $context, $title );

=head1 INHERITS

Class::Domain inherits from B<Class::AppUser>.

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

=item B<new( $context, $domain )>

Accept a title (either as a DomainID or as a DBIx::Class::Row object)
and create a fresh Class::Domain object from it. A context must be
provided.

Return the Class::Domain object, or undef if the Domain couldn't be
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
    $argdomain = shift;
  my
    $domain = $argdomain;
  unless( ref( $argdomain) )
  {
    $domain = $context->model( 'cashregister::Domain' )->find( $argdomain );
  }
#$context->log->debug("title ".ref($title));

  return( undef )
    unless $domain;
  $self->{domain_dbrecord} = $domain;
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

Return the DBIx::Class::Row object for this domain.

=cut
# Get the database object
sub dbrecord
{
  my
    $self = shift;
  return( $self->{domain_dbrecord} );
}
sub domain_dbrecord
{
  my
    $self = shift;
  return( $self->{domain_dbrecord} );
}

=item B<context()>

Get the Catalyst context for this domain.

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
  return ( ('reverseofdomain') );
}

=item B<<< inherits >>>

Return list of classes this class lazy inherits from.

=cut
sub inherits
{
  return( qw/Class::Appuser/ );
}

=back

=head1 METHODS


=head1 INFORMATIONAL METHODS

=over

=cut

=item B<reverseofdomain>

get reverseofdomain

=cut 

sub reverseofdomain
{
  my
    $self = shift;
  return( $self->domain_dbrecord->get_column('reverseofdomain') );
}

=item B<nameofdomain>

get nameofdomain

=cut 
sub nameofdomain
{
  my
    $self = shift;
  return( $self->domain_dbrecord->get_column('nameofdomain') );
}

=item B<userid>

 Get/set user id.

=cut


sub userid
{
  my
    $self = shift;
  my
    $userid = shift;
  $self->domain_dbrecord->set_column('userid', $userid)
    if defined($userid);
  return( $self->domain_dbrecord->get_column('userid') );
}

=item B<level>

get level

=cut

sub level
{
  my
    $self = shift;
  return( $self->domain_dbrecord->get_column('level') );
}

=item B<origin>

get origin

=cut

sub origin
{
  my
    $self = shift;
  my
    $origin = shift;
  $self->domain_dbrecord->set_column('origin', $origin)
    if defined($origin);
  return( $self->domain_dbrecord->get_column('origin') );
}

=item B<nsprimary>

Get/set nsprimary.

=cut

sub nsprimary
{
  my
    $self = shift;
  my
    $nsprimary = shift;
  $self->domain_dbrecord->set_column('nsprimary', $nsprimary)
    if defined($nsprimary);
  return( $self->domain_dbrecord->get_column('nsprimary') );
}

=item B<refresh>

get/set refresh

=cut
sub refresh
{
  my
    $self = shift;
  my
    $refresh = shift;
  $self->domain_dbrecord->set_column('refresh', $refresh)
    if defined($refresh);
  return( $self->domain_dbrecord->get_column('refresh') );
}

=item B<expire>

Get/set expire.

=cut


sub expire
{
  my
    $self = shift;
  my
    $expire = shift;
  $self->domain_dbrecord->set_column('expire', $expire)
    if defined($expire);
  return( $self->domain_dbrecord->get_column('expire') );
}

=item B<retry>

Get/set retry.

=cut


sub retry
{
  my
    $self = shift;
  my
    $retry = shift;
  $self->domain_dbrecord->set_column('retry', $retry)
    if defined($retry);
  return( $self->domain_dbrecord->get_column('retry') );
}


=item B<ttl>

get/set ttl

=cut

# Get/set origin.
sub ttl
{
  my
    $self = shift;
  my
    $ttl = shift;
  $self->domain_dbrecord->set_column('ttl', $ttl)
    if defined($ttl);
  return( $self->domain_dbrecord->get_column('ttl') );
}

=item B<mimimumttl>

get/set mimimumttl

=cut
sub minimumttl
{
  my
    $self = shift;
  my
    $minimumttl = shift;
  $self->domain_dbrecord->set_column('minimumttl', $minimumttl)
    if defined($minimumttl);
  return( $self->domain_dbrecord->get_column('minimumttl') );
}

=item B<email>

get/set email

=cut

sub email
{
  my
    $self = shift;
  my
    $email = shift;
  $self->domain_dbrecord->set_column('email', $email)
    if defined($email);
  return( $self->domain_dbrecord->get_column('email') );
}

=item B<valid>

Get/set valid.

=cut

sub valid
{
  my
    $self = shift;
  my
    $valid = shift;
  $self->domain_dbrecord->set_column('valid', $valid)
    if defined($valid);
  return( $self->domain_dbrecord->get_column('valid') );
}

=item B<alias>

Get/set alias.

=cut
sub alias
{
  my
    $self = shift;
  my
    $alias = shift;

  my $context = $self->context;
  my $did = $self->reverseofdomain;


  if(defined($alias) && $alias ne 0)
  {
    $context->log->debug("domain->alias: DID: $did, New Alias:$alias");

    ##Set New alias in Domain Tables
    $self->domain_dbrecord->set_column('alias', $alias);
    my $alias_rs = $self->context->model('cashregister::Alias')->find
      ({'reverseofdomain' => $did}, );
    $context->log->debug("domain->alias: Alias RS: $alias_rs");

    ##DElete the Old Alias Table Record
    $alias_rs->delete if($alias_rs);

    $context->log->debug("domain->alias: Deleted Alias RS");
    my $userid	= $context->user->get('userid');
    my $name	= $self->nameofdomain;
    $context->log->debug("domain->alias: Name:$name,$userid,$alias,$did");

    ##Add New Alias Table Record
    my $alias_row = 
      $context->model('cashregister::Alias')->find_or_create
	({
	  reverseofdomain	=> $did,
	  alias			=> $alias,
	  nameofdomain		=> $name,
	  userid		=> $self->userid,
	 });


  }
  $context->log->debug("domain->alias: Get the New Alias");

  my $o_alias = $self->domain_dbrecord->get_column('alias');
  return $o_alias if($o_alias ne 0);
}

=item B<alias_name>

Get Alias Name.

=cut
sub alias_name
{
  my
    $self = shift;
  my $alias = $self->alias;
  my $rev = reverse $alias;

  return $rev if($rev ne 0);

}


=head2 get_customer 

Returns the Customer Row for the Domain.

=cut

sub get_customer
  {
    my $self = shift;

    my $reverse = $self->reverseofdomain;

    my $rs_customer_domain;
    $rs_customer_domain = $self->context->model('cashregister::CustomerDomain')->find
      ({
	reverseofdomain	=> $reverse,
       });

    my $rs_customer;
    $rs_customer = $rs_customer_domain->customerid if($rs_customer_domain);
    return $rs_customer;

}

=head1 OPERATIONAL METHODS

=head2 default_language ([languagetype.languagecode])

Get the Default Language

=cut

sub default_language
{
  my $self    = shift;

  my $m = "C/D/default_language";
  my $context = $self->context;
  $context->log->info("$m ");

  my $rs_def_language =  $context->model('cashregister::Domainlanguage')->find
	({
		reverseofdomain => $self->reverseofdomain,
		priority	=> 1,
	});

  my $language_code;
  $language_code = $rs_def_language->get_column('languagecode')
	 if($rs_def_language);
  $context->log->info("$m Df Lang: $language_code");

  return $language_code;
}

=head2 get_languages

Get the Languages

=cut

sub get_languages
{
  my $self    = shift;
  my $in_lang = shift;

  my $m = "C/D/get_languages";
  my $context = $self->context;

  my $rs_def_language =  $context->model('cashregister::Domainlanguage')->search
	({
		reverseofdomain => $self->reverseofdomain,
		priority	=> { '>' => 1},
	});
  my $language_code;

  my @list;
  while ( my $row = $rs_def_language->next )
  {
	my $code ;
	$code = $row->get_column('languagecode') ;
	$context->log->info("$m Lang Code: $code");

	push(@list, $code);
  }
  return @list ;
}


=head2 get_parent

Get Parent Domain of a Domain Obj.

Returns Parent domain Object.

=cut

sub get_parent
{
  my $self	= shift;
  my $c		= $self->context;

  my $level = $self->level;
  my $top_level = $level-1;

  my $m = "D/get_parent_domains";
  my $reverse = $self->reverseofdomain;

  my ($one,$two,@other) = split('\.',$reverse);
  $c->log->info("$m Separated: $one, $two");
  my $str_search = "$one.$two";

  my $rs_domain =  $c->model('cashregister::Domain')->find
	({
	reverseofdomain => "$str_search" ,
	level => { '=',$top_level},
	});

  my $parent;
  $parent = Class::Domain->new($c,$rs_domain);

  return $parent;

}

=head2 get_aliases

Get Aliases pointing to the Domain

Returns Array of Hash (reverseofdomain,nameofdomain)

=cut

sub get_aliases
{
  my $self	= shift;
  my $c		= $self->context;

  my $m		= "D/get_aliases";
  my $reverse	= $self->reverseofdomain;

  my $rs_aliases =  $c->model('cashregister::Alias')->search
	({ 
	  alias => $reverse ,
	});

  my @list;
  while ( my $row = $rs_aliases->next )
  {
    my $r_reverse		= $row->get_column('reverseofdomain');
    my $r_nameofdomain	= reverse $r_reverse;
    $c->log->info("$m found $r_reverse");

    if ($r_reverse ne $reverse)
    {

      push(@list,
	   {
	    did		=> $r_reverse,
	    reverseofdomain  => $r_reverse,
	    name => $r_nameofdomain,
	   },

	  );
    }

  }

  return @list;

}


=head2 get_parent_domain

Get Parent Domain of a Domain Obj.

Returns Array of Hash (of only the parent Domain)

=cut

sub get_parent_domain
{
  my $self	= shift;
  my $c		= $self->context;

#  my $level = $self->level;
#  my $top_level = $level-1;

  my $m = "D/get_parent_domains";
  my $reverse = $self->reverseofdomain;

  my ($one,$two,@other) = split('\.',$reverse);
  $c->log->info("$m Separated: $one, $two");
  my $str_search = "$one.$two";

  my $rs_domains =  $c->model('cashregister::Domain')->search
	({ 
	reverseofdomain => "$str_search" ,
	level => { '=',1},
	});

  my @list;
  while ( my $row = $rs_domains->next )
  {
	my $r_reverse	 = $row->reverseofdomain;
	my $r_nameofdomain = $row->nameofdomain;
	$c->log->info("$m found $r_reverse");

        if ($r_reverse ne $reverse)
	{

	  push(@list,
	       {
		did  => $r_reverse,
		name => $r_nameofdomain,
	       },

	      );
	}

  }

 return @list;

}


=head2 get_sub_domains

Get Sub Domain of a Domain Obj

Returns Array of Hash 

=cut

sub get_sub_domains
{
  my $self	= shift;
  my $c		= $self->context;

  my $m = "D/get_sub_domains";
  my $reverse = $self->reverseofdomain;

  my $rs_domains =  $c->model('cashregister::Domain')->search
	({ 
	reverseofdomain => { like => "$reverse%" },
	level => { '>',1},
	});

  my @list;
  while ( my $row = $rs_domains->next )
  {
	my $r_reverse	 = $row->reverseofdomain;
	my $r_nameofdomain = $row->nameofdomain;
	$c->log->info("$m $reverse");

        if ($r_reverse ne $reverse)
	{
	  push(@list,
	       {
		did  => $r_reverse,
		name => $r_nameofdomain,
	       },

	      );
	}

  }

 return @list;

}


=head2 create( $context, $attribs )

Create a domain with the given attributes.  Available attributes are:

=over

=item $attribs->nameofdomain

=item $attribs->level

=item $attribs->serial

=item $attribs->orogin

=item $attribs->nsprimary

=item $attribs->refresh

=item $attribs->expire

=item $attribs->ttl

=item $attribs->minimulttl

=item $attribs->email

=item $attribs->alias

=item $attribs->userid

User ID of the user creating this record.  Defaults to the current
user.


=cut

sub create
{
  my $context = shift;
  my $attribs = shift;

  my $fx = "C/Domain/create";


  my $login = $context->user->get('userid');
  $attribs->{userid} = $login;

  my $def_email = config(qw/domain dns email/);
  my $mail;
  my $a_mail = $attribs->{email};
  if ($a_mail)
  {
    $mail = $a_mail =~ tr/@/./ ;                              
  } else                                                        
  {                                                           
    $a_mail = $def_email;                                     
    $mail = $def_email =~ tr/@/./ ;                           
  }                                                           
  $attribs->{email} = $mail;                             

  $context->log->debug("$fx Creating Domain");
  my $row_domain = $context->model('cashregister::Domain')->find_or_create
    ($attribs);
  my $domain;

  $domain = Class::Domain->new($context,$row_domain) if($row_domain);
  my $e_typeid='DOMADD';
  my $e_change='ADD';

  my $exception = Class::Exception::domain_log_add
    ($context,$e_typeid,$domain->nameofdomain,$domain->nameofdomain)
      if($domain);


  return $domain;
  $context->log->debug("$fx Added Domain");


}


=head2 del_languages

Delete all Domain Languages.

=cut

sub del_languages
{
  my $self		= shift;

  my $c = $self->context;
  my $reverse = $self->reverseofdomain;

  my $rs_dom_languages =  $c->model('cashregister::Domainlanguage')->search
	( { reverseofdomain => $reverse });

  while ( my $row = $rs_dom_languages->next() )
  {
    my $code = $row->get_column('languagecode');
    my $e_typeid='DOMLANG';
    my $exception = Class::Exception::domain_log_del
      ($c,$e_typeid,$self->nameofdomain,$code)
	if ($row);

  }


  $rs_dom_languages->delete;

}

=head2 add_languages ($default_language, \@supported_languages)

Add Languages to The Domain.

=cut

sub add_languages
{
  my $self		= shift;
  my $default_language	= shift;
  my $in_languages	= shift;

#HouseKeeping
  my $count_languages = (scalar @$in_languages)-1;
  my $m = "C/add_languages";
  my $c = $self->context;
  my $priority = 1;

  my $reverse = $self->reverseofdomain;
  $c->log->info("$m Adding Languages for $reverse ");

  my %lang_hash =
    (
     reverseofdomain	=> $reverse,
     languagecode	=> $default_language,
     priority		=> $priority,
    );

  ##Create Languages, Default and other Languages
  my $rs_def_language =  $c->model('cashregister::Domainlanguage')->find_or_create
    (\%lang_hash);
  my $e_typeid='DOMLANGPRI';
  my $exception = Class::Exception::domain_log_add
    ($c,$e_typeid,$self->nameofdomain,$default_language)
      if($self && $rs_def_language);


  $c->log->info("$m Adding Languages:@$in_languages");

  if ($count_languages)
  {
    foreach my $ml (@$in_languages)
    {
      $priority++;
      $c->log->info("$m Adding LANG:$ml");
      if ($default_language ne $ml)
      {

	my $rs_def_language =  $c->model('cashregister::Domainlanguage')
	  ->find_or_create
	    ({
	      reverseofdomain	=> $reverse,
	      languagecode	=> $ml,
	      priority		=> $priority,
	     });

        my $e_typeid='DOMLANG';
	my $exception = Class::Exception::domain_log_add
	  ($c,$e_typeid,$self->nameofdomain,$ml)
	    if ($self && $rs_def_language);

      }				##IF
    }#Foreach
  }				##IF in_languages

  return $priority;

}

=head2 edit_dns_record_a ($ip,$host)

Update IP of the DNS A Record.

=cut

sub edit_dns_record_a
{
  my $self      = shift;
  my $ip	= shift;
  my $host	= shift;
  my $new_ip    = shift;

  my $m = "C/Domain/del_dns_record_a";
  my $c = $self->context;
  $c->log->info("$m Edit $ip,$host");

##Housekeeping
  my $type = 'A';
  my $reverse	= $self->reverseofdomain;
  $c->log->info("$m Edit $type record for $reverse");
  $c->log->info("$m Edit $host, $ip ");
  my $rs_dns;
  $rs_dns =  $c->model('cashregister::DnsRecord')->find
  ({
	reverseofdomain => $reverse,
	type		=> $type,
	host	=> $host,
	ip	=> $ip,
  });

  if ($rs_dns)
  {
    my $old = $rs_dns->ip;
    $rs_dns->ip($new_ip);
    $rs_dns->update();

    my $e_typeid	= 'DOMDNS';
    my $e_ctype		= 'CHANGE';
    my $exception = Class::Exception::domain_log
      ($c,$e_typeid,$self->nameofdomain,$e_ctype,$old,$new_ip);
  }

##Change the SubDomains IP if needed.
  my @sub_domains = $self->get_sub_domains;
  foreach my $sd (@sub_domains)
  {
    my $did = $sd->{did};
    my $sub_domain = Class::Domain->new($c,$did);
    my $name = reverse $did;

    $c->log->info("$m Edit did:$did,type=$type,host=$name,ip:$ip");

    my $rs_sub_dns =  $c->model('cashregister::DnsRecord')->find
      ({
	reverseofdomain => $reverse,
	type		=> $type,
	host		=> $name,
#	ip		=> $ip,
       });
      $c->log->info("$m Edit Subdomain Found $rs_sub_dns");

    if ($rs_sub_dns)
    {
      my $old = $rs_sub_dns->ip;
      $rs_sub_dns->ip($new_ip);
      $rs_sub_dns->update();
      $c->log->info("$m Edit Subdomain Old:$old New:$ip");


      my $e_typeid	= 'DOMDNS';
      my $e_ctype	= 'CHANGE';
      my $exception = Class::Exception::domain_log
	($c,$e_typeid,$name,$e_ctype,$old,$new_ip);
    }

  }

  $c->log->info("$m Edited: $rs_dns ");

}


=head2 edit_server_host ($old_ip,$new_ip)

Change Host IP for the Domain.

=cut

sub edit_server_host
{
  my $self    = shift;
  my $ip	= shift;
  my $new_ip    = shift;

  my $rs_server_domain;

##Housekeeping
  my $type = 'HOST';
  my $c = $self->context;
  my $m = "C/Domain/edit_server_host";

  $c->log->info("$m Change Host IP");
  my $reverse	= $self->reverseofdomain;
  my $name = $self->nameofdomain;
  $c->log->info("$m Change $ip to $new_ip ");
  my $userid	= $c->user->get('userid');


  $rs_server_domain =  $c->model('cashregister::ServerDomain')->find
  ({
	reverseofdomain => $reverse,
	type		=> $type,
	ip		=> $ip,
	valid		=> 1,
	priority	=> 1,
  });

  if($rs_server_domain)
  {

    my $old = $rs_server_domain->get_column('ip');
    if ($new_ip)
    {
      $rs_server_domain->ip($new_ip);
      $rs_server_domain->update();
    }
    else
    {
      $rs_server_domain->delete;
    }

    my $e_typeid='DOMHTTP';
    my $e_ctype='CHANGE';
    my $exception = Class::Exception::domain_log
      ($c,$e_typeid,$self->nameofdomain,$e_ctype,$old,$new_ip);


  }
  elsif ($new_ip && !$ip)
  {

    my $userid	= $c->user->get('userid');
    my $rs_dns =  $c->model('cashregister::DnsRecord')->create
      ({
	reverseofdomain => $reverse,
	type		=> 'A',

	host	=> $name,
	ip	=> $new_ip,

	valid	=> 1,
	userid	=> $userid,
       });

    my $e_typeid='DOMDNS';
    my $exception = Class::Exception::domain_log_add
      ($c,$e_typeid,$self->nameofdomain,$ip);


    $rs_server_domain =  $c->model('cashregister::ServerDomain')->find_or_create
      ({
	reverseofdomain => $reverse,
	type		=> $type,
	ip		=> $new_ip,
	valid		=> 1,
	priority	=> 1,
       });

    my $e_typeid='DOMHTTP';
    my $e_ctype='ADD';
    my $exception = Class::Exception::domain_log_add
      ($c,$e_typeid,$self->nameofdomain,$new_ip) if($rs_server_domain);

  }

 return $rs_server_domain;


}


=head2 add_dns_record_cname ($attribs)

Add DNS CNAME record for $domain.

=cut

sub add_dns_record_cname
{
  my $self    = shift;
  my $name    = shift;
  my $aliasto = shift;

##Housekeeping
  my $type = 'CNAME';
  my $c = $self->context;
  my $m = "C/Domain/add_dns_record_a";

  $c->log->info("$m Adding LANG ");
  my $reverse	= $self->reverseofdomain;
  my $userid	= $c->user->get('userid');
  $c->log->info("$m Adding U:$userid ");
  my $alias = $self->alias;

  my $rs_dns =  $c->model('cashregister::DnsRecord')->create
  ({
	reverseofdomain => $reverse,
	type		=> $type,

	host	=> $name,
	aliasto	=> $aliasto,

	valid	=> 1,
	userid	=> $userid,
   }) ;



  $c->log->info("$m Adding rs:$rs_dns ");
  return $rs_dns;

}


=head2 add_dns_record_dcname ($attribs)

Add DNS DNAME(alias)for $domain.

=cut

sub add_dns_record_dname
{
  my $self    = shift;
  my $name    = shift;
  my $aliasto = shift;

##Housekeeping
  my $type = 'DNAME';
  my $c = $self->context;
  my $m = "C/Domain/add_dns_record_a";

  $c->log->info("$m Adding LANG ");
  my $reverse	= $self->reverseofdomain;
  my $userid	= $c->user->get('userid');
  $c->log->info("$m Adding U:$userid ");
  my $alias = $self->alias;

  my $rs_dns =  $c->model('cashregister::DnsRecord')->create
  ({
	reverseofdomain => $reverse,
	type		=> $type,

	host	=> $name,
	aliasto	=> $aliasto,

	valid	=> 1,
	userid	=> $userid,
   }) ;



  $c->log->info("$m Adding rs:$rs_dns ");
  return $rs_dns;

}



=head2 add_dns_record_a ($attribs)

Add DNS for $domain.

=cut

sub add_dns_record_a
{
  my $self    = shift;
  my $attribs = shift;

##Housekeeping
  my $type = 'A';
  my $c = $self->context;
  my $m = "C/Domain/add_dns_record_a";

  $c->log->info("$m Adding LANG ");
  my $reverse	= $self->reverseofdomain;

  my $host	= $attribs->{host} ;
  my $ip	= $attribs->{ip} ;
  $c->log->info("$m Adding $host, $ip ");

  my $serial	= $attribs->{serial} || 1;
  my $userid	= $c->user->get('userid');
  $c->log->info("$m Adding s:$serial, U:$userid ");

  my $rs_dns =  $c->model('cashregister::DnsRecord')->create
  ({
	reverseofdomain => $reverse,
	type		=> $type,

	host	=> $host,
	ip	=> $ip,

	valid	=> 1,
	userid	=> $userid,
  });

  my $e_typeid='DOMDNS';
  my $exception = Class::Exception::domain_log_add
    ($c,$e_typeid,$self->nameofdomain,$ip);


  $c->log->info("$m Adding rs:$rs_dns ");
  return $rs_dns;

}


=head2 get_dns_records_a ()

Get A record for $domain.

=cut

sub get_dns_records_a
{
  my $self    = shift;

##Housekeeping
  my $type = 'A';
  my $c = $self->context;
  my $m = "C/Domain/get_dns_record_a";

  my $reverse	= $self->reverseofdomain;

  my $rs_dns =  $c->model('cashregister::DnsRecord')->search
  ({
	reverseofdomain => $reverse,
	type		=> $type,
  });
  my @list;
  while ( my $row = $rs_dns->next )
  {
	my $ip = $row->get_column('ip') ;
	my $host = $row->get_column('host') ;
	$c->log->info("$m DNS A Record $ip $host");

	push(@list,
	     {
	      ip	=> $ip,
	      host	=> $host,
	     }
	    );
   }

  return @list;

}


=head2 get_dns_records_cname ()

Get CNAME record for $domain.

=cut

sub get_dns_records_cname
{
  my $self    = shift;

##Housekeeping
  my $type = 'CNAME';
  my $c = $self->context;
  my $m = "C/Domain/get_dns_record_a";

  my $reverse	= $self->reverseofdomain;

  my $rs_dns =  $c->model('cashregister::DnsRecord')->search
  ({
	reverseofdomain => $reverse,
	type		=> $type,
  });
  my @list;
  while ( my $row = $rs_dns->next )
  {
	my $aliasto = $row->get_column('aliasto') ;
	my $host = $row->get_column('host') ;
	$c->log->info("$m DNS CNAME Record $host Alias:$aliasto");

	push(@list,
	     {
	      aliasto	=> "$aliasto.",
	      host	=> $host,
	     }
	    );
   }

  return @list;

}



=head2 get_server_host ()

Get Host Server for the domain

=cut

sub get_server_host
{
  my $self    = shift;

  my $rs_server_domain;
##Housekeeping
  my $type = 'HOST';
  my $c = $self->context;
  my $m = "C/Domain/get_server_host";

  my $reverse	= $self->reverseofdomain;

  $rs_server_domain = $c->model('cashregister::ServerDomain')->search
	({
		reverseofdomain => $reverse,
		type		=> $type,
	})->first;

  my $ip ;
  $ip = $rs_server_domain->get_column('ip') if($rs_server_domain);
  $c->log->info("$m Host server: $ip");


  return $ip;

}



=head2 get_server_mail ()

Get Mail Servers for a Domain.

Returns Array of Hash(ip,priority)

=cut

sub get_server_mail
{
  my $self    = shift;

  my $rs_server_hosts;
##Housekeeping
  my $type = 'MAIL';
  my $c = $self->context;
  my $m = "C/Domain/get_server_mail";

  my $reverse	= $self->reverseofdomain;

  $rs_server_hosts = $c->model('cashregister::ServerDomain')->search
	({
		reverseofdomain => $reverse,
		type		=> $type,
	},     { order_by => 'priority',},
  );

  my @list;
  while ( my $row = $rs_server_hosts->next )
  {
    my $ip ;
    $ip = $row->get_column('ip') ;
    my $server = Class::Server->new($c,$ip);
    my $host = $server->host;
    $c->log->info("$m Mail server: $ip");

    push(@list,
         {
	  ip		=> $ip,
	  priority	=> $row->priority,
	  host	=> $host,
         }
        );
  }

  return @list;

}


=head2 add_customer ($attribs)

Add Customer details.

=cut

sub add_customer
{
  my $self    = shift;
  my $attribs = shift;

  my $rs_customer_domain;

##Housekeeping
  my $c = $self->context;
  my $m = "C/Domain/add_customer";

  $c->log->info("$m Adding Customer");
  my $reverse	= $self->reverseofdomain;

  my $service_email = $attribs->{service_email};
  my $billing_email = $attribs->{billing_email};
  my $currencycode  = $attribs->{currencycode};
  my $timezone  = $attribs->{timezone};

  my $rs_customer =  $c->model('cashregister::Customer')->create
  ({
	service_email	=> $service_email,
	billing_email	=> $billing_email,
	currencycode    => $currencycode,
	timezone	=> $timezone,
  },);

  my $customerid;
  $customerid = $rs_customer->customerid;
  my $rs_customer_domain =  $c->model('cashregister::CustomerDomain')->create
  ({
	reverseofdomain	=> $reverse,
	customerid	=> $customerid,
  });

  if ($rs_customer_domain)
  {
    my $e_typeid='DOMSRVMAIL';
    my $exception1 = Class::Exception::domain_log_add
      ($c,$e_typeid,$self->nameofdomain,$service_email) if($service_email);

    $e_typeid='DOMBLLMAIL';
    my $exception2 = Class::Exception::domain_log_add
      ($c,$e_typeid,$self->nameofdomain,$billing_email) if($billing_email) ;

    $e_typeid='DOMCURR';
    my $exception3 = Class::Exception::domain_log_add
      ($c,$e_typeid,$self->nameofdomain,$currencycode) if($currencycode) ;

    $e_typeid='DOMTIMEZON';
    my $exception4 = Class::Exception::domain_log_add
     ($c,$e_typeid,$self->nameofdomain,$timezone)	if ($timezone) ;


  }



 return $rs_customer;

}

=head2 add_server_host ($attribs)

Add Host Server. Once a new Domain is added

=cut

sub add_server_host
{
  my $self    = shift;
  my $attribs = shift;

  my $rs_server_domain;

##Housekeeping
  my $type = 'HOST';
  my $c = $self->context;
  my $m = "C/Domain/add_server_host";

  $c->log->info("$m Adding Host Server record");
  my $reverse	= $self->reverseofdomain;
  my $host	= $attribs->{host} ;
  my $ip	= $attribs->{ip} ;
  $c->log->info("$m Adding $host, $ip ");

  my $serial	= $attribs->{serial} || 1;
  my $userid	= $c->user->get('userid');
  $c->log->info("$m Adding s:$serial, U:$userid ");

  if ($ip)
  {
    $rs_server_domain =  $c->model('cashregister::ServerDomain')->find_or_create
      ({
	reverseofdomain => $reverse,
	type		=> $type,
	ip		=> $ip,
	valid		=> 1,
	priority	=> 1,
       });

    my $e_typeid='DOMHTTP';
    my $e_ctype='ADD';
    my $exception = Class::Exception::domain_log_add
      ($c,$e_typeid,$self->nameofdomain,$ip) if($rs_server_domain);
  }


 return $rs_server_domain;


}

=head2 add_dns_record_mx ($attribs)

Add DNS MX for $domain.

=cut

sub add_dns_record_mx
{
  my $self    = shift;
  my $attribs = shift;

##Housekeeping
  my $type = 'MX';
  my $c = $self->context;
  my $m = "C/Domain/add_dns_record_mx";

  $c->log->info("$m Adding MX record");
  my $reverse	= $self->reverseofdomain;

  my $host	= $attribs->{host} ;
  my $ip	= $attribs->{ip} ;
  my $priority	= $attribs->{priority} ;

  my $serial	= $attribs->{serial} || 1;
  my $userid	= $c->user->get('userid');

  my $rs_dns_language =  $c->model('cashregister::DnsRecord')->create
  ({
	reverseofdomain => $reverse,
	type		=> $type,

	host	=> $host,
	ip	=> $ip,
	priority => $priority,
	valid	=> 1,
	userid	=> $userid,
  });

#
#  my $e_typeid='DOMDNSMX';
#  my $exception = Class::Exception::domain_log_add
#    ($c,$e_typeid,$self->nameofdomain,$ip,$priority) 
#      if($rs_dns_language);

 return $rs_dns_language;

}

=head2 del_alias

Delete Alias Table record for domain

=cut

sub del_alias
{
  my $self    = shift;
  my $refarr  = shift;

##Housekeeping
  my $type = 'MX';
  my $c = $self->context;
  my $m = "C/Domain/del_alias";

  $c->log->info("$m Deleting MX record");
  my $reverse	= $self->reverseofdomain;

##Find all the Records
  my $rs_row =  $c->model('cashregister::Alias')->find
  ({
	reverseofdomain => $reverse,
  });

##Delete All the Records
  $rs_row->delete;

}


=head2 del_dns_record_mx 

Edit Delete MX for $domain.

=cut

sub del_dns_record_mx
{
  my $self    = shift;
  my $refarr  = shift;

##Housekeeping
  my $type = 'MX';
  my $c = $self->context;
  my $m = "C/Domain/del_dns_record_mx";

  $c->log->info("$m Deleting MX record");
  my $reverse	= $self->reverseofdomain;

##Find all the Records
  my $rs_dns_records =  $c->model('cashregister::DnsRecord')->search
  ({
	reverseofdomain => $reverse,
	type		=> $type,
  });

  while ( my $row = $rs_dns_records->next() )
  {
    my $ip = $row->get_column('ip');
    my $priority = $row->get_column('priority');
#
#    my $e_typeid='DOMPRIMX';
#    my $exception = Class::Exception::domain_log_del
#      ($c,$e_typeid,$self->nameofdomain,$ip,$priority) ;
  }


##Delete All the Records
  $rs_dns_records->delete;
  return 	$rs_dns_records;
}


=head2 del_dns_record_a 

Delete DNS MX for $domain.

=cut

sub del_dns_record_a
{
  my $self    = shift;
  my $refarr  = shift;

##Housekeeping
  my $type = 'A';
  my $c = $self->context;
  my $m = "C/Domain/del_dns_record_a";

  $c->log->info("$m Deleting A record");
  my $reverse	= $self->reverseofdomain;

##Find all the Records
  my $rs_dns_records =  $c->model('cashregister::DnsRecord')->search
  ({
	reverseofdomain => $reverse,
	type		=> $type,
  });

  while ( my $row = $rs_dns_records->next() )
  {
    my $ip	 = $row->get_column('ip');
    my $priority = $row->get_column('priority');

    my $e_typeid='DOMDNSA';
    my $exception = Class::Exception::domain_log_del
      ($c,$e_typeid,$self->nameofdomain,$ip) ;
  }


##Delete All the Records
  $rs_dns_records->delete;
  return 	$rs_dns_records;
}

=head2 del_dns_record_cname

Delete DNS CNAME for $domain.

=cut

sub del_dns_record_cname
{
  my $self    = shift;
  my $refarr  = shift;

##Housekeeping
  my $type = 'CNAME';
  my $c = $self->context;
  my $m = "C/Domain/del_dns_record_a";

  $c->log->info("$m Deleting A record");
  my $reverse	= $self->reverseofdomain;

##Find all the Records
  my $rs_dns_records =  $c->model('cashregister::DnsRecord')->search
  ({
	reverseofdomain => $reverse,
	type		=> $type,
  });

  while ( my $row = $rs_dns_records->next() )
  {
    my $ip	 = $row->get_column('ip');

    my $e_typeid='DOMDNSCNAM';
    my $exception = Class::Exception::domain_log_del
      ($c,$e_typeid,$self->nameofdomain,$ip) ;
  }


##Delete All the Records
  $rs_dns_records->delete;
  return 	$rs_dns_records;
}



=head2 add_server_mail ($attribs)

Add Mail Server. Once a new Domain is added

=cut

sub add_server_mail
{
  my $self    = shift;
  my $attribs = shift;

##Housekeeping
  my $type = 'MAIL';
  my $c = $self->context;
  my $m = "C/Domain/add_server_mail";

  $c->log->info("$m Adding Host Server record");
  my $reverse	= $self->reverseofdomain;
  my $priority	= $attribs->{priority} ;
  my $ip	= $attribs->{ip} ;
  $c->log->info("$m Adding MX $priority, $ip ");

  my $userid	= $c->user->get('userid');
  $c->log->info("$m Adding U:$userid ");

  my $rs_server_domain =  $c->model('cashregister::ServerDomain')->find_or_create
  ({
	reverseofdomain => $reverse,
	type		=> $type,
	ip		=> $ip,
	valid		=> 1,
	priority	=> $priority,
  });

  my $e_typeid='DOMPRIMX';
  my $exception = Class::Exception::domain_log_add
    ($c,$e_typeid,$self->nameofdomain,$ip,$priority) 
      if($rs_server_domain);


 return $rs_server_domain;


}


=head2 del_server_mail ($attribs)

Remove all Mail Servers

=cut

sub del_server_mail
{
  my $self    = shift;

##Housekeeping
  my $type = 'MAIL';
  my $c = $self->context;
  my $m = "C/Domain/del_server_mail";

  $c->log->info("$m Removing Server record");
  my $reverse	= $self->reverseofdomain;

  my $rs_server_domain =  $c->model('cashregister::ServerDomain')->search
  ({
	reverseofdomain => $reverse,
	type		=> $type,
  });


  while ( my $row = $rs_server_domain->next() )
  {
    my $ip = $row->get_column('ip');
    my $priority = $row->get_column('priority');

    my $e_typeid='DOMPRIMX';
    my $exception = Class::Exception::domain_log_del
      ($c,$e_typeid,$self->nameofdomain,$ip,$priority) ;
  }

  $rs_server_domain->delete;
  return $rs_server_domain;

}


=head2 get_domains ($context [, $selected  ])

Get Domains from Table Domain

=cut

sub get_domains
{
  my $c                 = shift;
  my $in_selected       = shift;

  my $f = "C/D/get_domains";

  $in_selected = $in_selected;
  $c->log->debug("$f Start SELECTED:$in_selected");
  my @list;

  my @order = ('reverseofdomain');
  my $domain_rs = $c->model('cashregister::Domain')->search
    ({alias => '0'},
     {order_by=> @order,}
    );

  while ( my $domain_row = $domain_rs->next )
  {

    my $reverseofdomain      = $domain_row->reverseofdomain;
    my $nameofdomain	     = $domain_row->nameofdomain;

    my $selected;
    if ($reverseofdomain eq $in_selected)
    {
      $c->log->debug("$f Start IN:$in_selected,CODE:$reverseofdomain");
      $selected='SELECTED';
    }

    push(@list,
         {
          reverseofdomain   => $reverseofdomain,
          nameofdomain      => $nameofdomain,
	  selected	    => $selected,
         }
        );

  }

  return @list;

}

=head2 get_nonalias_domains ($context [, $selected  ])

Get Domains from Table Domain

=cut

sub get_nonalias_domains
{
  my $c                 = shift;
  my $in_selected       = shift;

  my $f = "C/D/get_domains";

  $in_selected = $in_selected;
  $c->log->debug("$f Start SELECTED:$in_selected");
  my @list;

  my @order = ('reverseofdomain');
  my $domain_rs = $c->model('cashregister::Domain')->search
    ({alias => '0'},
     {order_by=> @order,}
    );

  while ( my $domain_row = $domain_rs->next )
  {

    my $reverseofdomain      = $domain_row->reverseofdomain;
    my $nameofdomain	     = $domain_row->nameofdomain;

    my $selected;
    if ($reverseofdomain eq $in_selected)
    {
      $c->log->debug("$f Start IN:$in_selected,CODE:$reverseofdomain");
      $selected='SELECTED';
    }

    push(@list,
         {
          reverseofdomain   => $reverseofdomain,
          nameofdomain      => $nameofdomain,
	  selected	    => $selected,
         }
        );

  }

  return @list;

}


=head2 get_parent_domains ($context [, $selected  ])

Get Domains from Table Domain

=cut

sub get_parent_domains
{
  my $c                 = shift;
  my $in_selected       = shift;

  my $f = "C/D/get_domains";

  $in_selected = $in_selected;
  $c->log->debug("$f Start SELECTED:$in_selected");
  my @list;

  my @order = ('reverseofdomain');
  my $domain_rs = $c->model('cashregister::Domain')->search
    ({ level => 1,
     },
     {order_by=> @order,}
    );

  while ( my $domain_row = $domain_rs->next )
  {

    my $reverseofdomain      = $domain_row->reverseofdomain;
    my $nameofdomain	     = $domain_row->nameofdomain;

    my $selected;
    if ($reverseofdomain eq $in_selected)
    {
      $c->log->debug("$f Start IN:$in_selected,CODE:$reverseofdomain");
      $selected='SELECTED';
    }

    push(@list,
         {
          reverseofdomain   => $reverseofdomain,
          nameofdomain      => $nameofdomain,
	  selected	    => $selected,
         }
        );

  }

  return @list;

}

=head2 get_parents_noalias ($context [, $selected  ])

Get Top Domains Which are not alias

=cut

sub get_parents_noalias
{
  my $c                 = shift;
  my $in_selected       = shift;

  my $f = "C/D/get_domains";

  $in_selected = $in_selected;
  $c->log->debug("$f Start SELECTED:$in_selected");
  my @list;

  my @order = ('reverseofdomain');
  my $domain_rs = $c->model('cashregister::Domain')->search
    ({ level => 1,
       alias => 0,
     },
     {order_by=> @order,}
    );

  while ( my $domain_row = $domain_rs->next )
  {

    my $reverseofdomain      = $domain_row->reverseofdomain;
    my $nameofdomain	     = $domain_row->nameofdomain;

    my $selected;
    if ($reverseofdomain eq $in_selected)
    {
      $c->log->debug("$f Start IN:$in_selected,CODE:$reverseofdomain");
      $selected='SELECTED';
    }

    push(@list,
         {
          reverseofdomain   => $reverseofdomain,
          nameofdomain      => $nameofdomain,
	  selected	    => $selected,
         }
        );

  }

  return @list;

}



=head2 create_clone_domain($c, $clone_domain_obj, $name_new_domain)

Clone the Domain, use the same mx server,host server, dns_records.

=cut

sub create_clone_domain
{
  my $c		= shift;
  my $domain	= shift;
  my $name	= shift;

  my $f = "C/D/create_clone_domain";

  my ($origin,$nsprimary,$refresh,$expire,$retry,$ttl,$mimimumttl,$email);
  $origin	= config(qw/domain dns origin/);
  $nsprimary    = config(qw/domain dns nsprimary/);
  $refresh	= config(qw/domain dns refresh/);
  $retry	= config(qw/domain dns refresh/);
  $expire	= config(qw/domain dns expire/);
  $ttl		= config(qw/domain dns ttl/);
  $mimimumttl	= config(qw/domain dns mimimumttl/);
  $email	= config(qw/domain dns email/);
  my $userid    = $c->user->get('userid');

  my ($nameofdomain,$level,$alias,$email,$ns,$origin,$userid);
  my ($details,$default_language);
  my $host_ip;
  my (@languages,@domain_mail_servers);
  my $rs_customer;

  $nameofdomain = $domain->nameofdomain;
  $host_ip      = $domain->get_server_host;

  $c->log->info("$f Alias:$alias, Host: $host_ip");

  ##Languages
  @languages = $domain->get_languages;
  $default_language = $domain->default_language;
  $c->log->info("$f Default Lang:$default_language");

  $rs_customer = $domain->get_customer;
  my ($cst_currency,$cst_srv_email,$cst_bll_email,$cst_timezone);
  if ($rs_customer)
  {
    $cst_currency   = $rs_customer->get_column('currencycode');
    $cst_srv_email  = $rs_customer->service_email;
    $cst_bll_email  = $rs_customer->billing_email;
    $cst_timezone   = $rs_customer->timezone;
    $c->log->info("$f TimeZone:$cst_timezone");

  }

  @domain_mail_servers = $domain->get_server_mail;
  my $new_domain;
  my ($reverse_name);
  $reverse_name = reverse $name;
  $level = $name =~ tr/.//;

  my %dom_hash = (
		  reverseofdomain	=> $reverse_name,
		  nameofdomain		=> $name,
		  level			=> $level,
		  userid		=> $userid,
		  alias			=> 0,
		  origin		=> $origin || $nsprimary,
		  nsprimary		=> $nsprimary,
		  refresh		=> $refresh,
		  retry			=> $retry,
		  expire		=> $expire,
		  ttl			=> $ttl,
		  email			=> $cst_srv_email,
		 );

  my %customer_hash = 
    (
     service_email	=> $cst_srv_email,
     billing_email	=> $cst_bll_email,
     currencycode	=> $cst_currency,
     timezone		=> $cst_timezone,
    );



  ##Create Domain
  $c->log->info("$f Adding Domain");
  $new_domain     = Class::Domain::create($c,\%dom_hash);
  $c->log->info("$f Added Domain:$new_domain");

  ##Add Languages.
  my $added_lang = $new_domain->add_languages($default_language,\@languages)
    if ($new_domain && $default_language);
  $c->log->info("$f Added Primary Lanugage :$added_lang");

  my $a_dom;
  my $name = $new_domain->nameofdomain;
  $a_dom->{host} = $name;
  $a_dom->{ip}   = $host_ip;

  my $b_dom;
  my $a_str =  "www.$name";
  $b_dom->{host} = "www.$name";
  $b_dom->{ip}   = $host_ip;

  ##Create DNS Record, A 
  my $rs_dns_record_1 = $new_domain->add_dns_record_a($a_dom);
  $c->log->info("$f A Added Domain");
  my $rs_dom_server   = $new_domain->add_server_host($a_dom);
  $c->log->info("$f A Added Host Sever");
  ##Create DNS Record, A , www
  my $rs_dns_record_2 = $new_domain->add_dns_record_cname($a_str,$name);
  $c->log->info("$f A Added MX for the Domain");


  ##Create Mail record.
  foreach my $ms (@domain_mail_servers)
  {
    my $m_ip	= $ms->{ip};
    my $m_priority	= $ms->{priority};
    $c->log->info("$f $m_ip MX pri:$m_priority");
    my %m_h =
      (
       ip	 => $m_ip,
       priority => $m_priority,
      );

    my $rs_dns_record_mx	= $new_domain->add_dns_record_mx(\%m_h);
    my $rs_dom_server		= $new_domain->add_server_mail(\%m_h);
  }
  $c->log->info("$f Added MX for Domain");

  ##Create Customer Record and Currency.
  $c->log->info("$f Add customer");
  my $customer = $new_domain->add_customer(\%customer_hash);
  $c->log->info("$f All Done in Cloning rs_customer:$customer");



  return $new_domain;

}


=head2 create_clone_subdomain($c, $clone_domain_obj, $parent_domain,
 $name_new_domain, $attribs)

Clone the Domain, use the same mx server,host server, dns_records.

=cut

sub create_clone_subdomain
{
  my $c			= shift;
  my $parent_domain	= shift;
  my $input		= shift;

  my $domain_hash	= $input->{domain_hash};
  my $http_ip		= $input->{http_ip};

  my $f			= "C/D/create_clone_subdomain";

  my ($origin,$nsprimary,$refresh,$expire,$retry,$ttl,$mimimumttl,$email);
  $origin	= config(qw/domain dns origin/);
  $nsprimary    = config(qw/domain dns nsprimary/);
  $refresh	= config(qw/domain dns refresh/);
  $retry	= config(qw/domain dns refresh/);
  $expire	= config(qw/domain dns expire/);
  $ttl		= config(qw/domain dns ttl/);
  $mimimumttl	= config(qw/domain dns mimimumttl/);
  $email	= config(qw/domain dns email/);
  my $userid    = $c->user->get('userid');

  my ($nameofdomain,$level,$alias,$email,$ns,$origin,$userid);
  my ($details,$default_language);
  my (@languages,@domain_mail_servers);
  my $rs_customer;

  my $domain;
  $domain	= Class::Domain::create($c,$domain_hash);
  my $name	= $domain->nameofdomain;

  my $a_dom;
  my $b_dom;
  my $name	 = $domain->nameofdomain;
  
  $a_dom->{host} = $name;
  $a_dom->{ip}   = $http_ip;
  my $a_str =  "www.$name";
  $b_dom->{host} = "www.$name";
  $b_dom->{ip}   = $http_ip;

  ##Create DNS Record, A 
  my $rs_dns_record_1 = $parent_domain->add_dns_record_a($a_dom);
  $c->log->info("$f A Added Domain for $name, $http_ip");
  my $rs_dom_server   = $parent_domain->add_server_host($a_dom);
  $c->log->info("$f A Added Host Sever");
  ##Create DNS Record, A , www
  my $rs_dns_record_2 = $parent_domain->add_dns_record_cname($a_str,$name);
  $c->log->info("$f A Added MX for the Domain");


  return $domain;

}

=head2 modify_customer($c,$attribs)

Modify Customer details for a Domain

=cut

sub modify_customer
{
  my	$domain	= shift;
  my    $c	= shift;
  my	$in	= shift;

  my $f = "C/Domain/modify_customer";
  my $c = $domain->context;

  my ($cst_currency,$cst_srv_email,$cst_bll_email,$cst_timezone);
  my $rs_customer;
  my $updated = 0;

  $rs_customer = $domain->get_customer;
  if ($rs_customer)
  {
    $cst_currency   = $rs_customer->get_column('currencycode');
    $cst_srv_email  = $rs_customer->service_email;
    $cst_bll_email  = $rs_customer->billing_email;
    $cst_timezone   = $rs_customer->timezone;
    $c->log->info("$f TimeZone:$cst_timezone");

  }

  my ($i_currency,$i_billing_email,$i_service_email,$i_timezone);
  $i_billing_email	= $in->{customer_billing_email};
  $i_service_email	= $in->{customer_service_email};
  $i_currency		= $in->{default_currency};
  $i_timezone		= $in->{default_timezone};

  if ( ($rs_customer)  &&
       ( $i_currency && ($i_currency ne $cst_currency) ) ||
       ( $i_billing_email && ($i_billing_email ne $cst_bll_email ) )	||
       ( $i_service_email && ($i_service_email ne $cst_srv_email) ) ||
       ( $i_timezone && ($i_timezone ne $cst_timezone) )
     ) {


    if ($rs_customer)
    {

      $rs_customer->currencycode($i_currency) if($i_currency);
      $rs_customer->service_email($i_service_email) if($i_service_email);
      $rs_customer->billing_email($i_billing_email) if($i_billing_email);
      $rs_customer->timezone($i_timezone) if($i_timezone);
      $rs_customer->update;
      $c->log->info("$f Customer RS records Updated");

      my $c_type = 'CHANGE';

      my $e_typeid='DOMSRVMAIL';
      my $exception1 = Class::Exception::domain_log
	($c,$e_typeid,$domain->nameofdomain,$c_type,
	 $cst_srv_email,$i_service_email) 
	  if ($i_service_email ne $cst_srv_email);

      $e_typeid='DOMBLLMAIL';
      my $exception2 = Class::Exception::domain_log
	($c,$e_typeid,$domain->nameofdomain,$c_type,
	 $cst_bll_email,$i_billing_email)  
	  if ($i_billing_email ne $cst_bll_email) ;

      $e_typeid='DOMCURR';
      my $exception3 = Class::Exception::domain_log
	($c,$e_typeid,$domain->nameofdomain,$c_type,$cst_currency,
	 $i_currency)		
	  if ($i_currency ne $cst_currency) ;

      $e_typeid='DOMTIMEZON';
      my $exception4 = Class::Exception::domain_log
	($c,$e_typeid,$domain->nameofdomain,$c_type,$cst_timezone,
	 $i_timezone)		
	  if ($i_timezone ne $cst_timezone) ;
      $updated++;
    }
  }

  return $updated;

}


=head2 create_bind_zone

Create Bind zone File for the Domain.

=cut

sub create_bind_zone
{
	my $domain	= shift;
	my $c		= $domain->context;
	my $m		= "D/create_bind_zone";

	my $m = "D/create_bind_zone";
	$c->log->debug("$m Start");

	my ($nameofdomain,$level,$alias,$alias_name,$email,$ns,$origin,$userid,$host_ip);
	$nameofdomain = $domain->nameofdomain if ($domain);
	my $did = reverse $nameofdomain;
	##
	my $newzone;
	#  my $zone_file_dir= '/tmp';
	my $zone_file_dir = config(qw/src_dir config zone/);
	my $zone_file = "$zone_file_dir/$nameofdomain.hosts";
	open($newzone, '>', $zone_file) or die "error";
	my $origin = undef;
	my $zonefile = DNS::ZoneParse->new($zone_file,$origin);
	my ($soa);

	$c->log->info("$m Input: $did");
	my ($details,$default_language);
	my ($c_service_email,$c_billing_email,$alias_dname);
	my (@mail_servers, @languages,@dns_servers,@a_records,@c_records);
	my $today = Class::Utils::today;

	if ($domain)
	{

	  $level        = $domain->level;

	  $alias	= $domain->alias;
	  $alias_name	= reverse $alias if($alias);

	  $c->log->info("$m Alias:$alias");
	  $userid = $domain->userid;

	  #DNS Zone file SOA 
	  $soa			= $zonefile->soa();


	  $soa->{origin}	= "$nameofdomain.";
	  $soa->{refresh}	= $domain->refresh;
	  $soa->{retry}		= $domain->retry;
	  $soa->{expire}	= $domain->expire;
	  $soa->{ttl}		= $domain->ttl;
	  $soa->{minimumTTL}	= '2100';
	  $soa->{email}		= $domain->email || "info.$nameofdomain";
	  $soa->{primary}	= $domain->nsprimary;
	  #	$soa->{email}	= $domain->email;

	  ##DNS Zone file: A Record, Host Server(apache)
	  ## This is where apache vhost file needs to be sent.
	  $host_ip      = $domain->get_server_host;
	  $c->log->info("$m HOST:$host_ip");

	  ##DNS Zone file : NS and MX records
	  @mail_servers = $domain->get_server_mail;
	  @dns_servers = Class::Server::get_servers_for_type($c,'DNS');

	  @a_records = $domain->get_dns_records_a;
	  @c_records = $domain->get_dns_records_cname;

	  ##Apache Records
	  @languages = $domain->get_languages;
	  $default_language = $domain->default_language;
	  $c->log->info("$m Default Lang:$default_language");


	}

	#Write Bind file.
	if ($soa)
	{
	  my $class='IN';
	  $zonefile->new_serial();

	  ##ADD NS Records
	  my $ns_records = $zonefile->ns();
	  foreach my $dns (@dns_servers)
	  {
	    my $ip   = $dns->{ip};
	    my $host = $dns->{host};
	    $host = "$host.";

	    push(@$ns_records,
		 {
		  #	   name		=> $nameofdomain,
		  class		=> $class,
		  host		=> $host,
		 });
	  }


	  ## Add the MX Records
	    my $mx_records = $zonefile->mx();
	    foreach my $srv (@mail_servers)
	    {
	      my $ip  = $srv->{ip}||0;
	      my $pri = $srv->{priority};
	      my $host = $srv->{host};
	      $host = "$host.";

	      push(@$mx_records,
		   {
		    #		name		=> $nameofdomain,
		    class		=> $class,
		    priority	=> $pri,
		    host		=> $host,
		   });

	    }			##Foreach Mail


	    ##ADD A Records for the Domain.
	    my $a_dns = $zonefile->a();
	    foreach my $arec (@a_records)
	    {
	      my $host   =  $arec->{ip};
	      my $name   = $arec->{host};
	      $name = "$name.";

	      push(@$a_dns,
		   {
		    name		=> $name,
		    host		=> $host,
		    class	=> $class,
		   });
	    }

	    ##ADD Cname Records for the Domain.
	    my $c_dns = $zonefile->cname();
	    foreach my $arec (@c_records)
	    {
	      my $aliasto   =  $arec->{aliasto};
	      my $host   = $arec->{host};
	      $host = "$host.";

	      push(@$c_dns,
		   {
		    name		=> $host,
		    host		=> $aliasto,
		    class	=> $class,
		   }) ;#if(!$alias);
	    }


	  }			##IF alias, then no mx.


#	if ($alias && $alias ne 'undef' )
#	{
#	  my $rev_a = reverse $alias;
#	  $alias_dname = 
#	    "$nameofdomain.              IN      DNAME   $rev_a. ";
#	}

	#Print File and Close it.
	print $newzone $zonefile->output();
#	if ($alias_dname)
#	{
#	  print $newzone $alias_dname;
#	}

	close $newzone;

  	my $data = read_file($zone_file);
  	$data =~ s/\$ORIGIN//g;
  	write_file($zone_file, $data);

#	infile_replace_content($c,$zone_file,"\$ORIGIN","");

	$c->log->debug("$m Start $zonefile");
	return $zone_file;

}

sub infile_replace_content
{
  my $c		= shift;
  my $file	= shift;
  my $old	= shift;
  my $new	= shift;


  my $data = read_file($file);
  $data =~ s/$old//g;
  write_file($file, $data);

}

sub read_file {
    my ($filename) = @_;

    open my $in, '<:encoding(UTF-8)', $filename or die "Could not open '$filename' for reading $!";
    local $/ = undef;
    my $all = <$in>;
    close $in;

    return $all;
}

sub write_file {
    my ($filename, $content) = @_;

    open my $out, '>:encoding(UTF-8)', $filename or die "Could not open '$filename' for writing $!";;
    print $out $content;
    close $out;

    return;
}


=head2 create_apache_vhost

Create VHOst file for the domain.

=cut

sub create_apache_vhost
{

  my $domain = shift;
  my $c = $domain->context;

  my $m = "D/create_apache_vhost";
  $c->log->debug("$m Start");

  my ($nameofdomain,$level,$alias,$email,$ns,$origin,$userid,$host_ip);
  $nameofdomain = $domain->nameofdomain if ($domain);
  my $www_name = "www.$nameofdomain";

  my $other_aliases;
  my @aliases = $domain->get_aliases;
  foreach my $ali(@aliases)
  {
    my $name = $ali->{name};
    $other_aliases .= "$name *.$name  ";
  }

  my $newhost;
  #  my $zone_file_dir= '/tmp';
  my $host_file_dir = config(qw/src_dir config apache/);
  my $host_file = "$host_file_dir/$nameofdomain";
  open($newhost, '>', $host_file) or die "error";

#<VirtualHost $nameofdomain>, 

  my $d_web_directory = config(qw/dst_dir config web/);
  my $d_doc_root = "$d_web_directory/$nameofdomain";
  my $vhostContent = << "EOF";

<VirtualHost *:80>
    ServerName $www_name
    ServerAlias $nameofdomain $other_aliases
    DocumentRoot $d_doc_root
    <directory $d_doc_root >
        Options Indexes FollowSymLinks
        AllowOverride All
        Order allow,deny
        Allow from all
    </directory>
</VirtualHost>

EOF


  print $newhost $vhostContent;
  close $newhost;

  $c->log->debug("$m End $host_file");
#  return $host_file;


}




=head2 copy_apache_vhost($c,$ssh_connection,$domain)

This function copies Zone File for a domain to the server.

=cut

sub copy_apache_vhost
{
	my $c			= shift;
	my $ssh_connection	= shift;
	my $domain		= shift;

	my $f = "Class/Server/copy_apache_vhost";
	my $nameofdomain  = $domain->nameofdomain;

	my $dst_apache_host_dir = config(qw/dst_dir config apache/);

	my $host_file_dir = config(qw/src_dir config apache/);
	my $host_file = "$host_file_dir/$nameofdomain";

	my $postfix = config(qw/dst_dir file_postfix apache/);
	$postfix = ".$postfix" if($postfix );
	my $destination = "$dst_apache_host_dir/$nameofdomain"."$postfix";

	$c->log->debug("$f Should be X: $destination ");

	$c->log->debug("$f $ssh_connection  $dst_apache_host_dir");
#	$ssh_connection->scp_put($host_file,$dst_apache_host_dir);
	$ssh_connection->scp_put($host_file,$destination);

	my $status = $ssh_connection->error;

	return $status;


}



=back

=cut

1;
