{smcl}
{* *! version 2.2 July 2019}{...}
{cmd:help oaxaca_rif}{right: ({browse "https://doi.org/10.1177/1536867X20909690":SJ20-1: st0588})}
{hline}

{title:Title}

{p2colset 5 19 21 2}{...}
{p2col :{cmd:oaxaca_rif} {hline 2}}Recentered influence
function decomposition: Oaxaca-Blinder
decomposition of outcome distributional differences{p_end}
{p2colreset}{...}


{title:Syntax}

{p 8 18 2}
{cmd:oaxaca_rif} {depvar} [{it:indepvars}] {ifin} {weight}{cmd:,}
{opt by(groupvar)}
{cmd:rif(}{it:{help oaxaca_rif##RIF_options:RIF_options}}{cmd:)}
[{it:options}]

{pstd}
where {it:indepvars} is  {it:term} [{it:term} {it:...}]
with {it:term} as {varlist} or 
{cmd:(}[{help oaxaca##subsume:{it:name}}{cmd::}] {varlist}{cmd:)}
and {varlist} may contain
{cmdab:n:ormalize(}{help oaxaca##norm:{it:spec}}{cmd:)}


{synoptset 25 tabbed}{...}
{marker opt}{synopthdr:options}
{synoptline}
{p2coldent :* {opt by(groupvar)}}specify the groups for decomposition{p_end}
{p2coldent :* {opt rif(RIF_options)}}specify the statistic used as outcome;
see {helpb rifvar:rifvar()} for details on options{p_end}
{synopt :{opt relax}}do not stop when zero variance coefficients are encountered{p_end}
{synopt :{opt n:oisily}}display model estimation output{p_end}
{synopt :{opt swap}}swap groups for the estimation of the wage differential{p_end}
{synopt :{opt wgt(#)}}define the counterfactual for the two-fold decomposition; default is {cmd:wgt(0)}; for the reweighted decomposition, 
{it:#} can be only the value 0 or 1{p_end}
{synopt :{opt scale(real)}}specify a value to rescale the recentered influence
function (RIF) statistic; default is {cmd:scale(1)} (no rescaling){p_end}
{synopt :{opt cluster(varname)}}specify a variable to be used as cluster{p_end}
{synopt :{opt retain(newvar)}}specify a new variable where the generated RIF
will be stored; for the reweighted decomposition, this option
does not store the RIF for the counterfactual{p_end}
{synopt :{opt replace}}when {cmd:retain()} is specified, replaces the values of
the variable declared in {opt retain(newvar)} if it already exists{p_end}
{synopt :{opth s2var(varlist)}}request the inclusion of centered
squared parameters {X-E(X)}^2 of all variables in {it:varlist} to be included in
the model specification; this helps to control for differences in
mean characteristics and also for differences in variance{p_end}
{synopt :{opt rwlogit(varlist)}}specify the logit regression for the
estimation of the reweighting factors; default is no reweight{p_end}
{synopt :{opt rwprobit(varlist)}}specify the probit regression for the
estimation of the reweighting factors; default is no reweight{p_end}
{synopt :{opt iseed(str)}}create replicable results with rank-dependent indices{p_end}
{synoptline}
{p 4 6 2}
{cmd:aweight}s, {cmd:fweight}s, {cmd:iweight}s, and {cmd:pweight}s are allowed;
see {help weight}.{p_end}
{pstd}
* {cmd:by()} and {cmd:rif()} are required.


{title:Description}

{pstd} 
{cmd:oaxaca_rif} is a wrapper command that uses the capabilities of 
{helpb oaxaca} to compute the standard and reweighted Oaxaca-Blinder (OB)
decompositions using RIFs as outcome variables of various distributional
statistics including the mean, quantiles, and Gini coefficient, among others.
See {helpb rifvar:rifvar()} for a full list  of all statistics currently
permitted.

{pstd} 
OB decompositions are often used to analyze average outcome gaps over two
groups.  In combination with RIFs, they can be used to analyze outcome
decompositions of any distributional statistic for which a RIF can be
calculated (Firpo, Fortin, and Lemieux 2018).

{pstd} 
{it:depvar} is the outcome variable of interest (for example, log wages), and
{it:indepvars} are predictors (for example, education and work experience).
{it:groupvar} identifies the groups to be compared.
{opt rif(RIF_options)} is used to define the RIF function to be used in the
decomposition.  The default is to estimate the standard OB decomposition.  When
the option {cmd: rwlogit()} or {cmd: rwprobit()} is used, it estimates the
reweighted OB decomposition as described in Firpo, Fortin, and Lemieux (2018).

{pstd} 
By default, robust standard errors clustered at the individual level are
reported.  When using {cmd: cluster()}, standard errors are estimated using this
cluster variable.  For methods and formulas, see Jann (2008).

{pstd} 
Firpo, Fortin, and Lemieux (2018) suggest to estimate standard errors using
bootstrap methods because of the additional complication of estimating
regressions that rely on predicted inverse probability weights in addition to
the estimations of the RIF.

{pstd}
{cmd:oaxaca_rif} typed without arguments replays the last results.


{title:Aggregated and normalized results for sets of variables}

{pstd}
Thanks to the capabilities of {helpb oaxaca}, decomposition results can be
aggregated for subsets of variables and normalized for a set of categorical
variables.


{title:Options}

{phang}
{opt by(groupvar)} specifies the {it:groupvar} that defines the two groups to
be compared.  {cmd:by()} is required.  While the variable itself can contain
multiple groups, it should identify only two groups within the sample used in
the data.

{phang}
{cmd:rif(}{it:{help oaxaca_rif##RIF_options:RIF_options}}{cmd:)} specifies the
RIF to be estimated and used for the decomposition.  {cmd:rif()} is required.

{pmore}
See {helpb rifvar:rifvar()} for the most current list of all statistics for
which RIF can be estimated, and see Rios-Avila (2019) for a detailed list of
the formulas used for analysis.

{phang}
{opt relax} enables the estimation of the OB decomposition even if there are
zero variance coefficients in the model.  This typically happens when
explanatory variables in the outcome model specification are dropped because
of collinearity for one of the two groups in the model.

{phang}
{opt noisily} displays the intermediate steps of the model estimation.  This
is useful to identify bugs in the estimation process.

{phang}
{opt swap} reverses the order of the groups for the estimation of the
distribution gaps.{p_end}

{phang}
{opt wgt(#)} is similar to {helpb oaxaca}'s option {cmd:weight()}.  It
requests to compute the two-fold decomposition, where {it:#} is the weight
given to group 1 relative to group 2.  This is used to determine the
counterfactual scenario for the decomposition.  One can specify only
{cmd:wgt(0)} or {cmd:wgt(1)}.  When the standard OB decomposition is done (no
reweights), {cmd:wgt(0)} indicates the counterfactual to be X1*B2.  Thus,
DX=(X1-X2)*B2 and DB=X1*(B1-B2), and vice versa.

{pmore}
When the reweighted OB decomposition is obtained, {cmd:wgt(0)} indicates the
counterfactual to be obtained by fitting the model using data for group 2
reweighted to have characteristics of distribution similar to those in group
1, and vice versa.  See Rios-Avila (2019) for more specifics.

{phang}
{opt scale(real)} specifies a value to rescale the RIF statistic.  The default
is {cmd:scale(1)} (no rescaling).  It is useful to facilitate the
interpretation of statistics like the Gini and Lorenz ordinates, which by
construction fall between 0 and 1.

{phang}
{opt cluster(varname)} adjusts standard errors for intragroup correlation.  By
default, standard errors are estimated using each individual as a cluster.

{phang}
{opt retain(newvar)} specifies a new variable where the internally generated
RIF will be stored.  For the reweighted decomposition, this option does not
store the RIF for the counterfactual distribution.

{phang}
{opt replace} can be used in combination with {cmd:retain()} to replace the
values of the variable declared in {opt retain(newvar)} if it already exists.

{phang}
{opth s2var(varlist)} requests the inclusion of centered squared parameters
{X-E(X)}^2 of all variables in {it:varlist} to be included in the model
specification.  This helps to control for differences in mean characteristics
and for differences in variance.  This is the preferred method to add centered
squared terms when using the reweighted decomposition.

{phang}
{opt rwlogit(varlist)} and {opt rwprobit(varlist)} request to estimate the
reweighted OB decomposition as described in Firpo, Fortin, and Lemieux (2018).
The variables declared are used to fit a logit or probit model to estimate the
inverse probability weights for the identification of the counterfactual
distributions.   Only one of the two methods is allowed.  One can use the same
specification as the one in the main model or a different specification.

{phang}
{opt iseed(str)} is used to create an auxiliary variable to deal with ties for
the replication of results with rank-dependent indices.
    

{marker RIF_options}{...}
{title:RIF options}

{synoptset 40}{...}
{synopthdr :RIF_options}
{synoptline}
{synopt :{opt mean}}sample mean{p_end}
{synopt :{opt var}}variance{p_end}
{synopt :{opt q(#p)} [{opt kernel(kernel)} {opt bw(#)}]}{it:p}th quantile, where 0<{it:#p}<100; 
kernel functions available are {cmd:gaussian} (default), {cmd:epan},
{cmd:epan2}, {cmd:biweight}, {cmd:cosine}, {cmd:parzen}, {cmd:rectan},
{cmd:triangle}, and {cmd:triweight}; all kernel functions available for the
command {cmd:kdensity} are also allowed; default for bandwidth is 
the Silverman's plugin optimal bandwidth{p_end}
{synopt :{opt iqr(#p1 #p2)} [{opt kernel(kernel)} {opt bw(#)}]}interquantile
range: {opt q(#p2)} - {opt q(#p1)}, where 0<{it:p1}<={it:p2}<100; 
{cmd:bw()} and {cmd:kernel()} options are the same as for the quantile case{p_end}
{synopt :{opt gini}}Gini inequality index{p_end}
{synopt :{opt cvar}}coefficient of variation{p_end}
{synopt :{opt std}}standard error{p_end}
{synopt :{opt iqratio(#p1 #p2)} [{opt kernel(kernel)} {opt bw(#)}]}interquantile ratio: 
{opt q(#p2)}/{opt q(#p1)}, where 0<{it:p1}<={it:p2}<100;
{cmd:bw()} and {cmd:kernel()} options are the same as for the quantile case{p_end}
{synopt :{opt entropy(#a)}}entropy inequality index with sensitivity index
{it:#a}{p_end}
{synopt :{opt atkin(#e)}}Atkinson inequality index with inequality aversion
{it:#e}>0{p_end}
{synopt :{opt logvar}}logarithmic variance (different from variance of logarithms){p_end}
{synopt :{opt glor(#p)}}generalized Lorenz ordinate at {it:#p}, where
0<{it:#p}<100{p_end}
{synopt :{opt lor(#p)}}Lorenz ordinate at {it:#p}, with 0<{it:#p}<100{p_end}
{synopt :{opt ucs(#p)}}share of income held by richest 1-p%; 1-{opt lor(#p)}{p_end}
{synopt :{opt iqsr(#p1 #p2)}}interquantile share ratio:
(1-{opt lor(#p2)})/{opt lor(#p1)}, where 0<{it:#p1}<={it:#p2}<100{p_end}
{synopt :{opt mcs(#p1 #p2)}}share of income held by people between {it:#p1}
and {it:#p2}: {opt lor(#p2)}-{opt lor(#p1)}, where 0<{it:#p1}<{it:#p2}<100; also known as P_shares{p_end}
{synopt :{opt pov(#a)} {opt pline(#|varname)}}Foster-Greer-Thorbecke poverty measure
with sensitivity parameter {it:#a}>=0 and poverty line defined by
{cmd:pline()}; {cmd:pline()} can be a single number or a variable{p_end}
{synopt :{opt watts(#povline)}}Watts poverty index; requires a number or variable to define the poverty line{p_end}
{synopt :{opt sen(#povline)}}Sen poverty index; requires a number to define the poverty line{p_end}
{synopt :{opt tip(#p)} {opt pline(#)}}three I's of poverty (TIP) curve ordinate at
{it:#p} for poverty line defined by {opt pline(#)}, where 0<{it:#p}<100{p_end}
{synopt :{opt agini}}absolute Gini{p_end}
{synopt :{opt acindex(varname)}}absolute concentration index using {it:varname} as the rank variable{p_end}
{synopt :{opt cindex(varname)}}concentration index using {it:varname} as the rank variable{p_end}
{synopt :{opt eindex(varname)} {opt lb(#)} {opt ub(#)}}Erreygers's index using
{it:varname} as the rank variable, with lower bound {cmd:lb()} and upper
bound {cmd:ub()}
and where {cmd:lb()}<{cmd:ub()}{p_end}
{synopt :{opt arcindex(varname)} {opt lb(#)}}attainment relative concentration index
using {it:varname} as the rank variable, with lower bound {cmd:lb()}{p_end}
{synopt :{opt srindex(varname)} {opt ub(#)}}shortfall relative concentration index
using {it:varname} as the rank variable, with upper bound {cmd:ub()}{p_end}
{synopt :{opt windex(varname)} {opt lb(#)} {opt ub(#)}}Wagstaff concentration index using
{it:varname} as the rank variable, with lower bound {cmd:lb()} and upper
bound {cmd:ub()}
and where {cmd:lb()}<{cmd:ub()}{p_end}
{synopt :{opt rifown(str)} {opt rifopt(str)}}these options are added to enable
{cmd:rifvar()} to use other community-contributed programs to estimate RIF for statistics not available in this list{p_end}
{synoptline}

{title:Examples}
        
{phang2}
{bf:. {stata "use http://fmwww.bc.edu/RePEc/bocode/o/oaxaca.dta"}}

{pstd}
Verify you have the latest {cmd:oaxaca} install on your computer.  Older
versions have problems with the {cmd:robust} option.{p_end}
{phang2}
{bf:. {stata ssc install oaxaca, replace}}{p_end}
{phang2}
{bf:. {stata generate wage=exp(lnwage)}}

{pstd}
Standard OB decomposition.{p_end}
{phang2}
{bf:. {stata oaxaca lnwage educ exper tenure, by(female) weight(1) robust}}

{pstd}
Standard RIF-OB decomposition.{p_end}
{phang2}
{bf:. {stata oaxaca_rif lnwage educ exper tenure, by(female) wgt(1) rif(mean)}}

{pstd}
Standard OB decomposition with weights.{p_end}
{phang2}
{bf:. {stata oaxaca lnwage educ exper tenure [pw=wt], by(female) weight(1) robust}}

{pstd}
Standard RIF-OB decomposition with weights.{p_end}
{phang2}
{bf:. {stata oaxaca_rif lnwage educ exper tenure [pw=wt], by(female) wgt(1) rif(mean)}}

{pstd}
Standard RIF-{cmd:q(50)}-OB decomposition.{p_end}
{phang2}
{bf:. {stata oaxaca_rif lnwage educ exper tenure, by(female) wgt(1) rif(q(50))}}

{pstd}
Standard RIF-{cmd:iqr(25 75)}-OB decomposition.{p_end}
{phang2}
{bf:. {stata oaxaca_rif lnwage educ exper tenure, by(female) wgt(1) rif(iqr(25 75))}}

{pstd}
Standard RIF-Gini-OB decomposition.{p_end}
{phang2}
{bf:. {stata oaxaca_rif wage educ exper tenure, by(female) wgt(1) rif(gini)}}
 
{pstd}
Reweighted RIF-OB decomposition.{p_end}
{phang2}
{bf:. {stata oaxaca_rif lnwage educ exper tenure, by(female) wgt(1) rif(mean) rwlogit(educ exper tenure)}}

{pstd}
Reweighted RIF-OB decomposition with weights.{p_end}
{phang2}
{bf:. {stata oaxaca_rif lnwage educ exper tenure [pw=wt], by(female) wgt(1) rif(mean) rwlogit(educ exper tenure)}}

{pstd}
Reweighted RIF-OB decomposition with weights with centered squared terms.{p_end}
{phang2}
{bf:. {stata oaxaca_rif lnwage educ exper tenure [pw=wt], by(female) wgt(1) rif(mean) rwlogit(educ exper tenure) s2var(educ exper tenure)}}

{pstd}
Reweighted RIF-{cmd:q(50)}-OB decomposition.{p_end}
{phang2}
{bf:. {stata oaxaca_rif lnwage educ exper tenure, by(female) wgt(1) rif(q(50)) rwlogit(educ exper tenure)}}

{pstd}
Reweighted RIF-{cmd:iqr(25 75)}-OB decomposition.{p_end}
{phang2}
{bf:. {stata oaxaca_rif lnwage educ exper tenure, by(female) wgt(1) rif(iqr(25 75)) rwlogit(educ exper tenure)}}

{pstd}
Reweighted RIF-Gini-OB decomposition.{p_end}
{phang2}
{bf:. {stata oaxaca_rif wage educ exper tenure, by(female) wgt(1) rif(gini) rwlogit(educ exper tenure)}}

{pstd}
Reweighted RIF-Gini-OB decomposition with bootstrap errors.{p_end}
{phang2}
{bf:. {stata "bootstrap: oaxaca_rif wage educ exper tenure, by(female) wgt(1) rif(gini) rwlogit(educ exper tenure)"}}

{pstd}
Using variable aggregation and normalization options with {cmd:oaxaca_rif}
without aggregation.{p_end}
{phang2}
{bf:. {stata oaxaca_rif lnwage age educ exper tenure, by(female) wgt(1) rif(q(25))}}

{pstd}
Aggregating the results from experience and tenure.{p_end}
{phang2}
{bf:. {stata "oaxaca_rif lnwage age educ (exper_tenure:exper tenure), by(female) wgt(1) rif(q(25))"}}

{pstd}
Decomposition with normalization of multiple categorical variables.{p_end}
{phang2}
{bf:. {stata oaxaca_rif lnwage age educ normalize(single married divorced), by(female) wgt(1) rif(q(25))}}

{pstd}
Decomposition without normalization.{p_end}
{phang2}
{bf:. {stata oaxaca_rif lnwage age educ married divorced, by(female) wgt(1) rif(q(25))}}

{pstd}
Using other community-contributed RIF functions.  Be sure to have the program
{cmd:_ghvar.ado} in the right folder.  This estimates the half-variance RIF
using the jackknife method.  See the structure of {cmd:_ghvar.ado} as a
template.{p_end}
{phang2}
{bf:. {stata oaxaca_rif lnwage age educ exper tenure, by(female) wgt(1) rif(rifown(hvar) rifopt(hvn))}}{p_end}
{phang2}
{bf:. {stata oaxaca_rif lnwage age educ exper tenure, by(female) wgt(1) rif(rifown(hvar) rifopt(hvp))}}


{marker Acknowledgments}{...}
{title:Acknowledgments}

{pstd}
This command is based on the recommendations in Firpo, Fortin, and Lemieux
(2018) for the RIF-OB decompositions.  Rios-Avila (2019) provides an intuitive
description of RIFs and their use in decomposition analysis.  This command
relies on Ben Jann's (2008) community-contributed command {cmd:oaxaca} to
implement the decompositions.

{pstd}
RIF variables are estimated using the {cmd:egen} addon {helpb rifvar:rifvar()}.

{pstd}
All errors are my own.


{title:References}

{phang}
Jann, B. 2008. {browse "https://doi.org/10.1177/1536867X0800800401":The Blinder-Oaxaca decomposition for linear regression models}. {it:Stata Journal} 8: 453-479.

{phang}
Firpo, S. P., N. M. Fortin, and T. Lemieux. 2018.
Decomposing wage distributions using recentered influence function
regressions. {it:Econometrics} 6: 28. 
{browse "https://doi.org/10.3390/econometrics6020028"}.

{phang}
Rios-Avila, F. 2019. Recentered influence functions in Stata: Methods for
analyzing the determinants of poverty and inequality. Working paper 927, Levy
Economics Institute. {browse "http://www.levyinstitute.org/pubs/wp_927.pdf"}.


{marker Author}{...}
{title:Author}

{pstd}
Fernando Rios-Avila{break}
Levy Economics Institute of Bard College{break}
Annandale-on-Hudson, NY{break}
friosavi@levy.org


{title:Also see}

{p 4 14 2}
Article:  {it:Stata Journal}, volume 20, number 1: {browse "https://doi.org/10.1177/1536867X20909690":st0588}{p_end}

{p 7 14 2}
Help:  {helpb oaxaca}, {helpb rifvar:rifvar()}, {helpb rifhdreg}, 
{helpb rifreg}, {helpb rifsureg}, {helpb rifsureg2}, {helpb uqreg},
{helpb hvar:hvar()} (if installed){p_end}
