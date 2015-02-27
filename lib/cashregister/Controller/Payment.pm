package cashregister::Controller::Payment;
use Class::Utils qw(makeparm selected_language unxss  commify
                    commify_series trim config today now config maphash display_error);
use Moose;
use namespace::autoclean;
use cashregister::Schema;

BEGIN {extends 'Catalyst::Controller'; }

=head1 NAME

cashregister::Controller::Payment - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut

#sub index :Path :Args(0) {
#    my ( $self, $c ) = @_;
#
#    $c->response->body('Matched cashregister::Controller::Payment in Payment.');
#}


sub add :Path(/payment/add) {
    	my ( $self, $c ) = @_;
    	my $pars    = makeparm(@_);
    	my $aparams = $c->request->params;

	$c->stash->{page} = {'title' => 'Make a New payment',};
        $c->stash->{template} = 'src/Payment/Add.tt';
	
	my ($pls_categoryid, $pls_license_no, $pls_license_type, $pls_validity_startxxx, $pls_validity_endxxx);
	my ($pls_validity_end,$pls_validity_start);
  
#	my $pls_licenseno 	=   $pars->{search_license}                ||$aparams->{search_license}         ||undef;
	my $pls_licenseno 	=   $pars->{search_license}                ||$aparams->{search_license};
	my $pls_licensenoxx     =   $pls_licenseno ;

	$c->log->debug("Search for License: $pls_licenseno"); 
	
	if ($pls_licenseno ne "")
		{
	my $rs_pls_li =  $c->model('cashregister::License')->find({license_no => $pls_licenseno});


                        $pls_categoryid           =      $rs_pls_li->categoryid;
                        $pls_license_no           =      $rs_pls_li->license_no;
                        $pls_license_type         =      $rs_pls_li->license_type;
                     	$pls_validity_startxxx    =      $rs_pls_li->validity_start;
                     	$pls_validity_endxxx      =      $rs_pls_li->validity_end;
	
			my @start_date            =      split (/T/, $pls_validity_startxxx);
                        $pls_validity_start       =      $start_date[0];
                        my @end_date              =      split (/T/, $pls_validity_endxxx);
                        $pls_validity_end         =      $end_date[0];

#### fetch category id from database by variable passed to form from $lx_li_category =       unxss($l_li_category);
	                my $form_category_row 	  = $c->model('cashregister::LicenseCategory')->find({categoryid => $pls_categoryid->categoryid});
        	        my $form_cate_name        = $form_category_row->categoryname;
                	$c->log->debug(" Print the value of category ID = $form_cate_name");
			
			my $rs_lf_lh =  $c->model('cashregister::LicenseHolder')->find({license_no => $pls_licenseno});
                        my $pls_name                 =      $rs_lf_lh->name;
                        my $pls_relativename         =      $rs_lf_lh->relativename;


			$c->stash->{backend_payment_add} = 1;    
			
			my $href;
			$href->{ license_no}      =       $pls_license_no;
                        $c->stash->{lino}  	  =       $href;
                        $href->{license_type }    =       $pls_license_type;
                        $c->stash->{lity}         =       $href;
                        $href->{ validity_start } =       $pls_validity_start;
                        $c->stash->{ vs_date }    =       $href;
                        $href->{ validity_end }   =       $pls_validity_end;
                        $c->stash->{ vs_end }     =       $href;
			$href->{ categoryname }   =       $form_cate_name;
                        $c->stash->{ licn }	  =       $href;
			$href->{ name }           =       $pls_name;
                        $c->stash->{lhn}  	  =       $href;
                        $href->{ relativename }   =       $pls_relativename;
                        $c->stash->{ sds }  	  =       $href;

			return $pls_license_no;
	}

############# This section will submit the payment information in database.
#		       my ( $self, $c ) = @_;
#		       my $pars    = makeparm(@_);
#        	       my $aparams = $c->request->params;

		       my $pls_amount             = $pars->{pl_amount}    || $aparams->{pl_amount}         ||undef;
		       my $pls_licensexx            = $pars->{li_number}    || $aparams->{li_number}         ||undef;
		       my $P_status		  = 'Submit';
		       $c->log->debug("print the amount value: $pls_amount");			
		       $c->log->debug("print the license no at submit stage: $pls_licensexx");			

		   my	$login_user = $c->user->userid;
#		   my	$login_user = $c->request->params->{'userid'};
			$c->log->debug("print the login user id :$login_user ");
			if ($pls_amount ne "")
			{
			my $ps_li_li =  $c->model('cashregister::Payment')->create
                        ({
				license_no     	  =>	  $pls_licensexx,	
				amount		  =>	  $pls_amount,
				payment_status	  =>	  $P_status,
				receivedby        =>      $login_user
			});


#################################################
###this section will be used for print the receipt

			$c->stash->{backend_payment_add} = 'print';
			

		        my $pp_license_no             = $pars->{li_number}    || $aparams->{li_number}         ||undef;
		        my $pp_license_type             = $pars->{li_type}    || $aparams->{li_type}         ||undef;
		        my $pp_validity_startxx             = $pars->{li_startdate}    || $aparams->{li_startdate}         ||undef;
		        my $pp_validity_endxx             = $pars->{li_enddate}    || $aparams->{li_enddate}         ||undef;
		        my $pp_name             = $pars->{lih_name}    || $aparams->{lih_name}         ||undef;
		        my $pp_relative             = $pars->{lih_relative}    || $aparams->{lih_relative}         ||undef;
		        my $pp_cat_name             = $pars->{lih_category}    || $aparams->{lih_category}         ||undef;
		        my $pp_amount             = $pars->{pl_amount}    || $aparams->{pl_amount}         ||undef;
#		       my $pls_amount             = $pars->{pl_amount}    || $aparams->{pl_amount}         ||undef;
		        my   $pp_receivedby = $c->user->userid;
			my $pp_date = `date +%Y-%m-%d_%H:%M:%S`;


#####this will revert the category name by finding categoryid                    
#                        my $lf_category_row = $c->model('cashregister::LicenseCategory')->find({categoryid => $pp_categoryid->categoryid});
#                        my $pp_cat_name      = $lf_category_row->categoryname;
#                        $c->log->debug(" Print the value of category ID = $pp_cat_name");
####################################################################################3
#
#                my $rs_pp_lh =  $c->model('cashregister::LicenseHolder')->find({license_no => $pp_license_no});
#                                $pp_name                =       $rs_pp_lh->name;
#                                $pp_relative            =       $rs_pp_lh->relativename;
#                        
                        my $href;
                        $href->{ license_no}            =       $pp_license_no;
                        $c->stash->{pln}                =       $href;
                        $href->{ license_type }         =       $pp_license_type;
                        $c->stash->{plt}                =       $href;
                        $href->{ validity_start }       =       $pp_validity_startxx;
                        $c->stash->{ start_d }          =       $href;
                        $href->{ validity_end }         =       $pp_validity_endxx;
                        $c->stash->{ end_d }            =       $href;
                        $href->{ name }                 =       $pp_name;
                        $c->stash->{plhn}               =       $href;
                        $href->{ relativename }         =       $pp_relative;
                        $c->stash->{ plhr }             =       $href;
                        $href->{ categoryname }         =       $pp_cat_name;
                        $c->stash->{ pltc }             =       $href;
                        $href->{ amount }               =       $pp_amount;
                        $c->stash->{ lfa }              =       $href;
                        $href->{ payment_date }         =       $pp_date;
                        $c->stash->{ p_date }           =       $href;
                        $href->{ receivedby }           =       $pp_receivedby;
                        $c->stash->{ prb }              =       $href;




#		 $c->res->redirect( "/payment/list" );
			}






}


