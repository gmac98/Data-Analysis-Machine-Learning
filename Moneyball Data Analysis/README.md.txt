Moneyball: Building a Winning Team Through Data Analysis

This project dives into the world of the Oakland Athletics' 2002 season, a groundbreaking chapter in baseball history. 
Billy Beane, the General Manager, faced a seemingly insurmountable challenge: building a competitive team with a shoestring budget compared to giants like the Yankees.
He took a different approach – sabermetrics. This data-driven strategy focused on a whole new set of statistics that painted a clearer picture of a player's true value.

Thanks to Michael Lewis's book "Moneyball," the world learned about their success in finding undervalued players. They weren't just using on-base percentage (OBP) and 
slugging percentage (SLG) – they were digging deeper. Here are three additional metrics that were crucial in their player evaluation:
- Walks (BB): Measures a player's ability to reach base without hitting the ball, indicating good plate discipline.
- Weighted On-Base Average (OBA): This advanced stat considers all ways a player reaches base (walks, hits, etc.) and assigns each a value based on its contribution to scoring runs.
- Fielding Runs Above Average (FRA): This metric goes beyond traditional fielding stats by estimating the number of runs a player saves or costs defensively compared 
to the average player at their position.

Now, here's the real challenge: the 2001-2002 offseason hit us hard. They lost key players like Jason Giambi (giambja01), Johnny Damon (damonjo01), 
and Jason Isringhausen ('saenzol01) to teams with much deeper pockets.

But here's the beauty of sabermetrics – it levels the playing field. This project is my mission to find replacements for these players using the power of data analysis. 

Project Goal and files -

My goal is to create an R-code that analyzes vast amounts of player data, identifying hidden gems that might be overlooked by traditional scouting.

The final deliverable will be a single file containing the R-code for the analysis, any visualizations created to showcase the data, and a detailed player 
replacement strategy based on the findings. This project aims to prove that even with limited resources, a data-driven approach can turn the underdog into a contender.

Steps -
1. Dataset imports
2. Exploratory data analysis
3. Feature Engineering
4. Visualizations
5. Strategy for player replacement
6. Find Top 3 potential recruits

Strategy for player replacement

 1. Salary Constraint: Total Salary <= $12 million
      Due to financial limitations, the three new athletes' combined salary must not be more than $12 million.
 2. On-Base Percentage (OBP) Constraint: OBP >= Lost Players' Mean OBP for 2000-01
      This considers both hits and walks, giving a better picture of a player's ability to reach base. As OA team 
      is focused on scoring runs, OBP is valuable as it leads to more scoring opportunities.
 3. Slugging Percentage (SLG): SLG >= Lost Players' Mean SLG for 2000-01
      This measures a player's extra-base hitting ability. While important, it shouldn't overshadow OBP. 
      We will focus on high OBP to get on base early, followed by SLG for run production.
 4. At Bats (AB) Constraint: AB >= Lost Players' At Bats for 2000-01
      At-bats represent opportunities to contribute, so ensuring the replacements had at least as many 
      combined at-bats aimed to maintain offensive output.

 TOP 3 REPLACEMENT RECRUITS

   playerID       OBP       SLG  AB        BA  salary
 1 heltoto01 0.4316547 0.6848382 587 0.3356048 4950000
 2 berkmla01 0.4302326 0.6204506 577 0.3310225  305000
 3 gonzalu01 0.4285714 0.6880131 609 0.3251232 4833333