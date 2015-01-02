#!/usr/bin/perl -w
#
# Class/Utils
#
# Utility methods for DB abstraction classes.
#
#
use strict;

package Class::Utils;

use Date::Manip;
use POSIX qw/strftime/;
use HTML::TagFilter;
use HTML::Entities;
#use Crypt::Cracklib; Instead use DataPassword
use Data::Password;
use Captcha::reCAPTCHA;
use Data::Validate::IP qw(is_ipv4);;
use Data::Validate::Domain qw(is_domain is_hostname);;


#
# Required for testing only
use IPC::SysV qw/IPC_CREAT/;

use vars qw(@ISA @EXPORT_OK);
require Exporter;

@ISA        = qw/Exporter/;
@EXPORT_OK  = qw/set_today today now chomp_date
		 format_date valid_date 
		 valid_ip valid_domain valid_hostname
		 display_error display_message
		 unxss
		 date_search_hashref
		 round decimal_fmt
		 commify_series commify
		 user_login user muser
		 set_muser is_muser
		 check_password_strength generate_password
		 get_recaptcha validate_recaptcha
		 selected_language arg
		 sort_array intersection uniquearray aonly
		 get_keyval_from_arrayofhash
		 makeparm
		 maphash myname trim
		 get_array_from_argument
		 config
		/;

=pod

=head1 NAME

Class::Utils - Utility methods

=head1 SYNOPSIS

    use Class::Utils;

See METHODS for list of methods available in this class.

=head1 DATE MANIPULATION

=over

=item B<set_today( $date )>

Set this if you want today to return a date other than the current
date.  Useful for testing.

Set to an empty value to resume using today's date.

=cut
# Value of today
sub set_today
{
  my
    $new_today = shift;
  my
    $shared_today = shmget(1161, 1024, IPC_CREAT|0600);
#print STDERR "shared_today $shared_today\n";
  shmwrite($shared_today, $new_today, 0, 10);
#print STDERR "shared_today 2 $shared_today\n";
}

=item B<today>

Return today's date as YYYY-MM-DD string.  If you set
Class::Utils::today earlier it will return that value.

=cut
# Get today's date
#
sub today
{
  my
    $shared_today = shmget(1161, 1024, IPC_CREAT|0600);
  my
    $today;
#print STDERR "TODAY: got SHM $shared_today\n";
  shmread($shared_today, $today, 0, 10);
#print STDERR "TODAY: got TODAY $today\n";
  if( $today gt '0' )
  {
    return( $today );
  }
  else
  {
    return( POSIX::strftime('%Y-%m-%d', localtime) );
  }
}

=item B<now>

Return the current time as HH:MM:SS.

=cut
# Get the time
sub now
{
  return( POSIX::strftime('%H:%M:%S', localtime) );
}



=item B<chomp_date($date)>

Chop off everything from the date except the actual date part (initial
YYYY-MM-DD).

=cut
# Chomp date
sub chomp_date
{
  my
    $date = shift;
  return( substr($date, 0, 10) );
}

=item B<<< format_date( $date ) >>>

Format a YYYY-MM-DD date as Month DD, YYYY

=cut
# Format a date into human-readable format
sub format_date
{
  my
    $date = shift;
  my
    ($yyyy, $mm, $dd) = split(/-/, chomp_date($date));
  my
    @month = (qw/NONE January February March April May June July August September
		 October November December/);
  return( "$month[$mm] $dd, $yyyy" );
}

=item B<<< valid_date( $date ) >>>

Return $date if it is a valid date, undef otherwise.  Remove any time
portion that may exist.

=cut
sub valid_date
{
  my
    $date = shift;
  $date = chomp_date($date);
  #
  # Check the format
  return( undef )
    unless $date =~ /\d\d\d\d-\d\d-\d\d/;
  #
  # Check it's valid
  if( ParseDate($date) )
  {
    return( $date );
  }
  else
  {
    return( undef );
  }
}

=item B<<< valid_ip( $ip ) >>>

Returns Valid IP

=cut
sub valid_ip
{
 my $ip = shift;

 if(is_ipv4($ip))
 {
	return $ip;
 }

 return undef;

}


=item B<<< valid_hostname( $hostname ) >>>

Returns Valid Hostname

=cut
sub valid_hostname
{
 my $hostname = shift;

 if(is_hostname($hostname))
 {
	return $hostname;
 }

 return undef;

}