=head3 list Payment
this section will list the Licenses on page wise

=cut

sub list :Path('/payment/list')
{

  my $self              = shift;
  my $c                 = shift;

  my $fn_name           ;#= shift;
  my $startpage         = shift;
  my $desired_page      = shift || 1 ;

  my $f = "payment/list";
  #$c->log->debug("$f spage:$fn_name, StartPage: $startpage,". " desired_page:$desired_page");
#  $c->log->debug("$f spage: $fn_name, StartPage: $startpage, desired_page:$desired_page");

 my $rows_per_page = 10;
#  my @order_list = ('categoryname','categorydescription');
  my @order_list = ('paymentid');

  my %page_attribs;
  my $user_searchterm = $c->session->{'TripSearchTerm'};
  %page_attribs =
        (
        desiredpage  => $desired_page,
        startpage    => $startpage,
        rowsperpage  => $rows_per_page,
        inputsearch  => $user_searchterm,
        order        => \@order_list,
        listname     => 'Payments',
        namefn       => 'list',
#     nameclass    => 'category',
        nameclass    => 'payment'
    );

	my $table_payment = $c->model('cashregister::Payment')->search() ;
 	my $rs_payment = Class::General::paginationx
    	( $c, \%page_attribs,$table_payment );

#	my ($p_paymentid, $p_license_no, $p_amount, $p_payment_date, $p_payment_status, $p_receivedby);

	 my @list;
	  while ( my $payment = $rs_payment->next() )
  	{

###################get column values, we used this becuse in database foreign key reference it gives the hash reference value. to get the value 
################### we have to use get_column function 
		my $col1 = 'license_no';
		my $licensenoxyz = $payment->get_column($col1);
		$c->log->debug("value of column license : $licensenoxyz");

#####################


		push
		      (@list,
      			 {
				paymentid	=>	$payment->paymentid,
				license_no	=>	$licensenoxyz,
				amount		=>	$payment->amount,
				payment_date	=>	$payment->payment_date,
				payment_status	=>	$payment->payment_status,
				receivedby	=>	$payment->receivedby,
			}
		      );
		
#	 $c->log->debug("content of array: $list[0], $list[1], $list[2], $list[3], $list[4], $list[5]");
	}		
	
	 $c->stash->{payment} = \@list;
	 $c->stash->{page} = {'title' => 'All Payments' };
	 $c->stash->{template} = 'src/Payment/list.tt';

}


