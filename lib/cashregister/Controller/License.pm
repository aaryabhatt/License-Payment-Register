package cashregister::Controller::License;
use Class::Utils qw(makeparm selected_language unxss  commify
                    commify_series trim config today now config maphash display_error);

use Moose;
use namespace::autoclean;
use cashregister::Schema;
use Data::Dumper;


BEGIN {extends 'Catalyst::Controller'; }

=head1 NAME

cashregister::Controller::License - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 add 
to add a license 

=cut

#sub index :Path :Args(0) {
#    my ( $self, $c ) = @_;

#    $c->response->body('Matched cashregister::Controller::License in License.');
#}


sub add :Path(/license/add) {
    my ( $self, $c ) = @_;
    my $pars    = makeparm(@_);
    my $aparams = $c->request->params;

$c->stash->{page} = {'title' => 'Add A New License',};
         $c->stash->{template} = 'src/License/Add.tt';


        my ($l_li_number, $l_li_type, $l_lih_name, $l_lih_relative, $l_lih_city, $l_lih_country, $l_lih_mobile, $l_li_category, $l_li_startdate);
        my ($l_li_enddate, $l_lih_address, $l_lih_state, $l_lih_phone, $l_lih_email);
                $l_li_number                = $pars->{li_number}      		||$aparams->{li_number}      	||undef;
                $l_li_type        	    = $pars->{li_type}         		||$aparams->{li_type}      	||undef;
                $l_lih_name        	    = $pars->{lih_name}         	||$aparams->{lih_name}      	||undef;
                $l_lih_relative        	    = $pars->{lih_relative}         	||$aparams->{lih_relative}      ||undef;
                $l_lih_city        	    = $pars->{lih_city}        		||$aparams->{lih_city}      	||undef;
                $l_lih_country        	    = $pars->{lih_country}         	||$aparams->{lih_country}       ||undef;
                $l_lih_mobile        	    = $pars->{lih_mobile}         	||$aparams->{lih_mobile}      	||undef;
                $l_li_category        	    = $pars->{li_category}         	||$aparams->{li_category}      	||undef;
                $l_li_startdate        	    = $pars->{li_startdate}         	||$aparams->{li_startdate}      ||undef;
                $l_li_enddate        	    = $pars->{li_enddate}         	||$aparams->{li_enddate}      	||undef;
                $l_lih_address        	    = $pars->{lih_address}         	||$aparams->{lih_address}      	||undef;
                $l_lih_state        	    = $pars->{lih_state}         	||$aparams->{lih_state}      	||undef;
                $l_lih_phone        	    = $pars->{lih_phone}         	||$aparams->{lih_phone}      	||undef;
                $l_lih_email        	    = $pars->{lih_email}         	||$aparams->{lih_email}      	||undef;


	my ($lx_li_number, $lx_li_type, $lx_lih_name, $lx_lih_relative, $lx_lih_city, $lx_lih_country, $lx_lih_mobile, $lx_li_category);
        my ($lx_li_enddate, $lx_lih_address, $lx_lih_state, $lx_lih_phone, $lx_lih_email, $lx_li_startdate);


	       	$lx_li_number		=	$l_li_number;
		$lx_li_type		=	unxss($l_li_type);
		$lx_lih_name		=	unxss($l_lih_name);
		$lx_lih_relative	=	unxss($l_lih_relative);
		$lx_lih_city		=	unxss($l_lih_city);
		$lx_lih_country		=	unxss($l_lih_country);
		$lx_lih_mobile		=	unxss($l_lih_mobile);
		$lx_li_category		=	unxss($l_li_category);
		$lx_li_startdate	=	unxss($l_li_startdate);
		$lx_li_enddate		=	unxss($l_li_enddate);
		$lx_lih_address		=	unxss($l_lih_address);
		$lx_lih_state		=	unxss($l_lih_state);
		$lx_lih_phone		=	unxss($l_lih_phone);
		$lx_lih_email		=	unxss($l_lih_email);

$c->log->debug("All the varible values in adding a license:$lx_li_number, $lx_li_type, $lx_lih_name, $lx_lih_relative,$lx_lih_city,$lx_lih_country,$lx_lih_mobile,  $lx_li_category, $lx_li_startdate, $lx_li_enddate, $lx_lih_address, $lx_lih_state, $lx_lih_phone, $lx_lih_email");


####### this is to print categoryname in add and modify License  
#Drop Down of category.
		 my ($categoryname, $in_selected);
		 my @list;

		  my $category_rs = $c->model('cashregister::LicenseCategory')->search();

		  while ( my $category_row = $category_rs->next )
		  {

		     $categoryname    = $category_row->categoryname;

		    my $selected;
#    if (my  $catergoryname eq $in_selected)
#    {
		      $c->log->debug("List of categoryname :$categoryname");


		    push (@list, $categoryname);
	  	}


	$c->log->debug("Print the list array: @list" ); 

#	my @list_cat = @list;
#	return @list;
	$c->stash->{list_category} = \@list;

#####this section will do the transaction to add a new license in database and its address, if the transaction fails it will roll back
####reference link is http://www.catalystframework.org/calendar/2009/15

	if ($lx_li_number ne "" && $lx_li_category ne "" )
                {

#### fetch category id from database by variable passed to form from $lx_li_category =       unxss($l_li_category);
		my $form_category_row = $c->model('cashregister::LicenseCategory')->find({categoryname => $lx_li_category});
		my $form_cate_id      = $form_category_row->categoryid;
		$c->log->debug(" Print the value of category ID = $form_cate_id");

	$c->model('cashregister')->txn_do(sub {
		my $rs_li_li =  $c->model('cashregister::License')->create
                        ({
                        categoryid                    =>	$form_cate_id,
			license_no			=> 	$lx_li_number,
			license_type			=>	$lx_li_type,
			validity_start			=>	$lx_li_startdate,
			validity_end			=>	$lx_li_enddate,
                        }) ;


		my $rs_li_holder =  $c->model('cashregister::LicenseHolder')->create
                        ({
                        license_no                      =>      $lx_li_number,
			name				=>	$lx_lih_name,
			relativename			=>	$lx_lih_relative
                        }) ;

		my $rs_li_add =  $c->model('cashregister::Address')->create
                        ({
                        license_no                      =>      $lx_li_number,
			address				=>	$lx_lih_address,
			city				=>	$lx_lih_city,
			state				=>	$lx_lih_state,
			country				=>	$lx_lih_country,
			phone				=>	$lx_lih_phone,
			mobile				=>	$lx_lih_mobile,
			email				=>	$lx_lih_email
                        }) ;



		});

                        $c->res->redirect( "/license/list" );
#                        return $rs_li_li, $rs_li_holder, $rs_li_add;
		}
}



