#!/usr/bin/perl -w
#
# Autoload fields from self and parent classes.  This should be
# inherited by all Class::* classes.
#
#
use strict;

=pod

=head1 NAME

Autoload: Automagically loaded methods for Class::* database
abstraction objects.

=head1 SYNOPSIS

    use Class::Foo;
    $c = Class::Foo->search_date(...), etc.

See METHODS for list of methods available for this object.

=head1 METHODS

=over

=cut

our $AUTOLOAD;
sub AUTOLOAD
{
  my
    $self = shift;
  my
    @args = @_;
  my
    $name = $AUTOLOAD;
  $name =~ s/.*://;
  my
    $table = __PACKAGE__;
  $table =~ s/.*://;
  #print STDERR "Type: $type, Caller: ".caller().", Package: ".__PACKAGE__."\n";

#
# Do a search on date ignoring time portion.  Put this first, since it
# will NOT be called on a class object.
#
  if( $name eq 'search_date' )
  {
    my
      $context = shift(@args);
    my
      $pars = shift( @args );
    my
      @date_fields = $self->date_fields;
    #$context->log->debug("DATE FIELDS: @date_fields");
    use Class::Utils;
    #
    # Check if one or more of the date fields in the table are
    # requested in the query.
    foreach my $d( @date_fields )
    {
      #
      # Convert datefield=>'YYYY-MM-DD HH:MM:SS' to: between
      # 'YYYY-MM-DD' and 'YYYY-MM-(DD+1)', similarly for date ranges.
      if( exists($pars->{$d}) )
      {
	$pars->{$d} = Class::Utils::date_search_hashref($pars->{$d});
	#$context->log->debug("DATES: $d, $date1, $date2");
      }
    }
    #
    # Get the schema
    my
      $schema = $table;
    $schema =~ s/(.)(.*)/\U$1\L$2/; # Capitalise it
    $schema = $context->model("cashregister::$schema");
    #
    # Do the search and return results
    return( $schema->search($pars, @args) );
  }
  #
  # Return unless this is a class.
  my
    $type = ref( $self );
  return( undef )
    if !$type || $name eq 'DESTROY';
  my
    $ret;

=item B<logdebug( $str... )>

=item B<loginfo( $str...)>

=item B<logerror( $str...)>

Invoke the corresponding Catalyst log method with the given arguments.

=cut
#
# Log services
  if( $name =~ /^log(debug|info|error)/ )
  {
    return( $self->{context}->log->$1(@args) );
  }

=item B<$class_field( [$value] )>

Set the value of the given class field if $value is given.

Return the (new) value of the class field.

=cut
  # Check if it's a member of the class.
  if( exists($self->{$name}) )
  {
    $self->{$name} = $args[0]
      if @args;
    return( $self->{$name} );
  }

=item B<update>

Check if the underlying database record is dirty (has unwritten
updates) and update it in the database if it is.

=cut
  # Check in this table
  my
    $dbrecord = lc($table).'_dbrecord';
#
# Update the database record if it's dirty
  if( $name eq 'update' )
  {
    if ( $self->{$dbrecord}->is_changed )
    {
      return( $self->{$dbrecord}->update(@args) );
    }
    else
    {
      return( 0 );
    }
  }

=item B<delete>

Delete the current record from the database.

=cut
  if( $name eq 'delete' )
  {
    return( $self->{$dbrecord}->delete );
  }

=item B<$db_field( [$value] )>

Set the value of the given $db_field in the underlying table if $value is
provided.  Return the (new) value of the database field $db_field.

This method will only update the in-memory copy of the database field.
Use B<update> to write the value to the database after setting the
value(s) of one or more database fields.

=cut
#
# Handle a field in the database table
  if( $self->{$dbrecord}->result_source->has_column($name) )
  {
    $self->{$dbrecord}->set_column($name, @args)
      if @args;
    return( $self->{$dbrecord}->get_column($name) );
  }
  else
  {
    # Check in parents
    my
      $parent_class_name = $self->{lazy_fields}->{$name};
    if( $parent_class_name )
    {
      # Instantiate it
      my
	@keyvals;
      my
	@keys = eval $parent_class_name."::keys()";
      foreach my $k ( @keys )
      {
	push( @keyvals, $self->$k );
      }
      my
	$parent = $parent_class_name->new( $self->context, @keyvals );
      if( $parent )
      {
	$self->{parents}->{$parent_class_name} = $parent;
	return( $parent->$name );
      }
      else
      {
	return( undef );
      }
    }
    else
    {
      return( undef );
    }
#     # One of the parents must have it.  Let Perl handle it.
#     my
#       $died;
#     foreach my $p ( @ISA )
#     {
# #print STDERR "PARENT: $p, name: $name\n";
# #      next
# #	if $p =~ /Autoload/;
# #print STDERR "SELF: ",ref($self),"\n";
# #print STDERR "PARENT2: $p, name: $name\n";
#       eval
#       {
# 	$ret = eval '$self->'.$p.'::'.$name.'(@args)';
# 	$died = $@;
#       };
#       return( $ret )
# 	unless $died;
#     }
#     die $died || "Method $name not found in $type";
  }
}

=back

=end

=cut

1;