=head4 cancel

Cancel a Paymment.

=cut

sub cancel :Path('/payment/cancel')
{

  my ($self, $c, $paymentid) = @_;

  my $fn = "Payment/cancel";
  my $pars      = makeparm(@_);
  my $aparams   = $c->request->params;
  $c->stash->{page} = {'title' => 'Cancel a Payment' };
  $c->stash->{template} = 'src/Payment/Cancel.tt';
  $c->log->debug("Payment ID: $paymentid");
###
################## This section is to fetch inforation in form ##############

  if ($paymentid ne "")
	{
	my $rs_payment =  $c->model('cashregister::Payment')->find({paymentid => $paymentid});
	my ($p_licenseno, $p_paymentid, $p_date, $p_amount);
	
###################get column values, we used this becuse in database foreign key reference it gives the hash reference value. to get the value 
################### we have to use get_column function 
                my $col1 = 'license_no';
                $p_licenseno = $rs_payment->get_column($col1);
                $c->log->debug("value of column license : $p_licenseno");


	
#	$p_licenseno = $rs_payment->license_no;
	$p_paymentid = $rs_payment->paymentid;
	$p_date      = $rs_payment->payment_date;
	$p_amount    = $rs_payment->amount;

	my $href;
        $href->{ license_no }      	=      $p_licenseno;
        $c->stash->{lino}       	=      $href;
	$href->{ paymentid } 		=      $p_paymentid;
	$c->stash->{ pid }              =      $href;	
	$href->{ payment_date } 	=      $p_date;
	$c->stash->{ pdate }            =      $href;	
	$href->{ amount } 		=      $p_amount;
	$c->stash->{ pamount }          =      $href;	
	}

#################### THis section will cancel the payment ################

        my $c_license            	= $pars->{li_number}    || $aparams->{li_number}        ||undef;
        my $c_paymentid            	= $pars->{pid}    	|| $aparams->{pid}        	||undef;
        my $c_cancel            	= $pars->{reason_cancel} || $aparams->{reason_cancel}   ||undef;

	if ($c_license ne "" && $c_paymentid ne "" && $c_cancel ne "")
	{

		my $login_user = $c->user->userid;
                $c->log->debug("print the login user id :$login_user ");
		
		$c->model('cashregister')->txn_do(sub {
                my $rs_li_li =  $c->model('cashregister::CancelReport')->create
                        ({
                        license_no		=>      $c_license,
			userid			=>	$login_user,
			paymentid		=>	$c_paymentid,
			description		=>	$c_cancel
                        }) ;
		
		my $cancel_s = 'Cancel';
		my $rs_st_li =  $c->model('cashregister::Payment')->find({ paymentid => $c_paymentid });
                        $rs_st_li->update
                        ({
                        payment_status                      =>      $cancel_s,
                        }) ;

		
		});	



	}
}