=head3 list Licenses
this section will list the Licenses on page wise

=cut

sub list :Path('/license/list')
{

  my $self              = shift;
  my $c                 = shift;

  my $fn_name           ;#= shift;
  my $startpage         = shift;
  my $desired_page      = shift || 1 ;

  my $f = "License/list";
  $c->log->debug("$f spage:$fn_name, StartPage: $startpage,".
                 " desired_page:$desired_page");

 my $rows_per_page = 10;
#  my @order_list = ('categoryname','categorydescription');
  my @order_list = ('licenseid');

  my %page_attribs;
  my $user_searchterm = $c->session->{'TripSearchTerm'};
  %page_attribs =
	(
	desiredpage  => $desired_page,
    	startpage    => $startpage,
	rowsperpage  => $rows_per_page,
     	inputsearch  => $user_searchterm,
     	order        => \@order_list,
     	listname     => 'Licenses',
     	namefn       => 'list',
#     nameclass    => 'category',
     	nameclass    => 'license'
    );

my $table_licenses = $c->model('cashregister::License')->search() ;
 my $rs_licenses = Class::General::paginationx
    ( $c, \%page_attribs,$table_licenses );

 my @list;
  while ( my $license = $rs_licenses->next() )
  {
####### This section is to remove time from date printing in list view
	my $v_start_datexx	=	$license->validity_start;
	my @v_start_date_a	= 	split(/T/, $v_start_datexx);
	my $v_start_date	= 	$v_start_date_a[0];	
	my $v_end_datexx	=	$license->validity_end;
	my @v_end_date_a	=	split(/T/, $v_end_datexx);
	my $v_end_date		=	$v_end_date_a[0];
	$c->log->debug(" Print start and end Date Values : $v_start_datexx, and $v_end_datexx"); 
### below two lines calling the hash ref of catgoryid 	
	my $find_cat_name    = $license->categoryid;
#### will fetch the name for categoryid by find it calling directly hash ref. and will push it @list array.
	my $rs_find_cat_name = $c->model('cashregister::LicenseCategory')->find({categoryid => $find_cat_name->categoryid });
	my $cat_name 	     = $rs_find_cat_name->categoryname;
#	$c->log->debug("Print the find_cat_name variable value : $find_cat_name");
  push
      (@list,
       {
        licenseid         	=> $license->licenseid,
        license_no            	=> $license->license_no,
        license_type    	=> $license->license_type,
	validity_start   	=> $v_start_date,
	validity_end	 	=> $v_end_date,
	entry_date	 	=> $license->entry_date,
	categoryname		=> $cat_name
       }
      );
	
	
  }

  $c->stash->{licenses} = \@list;
  $c->stash->{page} = {'title' => 'All Licenses' };
  $c->stash->{template} = 'src/License/list.tt';


}