=item B<<< valid_domain( $domain ) >>>

Returns Valid Domain

=cut
sub valid_domain
{
 my $domain = shift;

 if(is_domain($domain))
 {
	return $domain;
 }

 return undef;

}


=back

=head1 USER DISPLAY UTILITIES

=over

=item B<display_error( $context, $str... )>

Displays one or more HTML strings in the error portion of the page.
Automatically separates multiple strings with <P>.

=cut
# Display error in page
sub display_error
{
  my
    $c = shift;
  foreach my $s( @_ )
  {
    $c->stash->{cashregister}->{error} .= $s."<P>\n";
  }
}

=item B<display_message( $context, $str... )>

Displays one or more HTML strings in the message portion of the page.
Automatically separates multiple strings with <P>.

=cut
# Display message in page
sub display_message
{
  my
    $c = shift;
  foreach my $s( @_ )
  {
    $c->stash->{cashregister}->{message} .= $s."<P>\n";
  }
}

=back

=over

=item B<unxss( $str )>

Replace any shell/SQL metacharacters in $str with their safe URL-ised
versions (' to %27, etc.).  This is for preventing Cross-Site
Scripting (XSS) attacks.

Remove all leading and trailing whitespace.

=cut
# Make XSS characters safe
sub unxss
{
  my
    $str = shift;

#Remove the leading space
  if( defined($str) )
  {
    $str =~ s/^\s*//;
    $str =~ s/\s*$//;
  }

#
#http://www.perl.com/pub//2002/02/20/css.html
#this is new, Get only Alphabets, or numbers
  $str =~ s/[^A-Za-z0-9\- \_]*//g;

  #$str = HTML::TagFilter->new->filter($str);
  $str = HTML::Entities::encode($str, '<>&');
#  # Put single quotes, etc back.  Easier than meddling with HTML::Entities.
#  my
#    %xform = ('&#39;'=> "'");
#  foreach my $x( keys(%xform) )
#  {
#    $str =~ s/$x/$xform{$x}/g;
#  }


  return( $str );
}



=item B<<< date_search_hashref( $date ) >>>

Return a DBIx::Class::ResultSet->search compatible hashref for $date,
which may be a single date string or an arrayref [start, end].

=cut
# Make a date search hashref
sub date_search_hashref
{
  my
    $date = shift;
  my
    $date1;
  my
    $date2;
  #
  # date=>[$start, $end]
  if ( ref($date) eq 'ARRAY' )
  {
    $date1 = chomp_date($date->[0]);
    $date2 = add_days(chomp_date($date->[1]), 1);
  }
  #
  # date=>$date
  else
  {
    $date1 = chomp_date($date);
    $date2 = add_days($date1, 1);
  }
  return( {'>=', $date1, '<', $date2} );
}

=back

=head1 CONFIGURATION

These methods let you access application configuration values easily.

=over

=item B<round( $value )>

Round the value (upto .50 rounds down, .51 and greater rounds up) and
return the result.  Handles negative values.

=cut
# Round a number
sub round
{
  my
    $value = shift;
  my
    $sign = $value < 0 ? -1 : 1;
  $value = abs($value);
  my
    $int_value = int($value);
  my
    $frac_value = $value - $int_value;
  if( $frac_value > 0.50 )
  {
    return( $sign * ($int_value + 1) );
  }
  else
  {
    return( $sign * $int_value );
  }
}

=item B<<< decimal_fmt( $amount [, $decimals] ) >>>

Return string with $decimal decimal places (or 2 by default) in
$amount.

=cut
# Format with 2 (or other) decimal places
sub decimal_fmt
{
  my
    $amount = shift;
  my
    $decimals = shift;
  $decimals = 2
    unless defined($decimals);
  my
    $fmtstr = "%.${decimals}f";
  return( sprintf($fmtstr, $amount) );
}





=back

=head1 USER UTILITIES

=over

=item B<user_login( $context )>

Return the login field of the currently-selected user.

=cut
# Login ID
sub user_login
{
  my
    $c = shift;
  return( $c->user_exists ?$c->user->get('login') :undef );
}

=item B<user( $context )>

Return the Class::EloorUser object corresponding to the currently
logged-in user, or undef if the user isn't logged in.

=cut
# Current user object
sub user
{
  my
    $c = shift;
  my
    $rec = Class::Appuser->new($c, user_login($c));
  return( $rec );
}

=item B<muser( $context )>

Return the Class::AppUser object corresponding to the currently
selected effective user for this session.  Return the currently
logged-in user if no effective user has been selected.

=cut
# Get effective user
sub muser
{
  my
    $c = shift;
  my
    $euserid = $c->session->{__effective_userid};
  return( user($c) )
    unless $euserid;
  my
    $rec = Class::Appser->new($c, $euserid);
  return( $rec );
}

=item B<set_muser( $context [, $userid] )>

Set the effective user ID for this session to the provided $userid,
which may be a Class::AppUser object or a user ID string.  Delete
the effective user ID for this session if $userid is empty.

Return the Class::AppUser object corresponding to selected effective
user ID, or the currently logged-in user in case $userid is empty.

=cut
# Set effective user ID
sub set_muser
{
  my
    $c = shift;
  my
    $userrec = shift;
  my
    $userid = ref($userrec) ?$userrec->login :$userrec;
  if( $userid )
  {
    $c->session->{__effective_userid} = $userid;
    return( euser($c) );
  }
  else
  {
    delete($c->session->{__effective_userid});
    return( user($c) );
  }
}

=item B<is_muser( $context )>

Return 1 if the user has selected an effective user ID, 0 otherwise.

=cut
# Is effective user selected?
sub is_euser
{
  my
    $c = shift;
  return( $c->session->{__effective_userid} ?1 :0 );
}

=item B<<< check_password_strength( $password ) >>>

Check the strength of the password $password using Crypt::Cracklib.

Return undef if the password is acceptable.  Return a string
describing the weakness if the password is not strong enough.

Note that this method returns undef on success.

=cut
# Check password strength
sub check_password_strength
{
  my
    $passwd = shift;
#  my  $ret = fascist_check($passwd);
#  return( $ret eq 'ok' ?undef :$ret );

#Using Data::Password
  my $ret = IsBadPassword($passwd);
  if($ret)
  {
    return $ret;
  }
  else
  {
    return undef;
  }

}

=item B<<< generate_password( [$length] ) >>>

Generate a reasonable strong random password of $length characters.
$length defaults to 8.

=cut
# Generate random password
sub generate_password
{
  my
    $length = shift || 8;
  my
    @chars = qw/A B C D E F G H I J K L M N O P Q R S T U V W X Y Z a b c d
		e f g h i j k l m n o p q r s t u v w x y z 0 1 2 3 4 5 6 7
		8 9 ! @ $ % ^ & * ( ) ' " ; : [ ] { } | = + . < > ?/;
  my
    $password = '';
  foreach my $i(1..$length)
  {
    my
      $rand = int(rand($#chars));
    $password .= $chars[$rand];
  }
  return( $password );
}


=item B<<< get_recaptcha( $context ) >>>

Get HTML to display a captcha on a page.

=cut
# Get reCAPTCHA HTML
sub get_recaptcha
{
  my
    $c = shift;
  my
    $pubkey = config(qw/internet captcha recaptcha-public-key/);
  my
    $theme = config(qw/internet captcha recaptcha-theme/);
  my
    $captcha = Captcha::reCAPTCHA->new;
  my
    $captcha_text = '';
  $captcha_text .= $captcha->get_options_setter({theme=>$theme});
  $captcha_text .= $captcha->get_html($pubkey);
  return( $captcha_text );
}

=item B<<< validate_recaptcha( $context, $ip, $challenge, $response )
>>>

Return 0 if the reCAPTCHA response is valid, the error text otherwise.

=cut
# Validate reCAPTCHA response
sub validate_recaptcha
{
  my
    $c = shift;
  my
    $ip = shift;
  my
    $challenge = shift;
  my
    $response = shift;

  my
    $privkey = config(qw/internet captcha recaptcha-private-key/);
  my
    $captcha = Captcha::reCAPTCHA->new;
  my
    $result = $captcha->check_answer($privkey, $ip, $challenge, $response);
  if( $result->{is_valid} )
  {
    return( 0 );
  }
  else
  {
    return( $result->{error} );
  }
}

=item B<selected_language( $context [, $language] )>

Set the language explicitely selected by the user in the session if
$language is provided.

Return the currently selected language.

=cut
# Select user-selected language in session
sub selected_language
{
  my $c		= shift;
  my $language	= shift;

  my $default_language = 'en';

#Set multilingual here
  my $multilingual = 1;

  if ($multilingual)
  {
    $c->session->{mlanguage_type} = $language
      if $language;
  }
  else
  {
    $c->session->{mlanguage_type} = $default_language;
  }

  return( $c->session->{mlanguage_type});

}


=back

=head1 GENERAL UTILITIES

=over

=item B<arg( [$n], $name, @_ )>

Extract a given argument from the arguments passed to a method.
Arguments may be passed as a list, or as a hashref.  Assume that if
there's a single argument of ref HASH it's a hashref, otherwise it's a
list.

If $n is specified it specifies the n-eth argument in the list format.
n starts from 0.

Return the corresponding argument.

=cut
sub arg
{
  my
    $n = shift;
  my
    $name;
  if( $n =~ /^\d+$/ )
  {
    $name = shift;
  }
  else
  {
    $name = $n;
    undef($n);
  }
  my
    @remaining = @_;
  my
    $hashtype = 0;
  my
    %hash;
  if( $#remaining == 0 && ref($remaining[0]) eq 'HASH' )
  {
    $hashtype = 1;
    %hash = %{$remaining[0]};
  }
  if( $hashtype )
  {
    return( $hash{$name} );
  }
  else
  {
    return( defined($n) ?$remaining[$n] :undef );
  }
}


=head1 Input/Output functions

=head2  makeparm () Private

Generic function for accepting @_ from a request like
/class/method/par1=foo/par2=bar  and change it into a hashref like ->
{par1} = 'foo', etc.

=cut

sub makeparm
{
  my $hashref = {};
  foreach (@_)
  {
    my ( $par, $value ) = split( /=/, $_, 2 );
    $hashref->{$par} = $value;
  }
return ($hashref);
}


=back

=head1 MISCELLANEOUS

=over

=item B<maphash($hash)>

Return a string containing the sorted key/values of $hash.  $hash may
be a hash or a hashref.

=cut
# Stringify hash
sub maphash
{
  my
    %hash = ref($_[0]) ? %{$_[0]} :@_;
  map{$hash{$_}='<undef>' if !defined($hash{$_})} keys(%hash); 
  return(join(', ', map{sprintf "{%s=>'%s'}", 
			  $_, $hash{$_}}sort(keys(%hash))) );
}



=item B<<< myname >>>

Return the current module and function name as a string

=cut
# Get module and function name
sub myname
{
  return( (caller(1))[3] );
}


=head1 Array Operartions

=item B<uniquearray($context,\@array)>

This Fn returns an array of unqiue values.

=cut

sub uniquearray 
{
  my $c     = shift;
  my $input = shift;
  my @unique;
  my $item;
  my %checkseen = ();
  foreach $item (@$input)
  {
    $checkseen{$item}++;

  }
  @unique = keys %checkseen;

  #  $c->log->debug("General/uniquearray @unique : $#unique");
return @unique;

}

=item B <commify ( @array||$var )>

Handles Variable or Array.

=cut

sub commify
{
  my $in	= shift;


  if(ref($in) eq 'ARRAY')
  {
    my $series = commify_series(@$in);
    return $series;

  }
  else
  {
    return $in;
  }



}

=item B<commify_series ( @array )>

Comify an array, Perl cookbook Page 113

=cut

sub commify_series
{
      ( @_ == 0 ) ? ''
    : ( @_ == 1 ) ? $_[0]
    : ( @_ == 2 ) ? join( " and ", @_ )
    :               join( ", ", @_[ 0 .. ( $#_ - 2 ) ], "$_[-2] and $_[-1]." );
}



=item B<sort_array($context,\@array,[$reverse_sort])>

This Fn returns an array Sorted .

=cut

sub sort_array 
{
  my $c       = shift;
  my $input   = shift;
  my $reverse = shift;
  my @sorted;

  $c->log->debug("General / sort_array :");

  if ($reverse)
  {
    @sorted = reverse sort { $a cmp $b } @$input;
  }
  else
  {
    @sorted = sort { $a cmp $b } @$input;
  }

return @sorted;

}


=item B<intersection($context,\@a,\@b)>

This Fn finds element which are in both arrays only.
Intersection of two arrays.

=cut

sub intersection 
{
  my $c     = shift;

  my $a     = shift;
  my $b     = shift;

  my (@one,@two) = ();

#  @one = @$a;
#  @two = @$b;

  foreach (@$a)
  {
    my $e = $_;
    $e = trim($c,$e);
    unshift(@one,$e);
#    $c->log->debug("intersect Addinging in A: @one");
  }
  foreach (@$b)
  {
    my $f = $_;
    $f = trim($c,$f);
    push(@two,$f);
#    $c->log->debug("intersect Adding in B: @two");
  }

  my @isect =();
  my %original = ();

  $c->log->debug("intersect A: @one");
  $c->log->debug("intersect B: @two");

  map {$original{$_} = 1}  @one;
  @isect = grep {$original{$_}} @two;

  $c->log->info("C/U/intersected : @isect ");
  return @isect;

}


=head2 aonly($context,\@a,\@b)

This Fn finds element which are in first array only.

Recipe from Perl Cookbook Pg-126,4.8,Finding element in only one
array but not another.Recipe 1


=cut

sub aonly
{
  my $c = shift;
  my $a = shift;
  my $b = shift;

  #  $c->log->info("General/aonly \@a :@$a");
  #  $c->log->info("General/aonly \@b :@$b");

  my %seen;

  @seen{@$a} = ();

  delete @seen{@$b};

  my @aonly = keys %seen;

  #  $c->log->debug("aonly \@aonly :@aonly");
return @aonly;

}


=item B<get_array_from_argument ($context,$args)>

$args: Arguments separated by comma.

Each Argument goes through unxss

=cut

sub get_array_from_argument
{

  my $c		= shift;
  my $input_arg	= shift;

  my $m="C/U/get_array_from_argument";
  my @t_input_arg;

  if (ref ($input_arg) )
  {
#    $c->log->debug("$m IS an ARRAY:$input_arg ");
    foreach my $color (@$input_arg)
    {
#      $c->log->debug("$m foreach:$color");
      $color = unxss($color);
      push(@t_input_arg,$color);
    }

  }
  else
  {
#    $c->log->debug("$m IS NOT an ARRAY: $input_arg");
    $input_arg = unxss($input_arg);
    push(@t_input_arg,$input_arg);
  }

#  $c->log->debug("$m output ARR:@t_input_arg");

  return @t_input_arg;

}


=item B<get_keyval_from_arrayofhash($c,$key,\@arr_of_hash)

Return array of values for key.

=cut

sub get_keyval_from_arrayofhash
{
  my $c			= shift;
  my $key		= shift;
  my $arr_of_hash	= shift;

  my $f = "U/get_keyval_from_arrayofhash";

  my @list;

  foreach my $i (@$arr_of_hash)
  {
    my $val = $i->{$key};
    $c->log->debug("$f VAL($key):$val");
    push (@list,$val);
  }

  $c->log->debug("$f LIST: @list");
  return @list;

}

=head2 get_keyval_from_aparams($c, $aparams, $string)

$aparams is $c->request->parameters;
$string is the string with multiple values in array.

Catalyst parameters suck and hack to handle
http://bulknews.typepad.com/blog/2009/12/perl-why-parameters-sucks-and-what-we-can-do.html


$query might become ARRAY(0xabcdef) if there are multiple query=
parameters in the query.

@names line might cause Can't use string as an ARRAY ref error if
there's only one (or zero) name parameter. This causes horrible
issues when using standard HTML elements like option
or checkbox forms, or tools like jQuery's serialize().


=cut

sub get_values_from_akey_from_aparams
{
  my $c		= shift;
  my $v		= shift;
  my $string	= shift;

  my $f="get_values_from_akey_from_aparams";

  my @list = ref $v->{$string} eq 'ARRAY' ? @{$v->{$string}} : ($v->{$string});
  $c->log->info("$f List: @list");

  return @list;

}


=head2 trim($context,@string)

This Fn removes the trailing or leading whitespace from a string.
Input is a string or an array.
PErl cookbook Recipe 1.19,Pg-43

=cut

sub trim 
{
  my $c   = shift;
  my @out = shift;

  for (@out)
  {
    s/^\s+//;			#trim left
    s/\s+$//;			#trim right
  }

  return @out == 1
    ? $out[0]			#only one to return
      : @out;			# or many

}

=head1 CONFIGURATION

These methods let you access application configuration values easily.

=over

=item B<config($par1, $par2, ...)>

Get the configuration item corresponding to
config->{$par1}->{$par2}->...

Returns whatever the type of the configuration value is.

=cut
sub config
{
  my
    $val = cashregister->config;
  foreach my $p( @_ )
  {
    $val = $val->{$p};
  }
  return( $val );
}



=back

=cut

1;
