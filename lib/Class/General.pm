#!/usr/bin/perl -w
#
# Class/General
#
# Utility methods for cashregister DB abstraction classes.
#
#
use strict;

package Class::General;

use List::Util qw(min max sum);
use Class::Utils qw(makeparm selected_language unxss commify_series trim);

#
# Required for testing only

use vars qw(@ISA @EXPORT_OK);
require Exporter;

@ISA        = qw/Exporter/;
@EXPORT_OK  = qw/
		 txn_do validate_job_access
		 config
		 paginationx get_themes get_regions get_seasons
		 get_fields_from_argument get_preferencestype
		/;

=pod

=head1 DATABASE UTILITIES

=over

=item B<txn_do( $coderef, $context )>

Call the code in $coderef in a database transaction.  $context is
needed to get the schema.

=cut
# Do code in a transaction
sub txn_do
{
  my
    $code = shift;
  my
    $context = shift;

  return( $context->model('cashregister')->schema->txn_do($code) );
}


=item B<<< validate_job_access( $context [, $action] ) >>>

Validate access to the given $action, which is presumed to be a cron
task.  Validate access to any job action if $action is not specified.

Return true if access is permitted, under otherwise.

Note: Currently ignores $action.

=cut
# Validate access to cron job action
sub validate_job_access
{
  my
    $c = shift;
  my
    $action = shift;
  my
    $allowed = undef;
  #
  # Check for IP address
  my
    $allowed_ips = config(qw/internet cron allowed-ips/);
  my
    $client_ip = $c->req->address;
  foreach my $i( @$allowed_ips )
  {
    $allowed = 1
      if $client_ip eq $i;
  }
  #
  # That's it for now
  return( $allowed );
}


=item B<<< get_fields_from_class_name( $context, $class_name ) >>>

Return array of database fields for a table belonging to class
$class_name (Class::Foo).

=cut
# Get field names
sub get_fields_from_class_name
{
  my
    $c = shift;
  my
    $table = shift;
  $table =~ s/.*Class:://;
  $table =~ s/^(.)(.*)/\U$1\L$2/;
  my
    @columns = $c->model("cashregister::$table")->result_source
      ->columns;
  return( @columns );
}


=back

=head1 CONFIGURATION

These methods let you access application configuration values easily.

=over

=back

=head2 paginationx ($c ,$search_attribs , $rs_table)

Handles  Pagination.With Multiple Search Parameters.

If hashindisplay is given then create display string from that else
used hashinsearch.

=cut

sub paginationx
{
  my $c        = shift;
  my $attribs  = shift;
  my $rs_table = shift;

  my $fn = "G/paginationx:";

  my $desired_page   = $attribs->{desiredpage};
  my $startpage      = $attribs->{startpage} ;
  my $listname       = $attribs->{listname};
  my $namefn         = $attribs->{namefn};
  my $nameclass      = $attribs->{nameclass};
  my $input_search   = $attribs->{inputsearch};
  my @order          = $attribs->{order};
  my $in_rowsperpage = $attribs->{rowsperpage};

  $c->log->debug("$fn START Fx A, SP:$startpage, DP:$desired_page");

  #This is the Difference, Hash of Search Keys And Values
  my $in_search_h    = $attribs->{hashinsearch};
  my $in_display_h   = $attribs->{hashindisplay};

  #Search String 
  my $search_string  = undef;

  #Display String
  my $display_string = undef;

#Do the Search String / Display String
#1. Search String is always there
  if ($in_search_h)
  {
    my $s_count;
    $c->log->debug("$fn Create Search and Display String");
    while ( ( my $key, my $value ) = each(%$in_search_h) )
    {
      $c->log->debug("$fn SEARCH HASH $key : $value");
      if ( $key && $value )
      {
	$s_count++;
	my $str = "$key=$value";
	if ( $s_count != 1 )
	{
	  $search_string   = "$search_string/" . $str;
	  $display_string  = "$display_string, " . $str;
	}
	else
	{
	  $search_string  = $str;
	  $display_string = $str;
	}
      }
    }
    $c->log->debug("$fn \$search_string  : $search_string");
  }

#2. Display String is there
  if ($in_display_h)
  {
    my @key_vals;
    $c->log->debug("$fn :Create Display String as required");
    $display_string = undef;

    while ( ( my $key, my $value ) = each(%$in_display_h) )
    {
      $c->log->debug("G/paginationx :DISPLAY HASH $key : $value");
      if ( $key && $value )
      {
	my $str = "$key: $value";
	push(@key_vals,$str);
      }
    }
    $display_string = commify_series(@key_vals);
    $c->log->debug("$fn \$display_string : $display_string");
  }

  $c->log->debug("$fn START Fx B, SP:$startpage, DP:$desired_page");
  $startpage = 1 unless defined($startpage);
  if ( defined($desired_page) )
  {
    $startpage--
      if $desired_page eq 'previous';
    $startpage++
      if $desired_page eq 'next';
    $startpage = 1
      if $startpage < 1;
  }

  $c->log->debug("$fn START Fx C, SP:$startpage, DP:$desired_page");


  my $rows_per_page;
  if ( !$in_rowsperpage )
  {
    $rows_per_page = 2;
    $rows_per_page = cashregister->config->{display}->{generic}->{lines_per_page}
      if cashregister->config->{display}->{generic}->{lines_per_page};
  }
  else
  {
    $rows_per_page = $in_rowsperpage;
  }

  $c->log->debug ("$fn RS input :  ".
		  " \@order : @order ;".
		  " Rows : $rows_per_page"
		 );

  my $rs_table_search ;

#Search : only if something has been found
  if ($rs_table)
  {
    $rs_table_search =  $rs_table->search
      (
       {},
       {
	order_by => [@order],
	rows     => $rows_per_page
       }
      );
  }

  my $allitems = $rs_table_search->search(@$input_search);
  my $max_count;

  my $items    = $allitems->page($startpage);
  my $itempage = $items->pager();

  if ( $startpage > $itempage->last_page() )
  {
    $startpage = $itempage->last_page();
    $items     = $allitems->page($startpage);
    $itempage  = $items->pager();
  }
  $max_count = $itempage->total_entries;

  my $itempage_entries_per_page = $itempage->entries_per_page();
  my $itempage_page = $itempage->current_page();
  my $itempage_start = $itempage_entries_per_page * ( $itempage_page - 1 ) + 1;
  my $itempage_end = $itempage_start + $itempage->entries_on_this_page() - 1;
  my $itempage_total = $max_count;

  $c->log->debug("$fn \$itempage_entries_per_page: " .
		 " $itempage_entries_per_page" );
  $c->log->debug("$fn \$itempage_page:  $itempage_page");
  $c->log->debug("$fn \$itempage_start  $itempage_start");
  $c->log->debug("$fn \$itempage_end:   $itempage_end");
  $c->log->debug("$fn \$itempage_total: $itempage_total");
  $c->log->debug("$fn \$search_string:  $search_string");

  $c->stash->{listpage} =
    {
     start         => $itempage_start,
     end           => $itempage_end,
     total         => $itempage_total,
     page          => $itempage_page,
     listname      => $listname,
     namefn        => $namefn,
     nameclass     => $nameclass,
     searchstring  => $search_string,
     displaystring => $display_string,
    };

  return $items;

}