=head4 modify

Modify Licenses.

=cut

sub modify :Path('/license/modify')
{

  my ($self, $c, $license_no) = @_;

  my $fn = "License/modify";
  my $pars      = makeparm(@_);
  my $aparams   = $c->request->params;
  $c->stash->{page} = {'title' => 'Modify License' };
  $c->stash->{template} = 'src/License/Modify.tt';


###### We used below code to pass reserved character in url with template toolkit
###### eg. <td> <a href="[% c.uri_for('/license/modify/')  %][% a.license_no | uri | url | trim %]">Modify</a> </td>
###### it will pass / @ etc and remove trailing and leading edge white spaces.
#  $c->log->debug("$license_no, License id value");
  my ($lf_categoryid, $lf_license_no, $lf_license_type, $lf_validity_start, $lf_validity_end);
  my ($lf_name, $lf_relativename, $lf_address, $lf_city, $lf_state, $lf_country, $lf_phone, $lf_mobile, $lf_email);
  # this section is to fetch the information from database by license_no, find always return a single row and search return a multiple rows.
  # the name alpha and beta are the values name declared in template.
	$c->model('cashregister')->txn_do(sub {
                my $rs_lf_li =  $c->model('cashregister::License')->find({license_no => $license_no});
		
			$lf_categoryid		 = 	$rs_lf_li->categoryid;
			$lf_license_no 		 = 	$rs_lf_li->license_no;
			$lf_license_type 	 = 	$rs_lf_li->license_type;
		     my $lf_validity_startxxx	 = 	$rs_lf_li->validity_start;
		     my	$lf_validity_endxxx	 = 	$rs_lf_li->validity_end;
		
		     my @start_date 		 = 	split (/T/, $lf_validity_startxxx);
			$lf_validity_start       =      $start_date[0];
		     my @end_date 		 = 	split (/T/, $lf_validity_endxxx);
                        $lf_validity_end         =      $end_date[0];
####this will revert the category name by finding categoryid			
			my $lf_category_row = $c->model('cashregister::LicenseCategory')->find({categoryid => $lf_categoryid->categoryid});
			my $lf_cat_name      = $lf_category_row->categoryname;
			$c->log->debug(" Print the value of category ID = $lf_cat_name");
###################################################################################3

#Drop Down of category.
	                 my ($categoryname, $in_selected);
        	         my @list;

                	 my $category_rs = $c->model('cashregister::LicenseCategory')->search();

                  	while ( my $category_row = $category_rs->next )
                 		 {

                     			$categoryname    = $category_row->categoryname;

                   			 my $selected;
#    if (my  $catergoryname eq $in_selected)
#    {
                      			$c->log->debug("List of categoryname :$categoryname");
		                        push (@list, $categoryname);
		                  }


#        $c->log->debug("Print the list array: @list" );

#       my @list_cat = @list;
#       return @list;
       				 $c->stash->{list_category} = \@list;

####################################################################################################
		
		my $rs_lf_lh =  $c->model('cashregister::LicenseHolder')->find({license_no => $license_no,});
			$lf_name		 =	$rs_lf_lh->name;
			$lf_relativename	 =	$rs_lf_lh->relativename;
		
		my $rs_lf_la =  $c->model('cashregister::Address')->find({license_no => $license_no,});

			$lf_address		 =	$rs_lf_la->address;
			$lf_city		 =	$rs_lf_la->city;
			$lf_state		 =	$rs_lf_la->state;
			$lf_country		 =	$rs_lf_la->country;
			$lf_phone		 =	$rs_lf_la->phone;
			$lf_mobile		 =	$rs_lf_la->mobile;
			$lf_email		 =	$rs_lf_la->email;
		
			my $href;
			$href->{ categoryname } 	=	$lf_cat_name; 
			$c->stash->{ licn_exist }  = 	$href;
			$href->{ license_no} 	=	$lf_license_no;
			$c->stash->{lino}  =       $href;
			$href->{license_type } 	=	$lf_license_type;
			$c->stash->{lity}  =       $href;
			$href->{ validity_start } 	=	$lf_validity_start;
			$c->stash->{ vs_date }  =       $href;
			$href->{ validity_end } 	=	$lf_validity_end;
			$c->stash->{ vs_end }  =       $href;
#			$href->{ } 	=	$lf_cat_name;
#			$c->stash->{ }  =       $href;
			$href->{ name } 	=	$lf_name; 
			$c->stash->{lhn}  =       $href;
			$href->{ relativename } 	=	$lf_relativename;
			$c->stash->{ sds }  =       $href;
			$href->{ address } 	=	$lf_address;
			$c->stash->{ lhua }  =       $href;
			$href->{ city } 	=	$lf_city;
			$c->stash->{ lhucity }  =       $href;
			$href->{ state } 	=	$lf_state;
			$c->stash->{ lhus }  =       $href;
			$href->{ country } 	=	$lf_country;
			$c->stash->{ lhucountry }  =       $href;
			$href->{ phone } 	=	$lf_phone;
			$c->stash->{ lhup }  =       $href;
			$href->{ mobile } 	=	$lf_mobile;
			$c->stash->{ lhum }  =       $href;
			$href->{ email } 	=	$lf_email;
			$c->stash->{ lhue }  =       $href;
		
$c->log->debug("Print the database category name:$lf_validity_start and $lf_validity_end " );
		});

#####################################################################################################
################# Section Fetch value from database to form Completed Here ##########################
#####################################################################################################

############## Update Value section Starts Here ##########################
 my ($l_li_number, $l_li_type, $l_lih_name, $l_lih_relative, $l_lih_city, $l_lih_country, $l_lih_mobile, $l_li_category, $l_li_startdate);
        my ($l_li_enddate, $l_lih_address, $l_lih_state, $l_lih_phone, $l_lih_email);
                $l_li_number                = $pars->{li_number}                ||$aparams->{li_number}         ||undef;
                $l_li_type                  = $pars->{li_type}                  ||$aparams->{li_type}           ||undef;
                $l_lih_name                 = $pars->{lih_name}                 ||$aparams->{lih_name}          ||undef;
                $l_lih_relative             = $pars->{lih_relative}             ||$aparams->{lih_relative}      ||undef;
                $l_lih_city                 = $pars->{lih_city}                 ||$aparams->{lih_city}          ||undef;
                $l_lih_country              = $pars->{lih_country}              ||$aparams->{lih_country}       ||undef;
                $l_lih_mobile               = $pars->{lih_mobile}               ||$aparams->{lih_mobile}        ||undef;
                $l_li_category              = $pars->{li_category}              ||$aparams->{li_category}       ||undef;
                $l_li_startdate             = $pars->{li_startdate}             ||$aparams->{li_startdate}      ||undef;
                $l_li_enddate               = $pars->{li_enddate}               ||$aparams->{li_enddate}        ||undef;
                $l_lih_address              = $pars->{lih_address}              ||$aparams->{lih_address}       ||undef;
                $l_lih_state                = $pars->{lih_state}                ||$aparams->{lih_state}         ||undef;
                $l_lih_phone                = $pars->{lih_phone}                ||$aparams->{lih_phone}         ||undef;
                $l_lih_email                = $pars->{lih_email}                ||$aparams->{lih_email}         ||undef;


        my ($lx_li_number, $lx_li_type, $lx_lih_name, $lx_lih_relative, $lx_lih_city, $lx_lih_country, $lx_lih_mobile, $lx_li_category);
        my ($lx_li_enddate, $lx_lih_address, $lx_lih_state, $lx_lih_phone, $lx_lih_email, $lx_li_startdate);


                $lx_li_number           =       $l_li_number;
                $lx_li_type             =       unxss($l_li_type);
                $lx_lih_name            =       unxss($l_lih_name);
                $lx_lih_relative        =       unxss($l_lih_relative);
                $lx_lih_city            =       unxss($l_lih_city);
                $lx_lih_country         =       unxss($l_lih_country);
                $lx_lih_mobile          =       unxss($l_lih_mobile);
                $lx_li_category         =       unxss($l_li_category);
                $lx_li_startdate        =       unxss($l_li_startdate);
                $lx_li_enddate          =       unxss($l_li_enddate);
                $lx_lih_address         =       unxss($l_lih_address);
                $lx_lih_state           =       unxss($l_lih_state);
                $lx_lih_phone           =       unxss($l_lih_phone);

#####this section will do the transaction to add a new license in database and its address, if the transaction fails it will roll back
####reference link is http://www.catalystframework.org/calendar/2009/15

        if ($lx_li_number ne "" && $lx_li_category ne "" )
                {

#### fetch category id from database by variable passed to form from $lx_li_category =       unxss($l_li_category);
                my $form_category_row = $c->model('cashregister::LicenseCategory')->find({categoryname => $lx_li_category});
                my $form_cate_id      = $form_category_row->categoryid;
                $c->log->debug(" Print the value of category ID = $form_cate_id");

		
	$c->model('cashregister')->txn_do(sub {
		
		my $rs_li_li =  $c->model('cashregister::License')->find({ license_no => $license_no });
			$rs_li_li->update
                        ({
                        categoryid                      =>      $form_cate_id,
                        license_no                      =>      $lx_li_number,
                        license_type                    =>      $lx_li_type,
                        validity_start                  =>      $lx_li_startdate,
                        validity_end                    =>      $lx_li_enddate,
                        }) ;


		my $rs_li_holder =  $c->model('cashregister::LicenseHolder')->find({ license_no => $lx_li_number });
		$c->log->debug(" Print the varibale license no.: $rs_li_holder");
                        $rs_li_holder->update
			 ({
                        name                            =>      $lx_lih_name,
                        relativename                    =>      $lx_lih_relative
                        }) ;

                my $rs_li_add =  $c->model('cashregister::Address')->find({ license_no => $lx_li_number });
			$rs_li_add->update
                        ({
                        address                         =>      $lx_lih_address,
                        city                            =>      $lx_lih_city,
                        state                           =>      $lx_lih_state,
                        country                         =>      $lx_lih_country,
                        phone                           =>      $lx_lih_phone,
                        mobile                          =>      $lx_lih_mobile,
                        email                           =>      $lx_lih_email
                        }) ;

#		return $rs_li_li;

                });

                        $c->res->redirect( "/license/list" );

	}
}

