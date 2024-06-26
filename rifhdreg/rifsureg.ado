*! rifsureg 1.1 July 2019 by Fernando Rios Avila
* Adds the Mlogit and Mprobit
* rifsureg 1.0 June 2019 by Fernando Rios Avila
** This will be a small wrapper to estimate simulataenous RIF regresions. sureg 
** biggest problems...indices with double limits. iqr mcs iqshare 
** for regressions that may depend on p or q For now only q(#list)

*capture program drop rifsureg
program rifsureg, eclass sortpreserve byable(recall)
    if replay() {
		results
        exit
    }
syntax anything [if] [in] [aw fw ], qs(str)  [,* ] [kernel(str) bw(str)] ///
	[retain(str)  replace  /// This is used to save the RIF, and replace if the variable already exists
	 scale(real 1)  /// Changes the scale of the RIF. Useful for statistics like GINI and Lorenz ordinate, as they are measured between 0-1
	 iseed(str)     /// Using this, a random variable is created to "sort" data, and avoid (or reduce) the impact of ties, making the results replicable
	 over(varname)   /// Indicates to estimate the RIF over two groups. This is can be considered as a partially conditional model. (it is conditional on one variable only)
	 rwlogit(str)   rwprobit(str)  /// This two options are used to estimate the IPW. 
	 rwmlogit(str)   rwmprobit(str)  /// This two options are used to estimate the IPW.
	 ate att atu  /// This indicates which estimator will be done. I would assume ate to be the default
	 ]
 marksample touse
 markout   `touse' `anything' `abs' `rwprobit' `rwlobit' 

 qui {
    * y and x's
	tokenize `anything'
	local y `1'
	macro shift
	local rest `*'
	** check fgreg to change names of created variables
	local expx=regexr("`exp'","=","")
	if "`expx'"=="" local expx=1
	tempvar exp2
	gen double `exp2'=`expx'
	** We first need to see if the probit model needs to be estimated
	if (("`rwlogit'"!="")+("`rwprobit'"!="")+("`rwmlogit'"!="")+("`rwmprobit'"!=""))>1 {
	  noisily: display in red "Only one probability model can be set. Choose either logit, probit, mlogit or mprobit  for the first stage"
	  exit
	}
	** model selection:
		*** Over should be a 0 1 variable.
	
	if "`rwlogit'"!="" | "`rwprobit'"!="" {
	   if "`over'"=="" {
	     display in red "Over option required to define dependent variable in probit/logit"
	     exit
	  }
	  if (("`ate'"!="") + ("`att'"!="")+("`atu'"!=""))>1 {
	     noisily: display in red "Only one option allowed. Choose ate, att or atu" 
		 exit
	  }
	  if "`ate'`att'`atu'"=="" {
	    noisily: display "Neither ate att or atu were selected. Using default average treatment effect  ate"
		local ate ate
	  }
	 
	   tempvar dy
	   	qui:egen `dy'=group(`over') if `touse'
		qui:sum `dy' if `touse'
		if r(max)>2 {
		  noisily:display in red "More than 2 groups detected. Only 2 groups allowed for the estimator"
		  exit
		}
		qui:replace `dy'=`dy'==2
		
		if "`rwprobit'"!="" {
		    
			qui:probit `dy' `rwprobit' [pw=`exp2'] if `touse'==1
			tempvar pr
			qui:predict double `pr', pr
			tempname b_rw v_rw
			matrix `b_rw'=e(b)
			matrix `v_rw'=e(V)
			local rwmodel="probit"
 		}
		if "`rwlogit'"!="" {
			qui:logit `dy' `rwlogit' [pw=`exp2'] if `touse'==1
			tempvar pr
			qui:predict double `pr', pr
			tempname b_rw v_rw
			matrix `b_rw'=e(b)
			matrix `v_rw'=e(V)
			local rwmodel="logit"
		}
		** here were do the IPW estimators
		tempvar ipw
		qui:gen double `ipw'=(`dy'==1)/`pr'+(`dy'==0)/(1-`pr')   if `touse'==1
	   if "`att'"!="" {
	       qui:replace `ipw'=`ipw'*`pr'
	   }
	   if "`atu'"!="" {
	       qui:replace `ipw'=`ipw'*(1-`pr')
	   }
	   * finally we adjust weights
	   replace `exp2'=`exp2'*`ipw'
	   local weight aw
	   local flag_ipw 1
	} 
	**********************************************************************************************
	if "`rwmlogit'"!="" | "`rwmprobit'"!="" {
	  if "`over'"=="" {
	     display in red "Over option required to define dependent variable in mprobit/mlogit"
	     exit
	  }
	  if ("`atu'"!="") | ("`att'"!="") {
	     noisily: display in red "ATU or ATT cannot be specified" 
		 exit
	  }
	  	 
	  tempvar dy
	   	qui:egen `dy'=group(`over') if `touse'
		qui:sum `dy'
		local maxv=r(max)
		if "`rwmprobit'"!="" {
			qui:mprobit `dy' `rwmprobit' [pw=`exp2'] if `touse'==1
			forvalues i =1/`maxv' {
				tempvar pr`i'
				qui:predict double `pr`i'', pr eq(`i')
			}
			tempname b_rw v_rw
			matrix `b_rw'=e(b)
			matrix `v_rw'=e(V)
			local rwmodel="mprobit"
 		}
		if "`rwmlogit'"!="" {
			qui:mlogit `dy' `rwmlogit' [pw=`exp2'] if `touse'==1
			forvalues i =1/`maxv' {
				tempvar pr`i'
				qui:predict double `pr`i'', pr eq(`i')
			}
			tempname b_rw v_rw
			matrix `b_rw'=e(b)
			matrix `v_rw'=e(V)
			local rwmodel="mlogit"
		}
		** here were do the IPW estimators
		tempvar ipw
		qui:gen double `ipw'=0
		forvalues i =1/`maxv' {
			replace `ipw'=`ipw'+(`dy'==`i')*1/`pr`i''
		}		
	   * finally we adjust weights
	   replace `exp2'=`exp2'*`ipw'
	   local weight aw
	   local flag_ipw 1
	} 	
	***
	
    numlist "`qs'", min(2) range(>0 <100) sort integer
	local nml="`r(numlist)'"

	** just adds an over. For a more semiparametric, perhaps we can add a smoother parameter. 
	capture drop __`y'_q*
 	foreach qq of local nml {
		local q : display %02.0f `qq'
		qui:egen double `retain'__`y'_q`q'=rifvar(`y') if `touse', weight(`exp2') q(`q') seed(`iseed') by(`over') kernel(`kernel') bw(`bw')
		qui:replace `retain'__`y'_q`q'=`retain'__`y'_q`q'*`scale'		
		 
	}
	 
	** scale is used to rescale data to make it easier to read. May be important for share based statistics
	** and Gini
	* MAy also help with poverty indices, if the aim is to find an average gap not as percentage but in poverty line terms.
	
	** changing weight type at the end.
	
	*qui sum `rifvar' [aw=`exp2'] if `touse'
	*local rifmean=r(mean)
	
	if "`flag_ipw'"=="" {
	    
			qui:sureg(`retain'__`y'_q* = `rest') if `touse' [`weight'`exp'], `options'
			
*			ereturn local depvar="RIF(`y')"
*			ereturn local cmd="rifhdreg"
*			ereturn local cmdline="rifhdreg `0'"
*			ereturn local rif="`rif'"q
*			ereturn scalar rifmean=`rifmean'
	}
	else {
		capture drop _wipw_
		gen double _wipw_=`exp2'
		label var _wipw_ "IPW estimated through rifhdreg "
			qui:sureg(`retain'__`y'_q* = `rest') if `touse' [`weight'=_wipw_], `options'
