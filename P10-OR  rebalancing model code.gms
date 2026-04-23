
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
  
*Cycle time, Station operating cost, cost weights, z_score, 
Scalar CT /45/;
Scalar cost1 /2000/;
Scalar w1 /0.8/;
Scalar w2 /0.2/;
scalar z_alpha /1.28/;

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

*Task relocation cost table of task i to main station m (Zero indicates task location at period p-1)
Table cost2(i,m)
     1       2       3       4       5       6       7       8       9       10     
1    0       1621    1621    1621    1621    1621    1621    1621    1621    1621 
2    0       1956    1956    1956    1956    1956    1956    1956    1956    1956    
3    0       1613    1613    1613    1613    1613    1613    1613    1613    1613    
4    684     0       684     684     684     684     684     684     684     684 
5    232     0       232     232     232     232     232     232     232     232    
6    301     301     301     0       301     301     301     301     301     301     
7    1562    1562    1562    1562    0       1562    1562    1562    1562    1562  
8    1713    1713    0       1713    1713    1713    1713    1713    1713    1713    
9    1355    1355    1355    0       1355    1355    1355    1355    1355    1355    
10   1075    1075    1075    0       1075    1075    1075    1075    1075    1075 


* Line memory, illustration of previous configurations
parameter assignment_memory(i,m);
assignment_memory('1','1') = 1;
assignment_memory('2','1') = 1;
assignment_memory('3','1') = 1;
assignment_memory('4','2') = 1;
assignment_memory('5','2') = 1;
assignment_memory('6','4') = 1;
assignment_memory('7','5') = 1;
assignment_memory('8','3') = 1;
assignment_memory('9','4') = 1;
assignment_memory('10','4') = 1;


* Binary Variables
Binary Variables
    x(i,s)   * 1 if task i is assigned to sub-station s
    y(i,m)   * 1 if task i is assigned to main station m
    z(m)     * 1 if main station m is opened
   C(i,m)    * 1 if task i is not assigned to the mth main station as in initial cycle time 0 otherwise
   ;
* Objective Function Variable
Variable obj;

* Equations
Equations
LinkAssignment
   c_constraint
    objective
CycleTime(m)
    TaskAssign(i)
    ANDPrecedence(i, j, s)
    ORPrecedence(i, s);

* Link x(i,s) and y(i,m)
LinkAssignment(i,m)..
    y(i,m) =E= sum(s$(entrance_sub(m,s) or exit_sub(m,s)), x(i,s));

* Relocation cost constraint
c_constraint(i,m).. 
    C(i,m) =E= (y(i,m) * (initial_assignment(i,m) = 0));

* Objective function: Minimize the rebalancing costs
objective.. 
    obj =e= w1 *cost1*sum(m,z(m)) +w2*sum((i,m), cost2(i,m)*C(i,m));

*CycleTime constraint with restricted variance summation
* i,s∑μi*(xi,s)+Z*(sqrt(i,s∑σi^2*(xi,s)) ≤ zm*CT

CycleTime(m)..
    sum((i,s)$(entrance_sub(m,s) or exit_sub(m,s)), (mt(i) + z_alpha*sigma(i)) * x(i,s)) =l= CT * z(m); 

TaskAssign(i)..
    sum(m, sum(s$(entrance_sub(m,s) or exit_sub(m,s)), x(i,s))) =e= 1;

* AND Precedence Constraint 
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

* Display Results
Display entrance_sub, exit_sub, processing_order,x.l, z.l, obj.l;

