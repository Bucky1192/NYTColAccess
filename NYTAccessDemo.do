// This is my comment
// Original by: Adam Ross Nelson JD PhD.
// The goal of this repository is to attempt a decode and/or reverse engineer
// of the NYT College Access Index. Information about Col. Access Index at:
//      https://www.nytimes.com/2017/05/26/opinion/2017-college-access-index-methodology.html
//      https://www.nytimes.com/interactive/2017/05/25/sunday-review/opinion-pell-table.html

set more off
clear all

// Data for this project is reproduced from:
// https://www.nytimes.com/interactive/2017/05/25/sunday-review/opinion-pell-table.html
use "https://github.com/adamrossnelson/NYTColAccess/blob/master/NYTData.dta?raw=true", clear

// Add descriptive variable labels. Based on information foud at:
// https://www.nytimes.com/interactive/2017/05/25/sunday-review/opinion-pell-table.html
label variable instnm "Name of the institution."
label variable MidNPrice "Net Price, middle incomes, in thousands."
label variable PellShare "Share of first-year students receiving Pell Grants."
label variable Index "Original index value as given in NYT."

sum PellShare               // Find mean of PellShare
local meanPell = r(mean)    // Save mean to local
sum MidNPrice               // Find mean of MidNPrice
local meanMidN = r(mean)    // Save mean to local

// Combine PellShare with MidNPrice as ratios over their mean.
// Reverse score net price (on the frame that as price goes down access goes up).
gen Indexn = (PellShare / `meanPell') - ((MidNPrice / `meanMidN'))

sum Indexn                  // Check the work. Mean should be zero.
gen LiMax = abs(Indexn)     // Temp var used to calculate normalizer.
sum LiMax                   // is maximum absolute value of Indexn.
							// Normalizer now available from r(max).

// Add one to push all values above zero.
// Divide by maximum absolute value of Indexn to normalize between 0 and 2.
gen Indexr = 1 + (Indexn / r(max))

sum Indexr                  // Final result is an index score bounded
                            // between 0 and 2. Mean of final result is one.
reg Index Indexr            // Check work to see that NYT provided Index
                            // score equals the Inexr score calculated above.
							
// Add descriptive variable lables of new estimates.
label variable Indexn "Calculated index before normalization."
label variable LiMax "Temp var used to caluclate normalizer."
label variable Indexr "Calculated normalized index."
