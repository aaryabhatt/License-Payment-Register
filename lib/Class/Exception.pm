#!/usr/bin/perl -w
#
# Class/Exception.pm
#
#created on 2014-07-18
#Tirveni Yadav
#


use strict;
use warnings;

our $VERSION = "1.00";

=head1 Exception

=cut

package Class::Exception;

#import Class Utils functions
use Class::Utils qw(makeparm selected_language unxss trim commify_series
		  get_array_from_argument get_keyval_from_arrayofhash
		  intersection sort_array today now);



=head2 new ($context,id,reverseofdomain)

Create Exception Object

=cut

sub new
{
  my $proto       = shift;
  my $context     = shift;
  my $arg_exceptionid	  = shift;
  my $type  = shift;

  #Class
  my $class = ref($proto) || $proto;
  my %selfh;
  my $self = \%selfh;

  $context->log->debug("C/Exception/new");

  #
  # What did we get?
  my $row;

  if(ref($arg_exceptionid) )
  {
   $row = $arg_exceptionid;
  }
  elsif ( $arg_exceptionid  )
  {
    $row = $context->model('cashregister::Exception')->find
      (
       {
	ip		=> $arg_exceptionid,
       }
      );
  }

  $context->log->info("C/Exception/new ROW ");
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

=head2 nameofdomain

Get nameofdomain of the Serverinuse

=cut

sub nameofdomain
{
  my $self = shift;

  return( $self->dbrecord->get_column('nameofdomain') );
}

=head2 date

Get date of the Serverinuse

=cut

sub date
{
  my $self = shift;

  return( $self->dbrecord->get_column('date') );
}

=head2 exceptionid

Get exceptionid of the Serverinuse

=cut

sub exceptionid
{
  my $self = shift;

  return( $self->dbrecord->get_column('exceptionid') );
}

 

=head2 customerid

Get customerid of the Serverinuse

=cut

sub customerid
{
  my $self = shift;

  return( $self->dbrecord->get_column('customerid') );
}

 


=head2 valuechange

Get valuechange of the Serverinuse

=cut

sub valuechange
{
  my $self = shift;

  return( $self->dbrecord->get_column('valuechange') );
}

 

=head2 comments

Get comments of the Serverinuse

=cut

sub comments
{
  my $self = shift;

  return( $self->dbrecord->get_column('comments') );
}


=head2 typeid

Get typeid of the Exception

=cut

sub typeid
{
  my $self = shift;

  return( $self->dbrecord->get_column('typeid') );
}

=head2 type_name

Get type_name of the Exception

=cut

sub type_name
{
  my $self = shift;
  
  my $row = $self->dbrecord->typeid;

  return( $row->get_column('description') );
}


=head2 userid

Get userid of the Exception

=cut

sub userid
{
  my $self = shift;

  return( $self->dbrecord->get_column('userid') );
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

=head2 val_old

Get's the old Value.

=cut

sub val_old
{
  my $self = shift;

  my $old1= $self->dbrecord->get_column('ofield1');

  my $value = $old1 ;

  return $value;

}

=head2 val_old2

Get's the old Value.

=cut

sub val_old2
{
  my $self = shift;

  my $old2= $self->dbrecord->get_column('ofield2');
  my $old3= $self->dbrecord->get_column('ofield3');
  my $old4= $self->dbrecord->get_column('ofield4');
  my $old5= $self->dbrecord->get_column('ofield5');

  my $value =  $old2 || $old3 || $old4 || $old5;

  return $value;

}

=head2 val_new

Get's the new Value.

=cut

sub val_new
{
  my $self = shift;

  my $new1= $self->dbrecord->get_column('nfield1');

  my $value = $new1 ;

  return $value;

}

=head2 val_new2

Get's the new Value.

=cut

sub val_new2
{
  my $self = shift;

  my $new2= $self->dbrecord->get_column('nfield2');
  my $new3= $self->dbrecord->get_column('nfield3');
  my $new4= $self->dbrecord->get_column('nfield4');
  my $new5= $self->dbrecord->get_column('nfield5');

  my $value = $new2 || $new3 || $new4 || $new5;

  return $value;

}


=head2 create( $context, \%attribs )

Create a new record in the exception table.

The %attribs are used to fill out the record.  This is the generic
method which is called by each specific exception type method to log
an exception.

Returns the Class::Exception object for the new record.

=cut

sub create
{
  my
    $class = shift;             # Ignore it
  my
    $context = shift;
  my
    $attribs = shift;
  # create a new exception record.
  $attribs->{date} = today.' '.now
    unless $attribs->{date};

  $attribs->{userid} = $context->user->get('userid')
    unless $attribs->{userid};

  my
    $exceptionrec = $context->model('cashregister::Exception')
      ->create($attribs);
  my
    $exception = Class::Exception->new($context, $exceptionrec);
  return( $exception );
}

=head2 server_log($c,$exception_type,$ip,change_type,$old,$new)

Add An Exception for Domain

=cut

sub server_log
{
  my $c			= shift;
  my $e_type		= shift;
  my $ip		= shift;
  my $change_type	= shift;
  my $old_val		= shift;
  my $new_val		= shift;

  my $attribs;
  $attribs->{ip}		= $ip;
  $attribs->{typeid}		= $e_type;
  $attribs->{valuechange}	= $change_type;

  $attribs->{ofield1}	= $old_val;
  $attribs->{nfield1}	= $new_val;

  return( Class::Exception->create($c, $attribs) );


}


=head2 server_log_add($c,$exception_type,$ip,change_type,$new)

Add An Exception for Server

=cut

sub server_log_add
{
  my $c			= shift;
  my $e_type		= shift;
  my $ip		= shift;
  my $change		= shift;
  my $new_val1		= shift;
  my $new_val2		= shift;
  my $new_val3		= shift;

  my $attribs;
  $attribs->{typeid}		= $e_type;
  $attribs->{ip}		= $ip;
  $attribs->{valuechange}	= $change || 'ADD';
  $attribs->{nfield1}		= $new_val1;
  $attribs->{nfield2}		= $new_val2;

  return( Class::Exception->create($c, $attribs) );


}


=head2 domain_log($c,$exception_type,$name_domain,change_type,$old,$new)

Add An Exception for Domain

=cut

sub domain_log
{
  my $c			= shift;
  my $e_type		= shift;
  my $nameofdomain	= shift;
  my $change_type	= shift;
  my $old_val		= shift;
  my $new_val		= shift;

  my $attribs;
  $attribs->{nameofdomain}	= $nameofdomain;
  $attribs->{reverseofdomain}	= reverse $nameofdomain;
  $attribs->{typeid}		= $e_type;
  $attribs->{valuechange}	= $change_type;

  $attribs->{ofield1}	= $old_val;
  $attribs->{nfield1}	= $new_val;

  return( Class::Exception->create($c, $attribs) );


}


=head2 domain_log_add($c,$exception_type,$name_domain,change_type,$new)

Add An Exception for Domain

=cut

sub domain_log_add
{
  my $c			= shift;
  my $e_type		= shift;
  my $nameofdomain	= shift;
  my $new_val1		= shift;
  my $new_val2		= shift;

  my $attribs;
  $attribs->{reverseofdomain}	= reverse $nameofdomain;
  $attribs->{valuechange}	= 'ADD';

  $attribs->{typeid}		= $e_type;
  $attribs->{nameofdomain}	= $nameofdomain;
  $attribs->{nfield1}		= $new_val1;
  $attribs->{nfield2}		= $new_val2;

  return( Class::Exception->create($c, $attribs) );


}


=head2 domain_log_del($c,$exception_type,$name_domain,change_type,$old)

Add An Exception for Domain

=cut

sub domain_log_del
{
  my $c			= shift;
  my $e_type		= shift;
  my $nameofdomain	= shift;
  my $old_val		= shift;
  my $old_val2		= shift;

  my $attribs;
  $attribs->{nameofdomain}	= $nameofdomain;
  $attribs->{reverseofdomain}	= reverse $nameofdomain;
  $attribs->{typeid}		= $e_type;
  $attribs->{valuechange}	= 'DEL';
  $attribs->{ofield1}		= $old_val;
  $attribs->{ofield2}		= $old_val2;

  return( Class::Exception->create($c, $attribs) );


}

=head2 server_log_del($c,$exception_type,$ip,change_type,$old)

Add An Exception for Server

=cut

sub server_log_del
{
  my $c			= shift;
  my $e_type		= shift;
  my $ip		= shift;
  my $old_val		= shift;
  my $old_val2		= shift;

  my $attribs;
  $attribs->{ip}		= $ip;
  $attribs->{typeid}		= $e_type;
  $attribs->{valuechange}	= 'DEL';
  $attribs->{ofield1}		= $old_val;
  $attribs->{ofield2}		= $old_val2;

  return( Class::Exception->create($c, $attribs) );


}


=cut

=back

=cut

1;