=head4 search
Search a license and modify it.
=cut

sub search :Path(/license/search) {
        my ( $self, $c ) = @_;
        my $pars    = makeparm(@_);
        my $aparams = $c->request->params;

        $c->stash->{page} = {'title' => 'Search License',};
        $c->stash->{template} = 'src/License/modify_search.tt';

       my ($pls_categoryid, $pls_license_no, $pls_license_type, $pls_validity_startxxx, $pls_validity_endxxx);
        my ($pls_validity_end,$pls_validity_start);

#       my $pls_licenseno       =   $pars->{search_license}                ||$aparams->{search_license}         ||undef;
        my $pls_licenseno       =   $pars->{search_license}                ||$aparams->{search_license};
        my $pls_licensenoxx     =   $pls_licenseno ;

        $c->log->debug("Search for License: $pls_licenseno");
	my @list;

        if ($pls_licenseno ne "")
                {
        my $rs_pls_li =  $c->model('cashregister::License')->find({license_no => $pls_licenseno});

			my $pls_licenseid	  =	 $rs_pls_li->licenseid;
                        $pls_categoryid           =      $rs_pls_li->categoryid;
                        $pls_license_no           =      $rs_pls_li->license_no;
                        $pls_license_type         =      $rs_pls_li->license_type;
                        $pls_validity_startxxx    =      $rs_pls_li->validity_start;
                        $pls_validity_endxxx      =      $rs_pls_li->validity_end;
                        my $entry_date      	  =      $rs_pls_li->entry_date;

                        my @start_date            =      split (/T/, $pls_validity_startxxx);
                        $pls_validity_start       =      $start_date[0];
                        my @end_date              =      split (/T/, $pls_validity_endxxx);
                        $pls_validity_end         =      $end_date[0];

#### fetch category id from database by variable passed to form from $lx_li_category =       unxss($l_li_category);
                        my $form_category_row     = $c->model('cashregister::LicenseCategory')->find({categoryid => $pls_categoryid->categoryid});
                        my $form_cate_name        = $form_category_row->categoryname;
                        $c->log->debug(" Print the value of category ID = $form_cate_name");

		 $c->log->debug("Print Variable :$pls_licenseid, $pls_license_no, $form_cate_name, $pls_license_type,$pls_validity_start,$pls_validity_end,$entry_date");

			$c->stash->{backend_license} = 1;
		
			my $href;
                        $href->{ licenseid}            =       $pls_licenseid,;
                        $c->stash->{sli}               =       $href;
                        $href->{ license_no}           =       $pls_license_no;
                        $c->stash->{sln}               =       $href;
                        $href->{categoryname}          =       $form_cate_name;
                        $c->stash->{slc}               =       $href;
                        $href->{license_type }         =       $pls_license_type;
                        $c->stash->{slt}               =       $href;
                        $href->{ validity_start}       =       $pls_validity_start;
                        $c->stash->{slvs}              =       $href;
                        $href->{ validity_end}         =       $pls_validity_end;
                        $c->stash->{slve}              =       $href;
                        $href->{entry_date}            =       $entry_date;
                        $c->stash->{sle}               =       $href;



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
