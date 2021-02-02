use "C:\Users\Tiffany\Desktop\GRP.dta", clear
univar GRP sexratio pop grate HCE sales avewage ncity invst imex localrev localexp foreign finvst deposit pindv12 pwkagepop
egen regionID = group(region)
tabulate region, summarize(GRP)
corr sexratio pop grate HCE sales avewage ncity invst imex localrev localexp foreign finvst deposit pindv12 pwkagepop

xtset regionID year
xtreg lGRP sexratio pop pindv12 HCE sales avewage ncity invst imex localrev localexp foreign finvst deposit, fe 
estimate store model1,title(Base Regression)
xi: xtreg lGRP sexratio pop pindv12 HCE sales avewage ncity invst imex localrev localexp foreign finvst deposit i.dist, 
estimate store model2,title(District Difference)
xtreg lGRP sexratio pop pindv12 HCE sales avewage ncity invst imex localrev localexp foreign finvst deposit grate pwkagepop, fe
estimate store model3,title(Population Structure Impact)
xml_tab model1 model2 model3, append save (C:\Users\Tiffany\Desktop\GRP.xml)

*Regression model using robust se
xtreg lGRP sexratio pop pindv12 HCE sales avewage ncity invst imex localrev localexp foreign finvst deposit, fe vce(robust)
estimate store model1r,title(Base Regression)
xi: xtreg lGRP sexratio pop pindv12 HCE sales avewage ncity invst imex localrev localexp foreign finvst deposit i.dist, vce(robust)
estimate store model2r,title(District Difference)
xtreg lGRP sexratio pop pindv12 HCE sales avewage ncity invst imex localrev localexp foreign finvst deposit grate pwkagepop, fe vce(robust)
estimate store model3r,title(Population Structure Impact)
xml_tab model1r model2r model3r, append save (C:\Users\Tiffany\Desktop\GRP_Robust.xml)

*Transform a shapefile to dta. file
shp2dta using "/Users/Tiffany/Desktop/cn_map/china_region", database(region) coordinates(regionxy) genid(id) gencentroids(c) replace
use region, clear
describe
rename x_c longitude
rename y_c latitude
rename ID_1 fips
spmat contiguity cregion using regionxy, norm(row) id(id) replace
spmat summarize cregion, links
drop ID_0 ISO NAME_0 HASC_1 CCN_1 CCA_1 TYPE_1

*Generate maps in STATA
use "C:\Users\Tiffany\Desktop\GRP_map.dta", clear
spmap sexratio2014 using regionxy, id(id) title ("Gender Imbalance Distribution of China in 2014", color(black) size(*1.2)) fcolor(Blues) clnumber(3) clmethod(custom) clbreaks (0 103 107 120)
graph export "C:\Users\Tiffany\Desktop\Gender Imbalance of CN in 2014.png", as(png) replace
spmap GRP2014 using regionxy, id(id) title ("Gross Regional Product of China in 2014", color(black) size(*1.2)) fcolor(Greens) clnumber(2) clmethod(custom) clbreaks (920.83 17689.94  67809.85) note("Gross Regional Product(100 million yuan), Median: 17689.94 ")
graph export "C:\Users\Tiffany\Desktop\Gross Regional Product of China in 2014.png", as(png) replace
spmap mapcode using regionxy, id(id) title ("GRP and Sex Ratio Distribution in China(2014)", color(black) size(*1.2)) fcolor(Blues) clnumber(4)


/* g east = (region == "Beijing" | region == "Tianjin" | region == "Hebei" | region == "Shanghai" | region == "Jiangsu" | region == "Zhejiang" | region == "Fujian" | region == "Shandong" | region == "Guangdong" | region == "Hainan")
g middle = (region == "Shanxi" | region == "Anhui" | region == "Jiangxi" | region == "Henan" | region == "Hunan" | region == "Hubei")
g west = (region == "Inner Mongolia" | region == "Guangxi" | region == "Chongqing" | region == "Sichuan" | region == "Guizhou" | region == "Yunnan" | region == "Tibet" | region == "Shaanxi" | region == "Gansu" | region == "Qinghai" | region == "Ningxia" | region == "Xinjiang")
g northeast = (region == "Heilongjiang" | region == "Jilin" | region == "Liaoning") */
