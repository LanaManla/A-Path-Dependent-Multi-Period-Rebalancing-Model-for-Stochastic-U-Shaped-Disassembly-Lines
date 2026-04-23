
SETS
    i       Tasks /1*10/
    m       Main stations /1*10/
    s       Sub-stations /1*20/
    ORPT(i) 'Tasks with OR predecessors' /1,9,8,10/
;

alias (i,j);
alias (s,k);

* Map main stations to entrance and exit sub-stations
SET entrance_sub(m,s) 'Entrance sub-station for main station m, s=m';
entrance_sub(m,s) = yes$(ord(s) = ord(m));

SET exit_sub(m,s) 'Exit sub-station for main station m, s=2*M+1-m';
exit_sub(m,s) = yes$(ord(s) = 2*card(m) + 1 - ord(m));

* Define U-shaped processing order 
Parameter processing_order(s) 'Order of sub-stations in U-shaped flow';
processing_order(s) =
    sum(m$(entrance_sub(m,s)), ord(m))       
  + sum(m$(exit_sub(m,s)), 2*card(m) - ord(m) + 1);
  
*Cycle time the minimum is 41 
Scalar CT /60/;

* Mean Task times for task i
Parameter mt(i)
/
1  14
2  10
3  12
4  18
5  23
6  16
7  20
8  36
9  14
10 10
/;

* Variance of Task times for task i for (CV)(0.10 as low and 0.25 as high)
*Low CV values
Parameter sigma(i)
/
1   3.5
2   2.5
3   3
4   4.5
5   5.75
6   4
7   5
8   9
9   3.5
10  2.5
/;


* AND Precedence relations
Parameter ANDP(i,j) 'AND precedence: task j must precede task i'
/
7.8 1
4.8 1
5.7 1
6.7 1
/;

* OR precedence relations 
Parameter ORP(i,j) 'OR precedence: task j is an OR predecesesor of task i'
/
1.2 1
9.2 1
8.2 1
10.2 1
1.3 1
9.3 1
8.3 1
10.3 1
/;

* Binary Variables
Binary Variables
    x(i,s)   * 1 if task i is assigned to sub-station s
    z(m)     * 1 if main station m is opened;

* Objective Function Variable
Variable obj;

* Equations
Equations
    objective
    CycleTime(m)
    TaskAssign(i)
    ANDPrecedence(i, j, s)
    ORPrecedence(i, s);

* Objective function: Minimize opened stations
objective.. 
    obj =e= sum(m, z(m));

* Cycle Time Constraint: Total time at main station m (entrance + exit) ≤ CT
CycleTime(m)..
    sum((i,s)$(entrance_sub(m,s) or exit_sub(m,s)), mt(i)* x(i,s)) =l= CT * z(m); 

* Task Assignment Constraint: Each task assigned to exactly one sub-station
TaskAssign(i)..
    sum(m, sum(s$(entrance_sub(m,s) or exit_sub(m,s)), x(i,s))) =e= 1;

* AND Precedence Constraint (Paper’s Equation 4)
ANDPrecedence(i,j,s)$(ANDP(i,j)).. 
    x(i,s) =L= SUM(k$(processing_order(k) <= processing_order(s)), x(j, k));

* OR Precedence Constraint 
ORPrecedence(i,s)$(ORPT(i)).. 
    x(i,s) =L= Sum(j$ORP(i,j), SUM(k$(processing_order(k) <= processing_order(s)), x(j, k)));
    
* Model Definition
Model UDLBP /all/;

* Solver settings
option optcr = 0.0;     
option reslim = 3600; 
* Solve Model
Solve UDLBP using MINLP minimizing obj;
* Display results
Display entrance_sub, exit_sub, processing_order,x.l, z.l, obj.l;