=head3 Caancel payment list
this section will list the cancel payment list

=cut

sub cancel_list :Path('/payment/cancel_list')
{

  my $self              = shift;
  my $c                 = shift;

  my $fn_name           ;#= shift;
  my $startpage         = shift;
  my $desired_page      = shift || 1 ;

  my $f = "payment/cancel_list";
  #$c->log->debug("$f spage:$fn_name, StartPage: $startpage,". " desired_page:$desired_page");
#  $c->log->debug("$f spage: $fn_name, StartPage: $startpage, desired_page:$desired_page");

 my $rows_per_page = 10;
#  my @order_list = ('categoryname','categorydescription');
  my @order_list = ('cancel_date');

  my %page_attribs;
  my $user_searchterm = $c->session->{'TripSearchTerm'};
  %page_attribs =
        (
        desiredpage  => $desired_page,
        startpage    => $startpage,
        rowsperpage  => $rows_per_page,
        inputsearch  => $user_searchterm,
        order        => \@order_list,
        listname     => 'Cancel Payments',
        namefn       => 'list',
#     nameclass    => 'category',
        nameclass    => 'payment_cancel'
    );



        my $table_cancel_payment = $c->model('cashregister::CancelReport')->search() ;
        my $rs_payment = Class::General::paginationx
        ( $c, \%page_attribs,$table_cancel_payment );

#       my ($p_paymentid, $p_license_no, $p_amount, $p_payment_date, $p_payment_status, $p_receivedby);

         my @list;
          while ( my $payment = $rs_payment->next() )
        {

###################get column values, we used this becuse in database foreign key reference it gives the hash reference value. to get the value 
################### we have to use get_column function 
                my $col1 = 'license_no';
                my $licensenoxyz = $payment->get_column($col1);
                $c->log->debug("value of column license : $licensenoxyz");
                my $col2 = 'paymentid';
                my $paymentidxyz = $payment->get_column($col2);
                $c->log->debug("value of column license : $paymentidxyz");

		my $login_user = $c->user->userid;
                $c->log->debug("print the login user id :$login_user ");
#####################


                push
                      (@list,
                         {
                                paymentid       =>      $paymentidxyz,
                                license_no      =>      $licensenoxyz,
                                cancel_date     =>      $payment->cancel_date,
                                userid  	=>      $login_user,
                                description     =>      $payment->description,
                        }
                      );

#        $c->log->debug("content of array: $list[0], $list[1], $list[2], $list[3], $list[4], $list[5]");
        }

	 $c->stash->{cancel_payment} = \@list;
         $c->stash->{page} = {'title' => 'All Cancel Payments' };
         $c->stash->{template} = 'src/Payment/cancel_list.tt';

}