=head2 get_langauges ($context [, $selected  ])

Get Languagess from Table Languages

=cut

sub get_languages
{
  my $c                 = shift;
  my $in_selected       = shift;

  my $f = "C/G/get_languages";

  $in_selected = $in_selected;
  $c->log->debug("$f Start SELECTED: $in_selected");
  my @list;

  my @order = ('languagecode');
  my $languages_rs = $c->model('cashregister::Languagetype')->search
    ({},
     {order_by=> @order,}
    );

  while ( my $language_row = $languages_rs->next )
  {

    my $languagecode    = $language_row->languagecode;
    my $description	= $language_row->description;

    my ($selected,$checked);
    if ( ref($in_selected) eq 'ARRAY')
    {
      $c->log->debug("$f Selected Array. checkbox");
      foreach my $ln( @$in_selected )
      {
	if ($ln eq $languagecode)
        {
	  $checked = 'CHECKED';
	  $c->log->debug("$f ARR. check $ln - $languagecode, $selected");
	}
      }
    }
    elsif ($in_selected && ($languagecode eq $in_selected) )
    {
      $c->log->debug("$f Code IN:$in_selected,CODE:$languagecode");
      $selected='SELECTED';
    }

    push(@list,
         {
          languagecode     => $languagecode,
          description      => $description,
	  selected	   => $selected,
	  checked	   => $checked,
         }
        );

  }

  return @list;

}




=head2 get_currency ($context [, $selected  ])

Get Currencys from Table Currency

=cut

sub get_currency
{
  my $c                 = shift;
  my $in_selected       = shift;

  my $f = "C/G/get_currency";

  $in_selected = unxss($in_selected);
  $c->log->debug("$f Start SELECTED:$in_selected");
  my @list;

  my @order = ('currencycode');
  my $currency_rs = $c->model('cashregister::Currency')->search
    ({},
     {order_by=> @order,}
    );

  while ( my $currency_row = $currency_rs->next )
  {

    my $currencycode    = $currency_row->currencycode;
    my $currencyname	= $currency_row->currencyname;

    my $selected;
    if ($currencycode eq $in_selected)
    {
      $c->log->debug("$f Start IN:$in_selected,CODE:$currencycode");
      $selected='SELECTED';
    }

    push(@list,
         {
          currencycode     => $currencycode,
          currencyname      => $currencyname,
	  selected	   => $selected,
         }
        );

  }

  return @list;

}

=head2 get_time_zone ($context [, $selected  ])

Get Currencys from Table Time_zone

=cut

#sub get_time_zone
#{
#  my $c                 = shift;
#  my $in_selected       = shift;
#
#  my $f = "C/G/get_time_zone";
#
#  $in_selected = $in_selected;
#  $c->log->debug("$f Start SELECTED:$in_selected");
#  my @list;
#
#  my @order = ('name');
#  my $time_zone_rs = $c->model('cashregister::TimeZoneName')->search
#    ({},
#     {order_by=> @order,}
#    );
#
#  while ( my $time_zone_row = $time_zone_rs->next )
#  {
#
#    my $time_zone_id    = $time_zone_row->time_zone_id;
#    my $time_name  = $time_zone_row->name;
#
#    my $selected;
#    if ($time_zone_id eq $in_selected)
#    {
#      $c->log->debug("$f Start IN:$in_selected,CODE:$time_zone_id");
#      $selected='SELECTED';
#    }
#
#    push(@list,
#         {
#          time_zone_id     => $time_zone_id,
#          time_name      => $time_name,
#	  selected	   => $selected,
#         }
#        );
#
#  }
#
#  return @list;
#
#}
#



=over

=back


=cut

1;
