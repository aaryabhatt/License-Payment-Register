package cashregister::Controller::License_category;
use Class::Utils qw(makeparm selected_language unxss  commify
                    commify_series trim config today now config maphash display_error);

use Moose;
use namespace::autoclean;
use cashregister::Schema;
use Data::Dumper;
BEGIN {extends 'Catalyst::Controller'; }

=head1 NAME

cashregister::Controller::License_category - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index
add suroutine is to add a new license category. It will not accept any empty parameter. 
in this we use class::utils makeparm to receive parameters from form.
use cashregister::Schema; it is used to connect database with application
in this cashregister is thename given of schema during dbix generation.
=cut

#sub index :Path :Args(0) {
#    my ( $self, $c ) = @_;

#    $c->response->body('Matched cashregister::Controller::License_category in License_category.');
#}


sub add :Path(/license_category/add) {
   my ( $self, $c ) = @_;
    my $pars    = makeparm(@_);
    my $aparams = $c->request->params;

#the below two lines are for debugging it will show the outputin controller output as shown below
#[debug] /Contact_us/index ::Inside Contactus_us enquiry form
    my $m="/license_category/add";
    $c->log->debug("$m ::Inside License category add form");
	
	 $c->stash->{page} = {'title' => 'Add A New License Category',};
         $c->stash->{template} = 'src/Category/Add.tt';



 	my ($lic_name, $lic_description);

		$lic_name   		 = $pars->{lc_name}       ||$aparams->{lc_name}      ||undef;
		$lic_description	 = $pars->{lc_desc}       ||$aparams->{lc_desc}      ||undef;

		#The below line will print all the variable values in enquiry form
		$c->log->info("$lic_name, $lic_description : Print value of variables");

	#below if loop will check the value of variable is empty or not.
	if ($lic_name ne "" && $lic_description ne "" )  
		{
	
		#The below line will print all the variable values in enquiry form
		$c->log->info("$lic_name, $lic_description : Print value of variables");

		#below line code it to insert variable values in database.
		my $rs_lic =  $c->model('cashregister::LicenseCategory')->create
			({
        		categoryname   			 => $lic_name,
		        categorydescription              => $lic_description,

			}) ; 


			$c->log->info("$m Adding License Category :$rs_lic ");
	 		$c->res->redirect( "/license_category/list" );
			return $rs_lic;

		}
		

#	$c->res->redirect('/');
}

=head3 list Catergory
this section will list the Category on page

=cut

sub list :Path('/license_category/list')
{

  my $self              = shift;
  my $c                 = shift;

  my $fn_name           ;#= shift;
  my $startpage         = shift;
  my $desired_page      = shift || 1 ;

  my $f = "License_category/list";
  $c->log->debug("$f spage:$fn_name, StartPage: $startpage,".
                 " desired_page:$desired_page");

 my $rows_per_page = 10;
#  my @order_list = ('categoryname','categorydescription');
  my @order_list = ('categoryid');

  my %page_attribs;
  my $user_searchterm = $c->session->{'TripSearchTerm'};
  %page_attribs =
    (
     desiredpage  => $desired_page,
     startpage    => $startpage,
     rowsperpage  => $rows_per_page,
     inputsearch  => $user_searchterm,
     order        => \@order_list,
     listname     => 'Categories',
     namefn       => 'list',
#     nameclass    => 'category',
     nameclass    => 'license_category'
    );

 my $table_categories = $c->model('cashregister::LicenseCategory')->search() ;
 my $rs_categories = Class::General::paginationx
    ( $c, \%page_attribs,$table_categories );

 my @list;
  while ( my $category = $rs_categories->next() )
  {

  push
      (@list,
       {
	categoryid		=> $category->categoryid,
	categoryname		=> $category->categoryname,
	categorydescription 	=> $category->categorydescription,
       }
      );

  }

  $c->stash->{categories} = \@list;
  $c->stash->{page} = {'title' => 'List of Categories' };
  $c->stash->{template} = 'src/Category/list.tt';


}

=head2 modify

Modify Users.

Need to move most of logic to the Class.

=cut

sub modify :Path('/license_category/modify')
{

  my ($self, $c, $categoryid) = @_;

  my $fn = "License_category/modify";
  my $pars      = makeparm(@_);
  my $aparams   = $c->request->params;
  $c->stash->{page} = {'title' => 'Modify Category' };
  $c->stash->{template} = 'src/Category/Add.tt';
  $c->log->debug("$categoryid, category id value");
  my ($lic_name, $lic_description);
#$c->log->debug ("references :"$c->request->$pars->{$keys});
print Dumper($pars);

  # this section is to fetch the information from database by categoryid, find always return a single row and search return a multiple rows.
  # the name alpha and beta are the values name declared in template.
  my $category_row = $c->model('cashregister::LicenseCategory')->find({categoryid => $categoryid,});
  my ($category_desc, $categoryname);

  my $c_name = $category_row->categoryname;	
  my $c_desc = $category_row->categorydescription;

  my $href;
  $href->{categoryname} = $c_name;

  $c->stash->{alpha} = $href;	
 		
  $href->{categorydescription} = $c_desc;
  $c->stash->{beta} = $href; 

####below section will update the category and will submit it.
#my ($lic_name, $lic_description);

                $lic_name                = $pars->{lc_name}       ||$aparams->{lc_name}      ||undef;
                $lic_description         = $pars->{lc_desc}       ||$aparams->{lc_desc}      ||undef;

                #The below line will print all the variable values in enquiry form
                $c->log->info("$lic_name, $lic_description : Print value of variables");

        #below if loop will check the value of variable is empty or not.
        if ($lic_name ne "" && $lic_description ne "" )
                {

                #The below line will print all the variable values in enquiry form
                $c->log->info("$lic_name, $lic_description : Print value of variables");

#                #below line code it to insert variable values in database.
#                my $rs_lic =  $c->model('cashregister::LicenseCategory')->update_or_create
#                        ({
#			categoryid			 => $categoryid,
#                        categoryname                     => $lic_name,
#                        categorydescription              => $lic_description,
#
#                        }) ;

my $modify_cat_row = $c->model('cashregister::LicenseCategory')->find({categoryid => $categoryid,});
 	 $modify_cat_row->update
                        ({
                        categoryname                     => $lic_name,
                        categorydescription              => $lic_description,

                        }) ;
			
#	$modify_cat_row->update;


#                        $c->log->info(" Update License Category :$rs_lic ");
                        $c->log->info(" Update License Category :$modify_cat_row ");
                        $c->res->redirect( "/license_category/list" );
#                        return $rs_lic;
                        return $modify_cat_row;

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