*			ereturn local depvar="RIF(`y')"
*			ereturn local cmd="rifhdreg"
*			ereturn local cmdline="rifhdreg `0'"
*			ereturn local rif="`rif'"
*			ereturn scalar rifmean=`rifmean'
		
	}	
	
	*** eq rename
	*** number of variables
	matrix b=e(b)
	matrix V=e(V)
	  
	local erank=colsof(b)
	local nvar= `erank'/e(k_eq)
	foreach qq of local nml {
	   local q : display %02.0f `qq'
	   local mdfl predict(xb equation(q`q')) `mdfl'
	   local nm `nm' q`q'
	   forvalues i=1/`nvar' {
	      local nm2 `nm2' q`q'
	   }
	}
	
	
	**renaming matrix

	matrix coleq b=`nm2'
	matrix roweq V=`nm2'
	matrix roweq V=`nm2'
	
	ereturn repost  b=b  V=V, rename buildfvinfo
	if "`flag_ipw'"=="1" {
		ereturn matrix b_rw=`b_rw'  
		ereturn matrix V_rw=`v_rw'  
	}
	ereturn local eqnames="`nm'"
	ereturn local depvar="`nm'"
	ereturn local exog="`nm'"
	ereturn local cmd="rifsureg"
	ereturn local cmdline="rifsureg `0'"
	ereturn local marginsdefault="`mdfl'"
	ereturn local rifwgt="_wipw_"
	ereturn local rifover="`over'"
	ereturn local rwmethod "`rwmodel'"
	
  }
  *display "`nm'"
** display
	results
end

*capture program drop results
program results, eclass
        if "`e(cmd)'"=="rifsureg"   {
			ereturn local cmd ="sureg"
			sureg
			ereturn local cmd="rifsureg"
			*display "Distributional Statistic: `e(rif)'"
			*display "Sample Mean	RIF `e(rif)' : "  in ye %7.5g e(rifmean)
		}
		else display in red "last estimates not found"
end