=head4 Print

Print Payment Reciept

=cut

sub print :Path('/payment/print')
{

  my ($self, $c, $paymentid) = @_;

  my $fn = "Payment/print";
#  my $pars      = makeparm(@_);
#  my $aparams   = $c->request->params;
  $c->stash->{page} = {'title' => 'Print Payment' };
  $c->stash->{template} = 'src/Payment/print.tt';
  
  $c->log->debug("Print Payment ID : $paymentid");

  my ($pp_categoryid, $pp_license_no, $pp_license_type, $pp_validity_start, $pp_validity_end);
  my ($pp_amount, $pp_receivedby, $pp_date, $pp_paymentid, $pp_name, $pp_relative );		
  if ($paymentid ne "")
	{

		$c->model('cashregister')->txn_do(sub {
  		$c->log->debug("Print Payment ID : $paymentid");

#                my $rs_pp_li =  $c->model('cashregister::Payment')->find({paymentid => $paymentid});
 		my $rs_pp_li =  $c->model('cashregister::Payment')->find({ paymentid => $paymentid });
#				$pp_paymentid		=	$rs_pp_li->paymentid;
				$pp_license_no		=	$rs_pp_li->license_no;
				$pp_amount		=	$rs_pp_li->amount;	
				$pp_receivedby		=	$rs_pp_li->receivedby;
				$pp_date		=	$rs_pp_li->payment_date;



		my $rs_pp_l =  $c->model('cashregister::License')->find({license_no => $pp_license_no->license_no});
				$pp_categoryid		= 	$rs_pp_l->categoryid;
				$pp_license_type	=	$rs_pp_l->license_type;
				$pp_validity_start	=	$rs_pp_l->validity_start;
				$pp_validity_end	=	$rs_pp_l->validity_end;

		####### This section is to remove time from date printing in list view
        			my @v_start_date_a      =       split(/T/, $pp_validity_start);
			        my $pp_validity_startxx        =       $v_start_date_a[0];
			        
				my @v_end_date_a        =       split(/T/, $pp_validity_end);
			        my $pp_validity_endxx          =       $v_end_date_a[0];



####this will revert the category name by finding categoryid                    
                        my $lf_category_row = $c->model('cashregister::LicenseCategory')->find({categoryid => $pp_categoryid->categoryid});
                        my $pp_cat_name      = $lf_category_row->categoryname;
                        $c->log->debug(" Print the value of category ID = $pp_cat_name");
###################################################################################3

		my $rs_pp_lh =  $c->model('cashregister::LicenseHolder')->find({license_no => $pp_license_no});
				$pp_name		=	$rs_pp_lh->name;
				$pp_relative		=	$rs_pp_lh->relativename;
			
			my $href;
			$href->{ license_no}    	=       $pp_license_no->license_no;
                        $c->stash->{pln}  		=       $href;
                        $href->{ license_type }  	=       $pp_license_type;
                        $c->stash->{plt}  		=       $href;
                        $href->{ validity_start }       =       $pp_validity_startxx;
                        $c->stash->{ start_d }  	=       $href;
                        $href->{ validity_end }         =       $pp_validity_endxx;
                        $c->stash->{ end_d }  		=       $href;
			$href->{ name }         	=       $pp_name;
                        $c->stash->{plhn}  		=       $href;
                        $href->{ relativename }         =       $pp_relative;
                        $c->stash->{ plhr }  		=       $href;
                        $href->{ categoryname }         =       $pp_cat_name;
                        $c->stash->{ pltc }  		=       $href;
                        $href->{ amount }   		=       $pp_amount;
                        $c->stash->{ lfa }  		=       $href;
                        $href->{ payment_date }         =       $pp_date;
                        $c->stash->{ p_date }  		=       $href;
                        $href->{ receivedby }         	=       $pp_receivedby;
                        $c->stash->{ prb }  		=       $href;



						});
			
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
