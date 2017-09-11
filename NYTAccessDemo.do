set more off
clear all

use https://www.adamrossnelson.com/nytask/NYTData.dta, clear

// Add descriptive variable labels. Based on information foud at:
// https://www.nytimes.com/interactive/2017/05/25/sunday-review/opinion-pell-table.html
label variable instnm "Name of the institution."
label variable MidNPrice "Net Price, middle incomes, in thousands."
label variable PellShare "Share of first-year students receiving Pell Grants"
label variable Index "Original index value as given in NYT."

sum PellShare               // Find mean of PellShare
local meanPell = r(mean)    // Save mean to local
sum MidNPrice               // Find mean of MidNPrice
local meanMidN = r(mean)    // Save mean to loal

// Combine PellShare with MidNPrice as ratios over their mean.
// Reverse score net price (on the frame that as price goes down access goes up).
gen Indexn = (PellShare / `meanPell') - ((MidNPrice / `meanMidN'))

sum Indexn                  // Check the work. Mean should be zero.
gen LiMax = abs(Indexn)     // Temp var used to calculate normalizer.
sum LiMax                   // is maximum absolute value of Indexn.
							// Normalizer now available from r(max).

// Add one to push all values above zero.
// Dividd by maximum absolute value of Indexn to normalize between 0 and 2.
gen Indexr = 1 + (Indexn / r(max))

sum Indexr                  // Final result is an index score bounded
                            // between 0 and 2. Mean of final result is one.
reg Index Indexr            // Check work to see that NYT provided Index
                            // score equals the Inexr score calculated above.
							
// Add descriptive variable lables of new estimates.
label variable Indexn "Calculated index before normalization."
label variable LiMax "Temp var used to caluclate normalizer."
label variable Indexr "Calculated normalized index."
