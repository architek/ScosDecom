#
#===============================================================================
#
#         FILE: FieldsDef.pm
#
#  DESCRIPTION: 
#
#        FILES: ---
#         BUGS: ---
#        NOTES: ---
#       AUTHOR: YOUR NAME (), 
#      COMPANY: 
#      VERSION: 1.0
#      CREATED: 28/11/2011 22:57:27
#     REVISION: ---
#===============================================================================

package ScosDecom::Db::FieldsDef;

use warnings;
use strict;

=head1 NAME

Ccsds - Module used to define MIB files fields name

=cut
our %fields;

@{$fields{caf}} = qw { caf_numbr caf_descr caf_engfmt caf_rawfmt caf_radix caf_unit caf_ncurve caf_inter };
@{$fields{cap}} = qw { cap_numbr cap_xvals cap_yvals };
@{$fields{cur}} = qw { cur_pname cur_pos cur_rlchk cur_valpar cur_select };
@{$fields{mcf}} = qw { mcf_ident mcf_descr mcf_pol1 mcf_pol2 mcf_pol3 mcf_pol4 mcf_pol5 };
@{$fields{pas}} = qw { pas_numbr pas_altxt pas_alval };
@{$fields{pcf}} = qw { pcf_name pcf_descr pcf_pid pcf_unit ptc pfc pcf_width pcf_valid pcf_related pcf_categ pcf_natur pcf_curtx pcf_inter pcf_uscon pcf_decim pcf_parval pcf_subsys pcf_valpar pcf_sptype pcf_corr pcf_obtid pcf_darc pcf_endian };
@{$fields{pic}} = qw { pic_type pic_stype pic_pi1_off pic_pi1_wid pic_pi2_off pic_pi2_wid pic_apid };
@{$fields{pid}} = qw { pid_type pid_stype pid_apid pid_pi1_val pid_pi2_val pid_spid pid_descr pid_unit pid_tpsd pid_dfhsize pid_time pid_inter pid_valid pid_check pid_event pid_evid };
@{$fields{plf}} = qw { plf_name plf_spid plf_offby plf_offbi plf_nbocc plf_lgocc plf_time plf_tdocc };
@{$fields{tcp}} = qw { tcp_id tcp_desc };
@{$fields{txf}} = qw { txf_numbr txf_descr txt_rawfmt txf_nalias };
@{$fields{txp}} = qw { txp_numbr txp_from txp_to txp_altxt };
@{$fields{tpcf}}= qw { tpcf_spid tpcf_name tpcf_size };
@{$fields{vdf}} = qw { vdf_name vdf_comment vdf_domainid vdf_release vdf_issue };
@{$fields{vpd}} = qw { vpd_tpsd vpd_pos vpd_name vpd_grpsize vpd_fixrep vpd_choice vpd_pidref vpd_disdesc vpd_width vpd_justify vpd_newline vpd_dchar vpd_form vpd_offset };


@{$fields{ccf}} = qw { ccf_name ccf_descr ccf_descr2 ccf_ctype ccf_critical ccf_pktid ccf_type ccf_stype ccf_apid ccf_npars ccf_plan ccf_exec ccf_ilscope ccf_ilstage ccf_subsys ccf_hipri ccf_mapid ccf_defset ccf_rapid ccf_ack ccf_subschedid };
@{$fields{cdf}} = qw { cdf_name cdf_eltype cdf_descr cdf_ellen cdf_bit cdf_grpsize cdf_pname cdf_inter cdf_value cdf_tmid };
@{$fields{pcdf}} = qw { pcdf_tcname pcdf_desc pcdf_type pcdf_len pcdf_bit pcdf_pname pcdf_value pcdf_radix };
@{$fields{cpc}} = qw { cpc_pname cpc_descr ptc pfc cpc_dispfmt cpc_radix cpc_unit cpc_categ cpc_prfref 
                       cpc_ccaref cpc_pafref cpc_inter cpc_defval cpc_corr cpc_obtid }; 

require Exporter;
our @ISA = qw(Exporter);
our @EXPORT = qw(%fields);

=head1 SYNOPSIS

This library has the purpose of defining the name of the fields for all MIB files

=head1 AUTHOR

Laurent KISLAIRE, C<< <teebeenator at gmail.com> >>

=head1 BUGS

Please report any bugs or feature requests to C<teebeenator at gmail.com>

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc ScosDecom::Db::FieldsDef


=head1 LICENSE AND COPYRIGHT

Copyright 2011 Laurent KISLAIRE.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.


=cut

1; 

