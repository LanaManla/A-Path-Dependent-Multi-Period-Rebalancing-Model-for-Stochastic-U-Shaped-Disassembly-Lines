
SETS
    i       Tasks /1*22/
    m       Main stations /1*10/
    s       Sub-stations /1*20/
    ORPT(i) 'Tasks with OR predecessors' /16,21,22,10,15,18,17/;


alias (i,j);
alias (s,k);


* Map main stations to entrance and exit sub-stations
SET entrance_sub(m,s) 'Entrance sub-station for main station m, s=m';
entrance_sub(m,s) = yes$(ord(s) = ord(m));

SET exit_sub(m,s) 'Exit sub-station for main station m, s=2*M+1-m';
exit_sub(m,s) = yes$(ord(s) = 2*card(m) + 1 - ord(m));

* U-shaped processing order: entrance 1-12 (ascending), exit 13-24 (main stations 12→1)
Parameter processing_order(s) 'Order of sub-stations in U-shaped flow';
processing_order(s) = ord(s);


*Cycle time inital cycle time was 39 the minimum is 29
Scalar CT /50/;
Scalar cost1 /2000/;
Scalar w1 /0.5/;
Scalar w2 /0.5/;
scalar z_alpha /1.96/;

* Task times for task i
Parameter mt(i)
/
1  10
2  6
3  12
4  17
5  9
6  19
7  9
8  15
9  6
10 11
11 1
12 19
13 12
14 6
15 4
16 17
17 10
18 6
19 16
20 7
21 14
22 19
/;

Parameter sigma(i)
/
1   1
2   0.6
3   1.2
4   1.7
5   0.9
6   1.9
7   0.9
8   1.5
9   0.6
10  1.1
11  0.1
12  1.9
13  1.2
14  0.6
15  0.4
16  1.7
17  1
18  0.6
19  1.6
20  0.7
21  1.4
22  1.9

/;

* AND Precedence relations
Parameter ANDP(i,j) 'AND precedence: task j must precede task i'
/
3.1 1
2.1 1
11.2 1
12.2 1
4.3 1
8.5 1
9.5 1
13.7 1
14.7 1
20.12 1
19.15 1
5.22 1
6.22 1
7.22 1
/;

* OR precedence relations 
Parameter ORP(i,j) 'OR precedence: task j is an OR predecesesor of task i'
/
16.4 1
22.4 1
22.2 1
16.11 1
21.16 1
21.12 1
10.6 1
10.8 1
15.10 1
15.9 1
15.7 1
18.9 1
18.14 1
17.6 1
17.13 1
/;

Table cost2(i,m)
    1      2      3      4      5      6      7      8      9      10
1   0     560    560    560    560    560    560    560    560    560
2   0     1400   1400   1400   1400   1400   1400   1400   1400   1400
3   580   580    580     580    0     580    580    580    580    580
4   1619  0      1619    1619  1619   1619   1619   1619   1619   1619
5   1957  1957   1957    0     1957   1957   1957   1957   1957   1957
6   1624  1624   1624    1624   1624  1624    1624   1624   1624   0
7   1544  1544   1544    0      1544   1544   1544   1544   1544   1544
8   1971  1971   1971    1971   0      1971   1971   1971   1971   1971
9   1018  1018   1018    1018   1018   0      1018   1018   1018   1018
10  236   236    236     236    236    236    236    236    236    0 
11  1354  1354   1354    0      1354   1354   1354   1354   1354   1354
12  608   608    608     608    608    608    608    608    0      608
13  1330  0      1330    1330   1330   1330   1330   1330   1330   1330
14  595   595    595     0      595    595    595    595    595    595
15  874   874    0       874    874    874    874    874    874    874
16  1326  1326   1326    1326   1326   0      1326   1326   1326   1326
17  171   171    171     171    0      171    171    171    171    171
18  176   176    176     176    176    0      176    176    176    176
19  0     1307   1307    1307   1307   1307   1307   1307   1307   1307
20  527   527    527     0      527    527    527    527    527     527
21  730   730    730     730    730    730    730    730    0       730
22  425   425    0       425    425    425    425    425    425     425
;


parameter initial_assignment(i,m);
initial_assignment('1','1') = 1;
initial_assignment('2','1') = 1;
initial_assignment('3','5') = 1;
initial_assignment('4','2') = 1;
initial_assignment('5','4') = 1;
initial_assignment('6','10') = 1;
initial_assignment('7','4') = 1;
initial_assignment('8','5') = 1;
initial_assignment('9','6') = 1;
initial_assignment('10','10') = 1;
initial_assignment('11','4') = 1;
initial_assignment('12','9') = 1;
initial_assignment('13','2') = 1;
initial_assignment('14','4') = 1;
initial_assignment('15','3') = 1;
initial_assignment('16','6') = 1;
initial_assignment('17','5') = 1;
initial_assignment('18','6') = 1;
initial_assignment('19','1') = 1;
initial_assignment('20','4') = 1;
initial_assignment('21','9') = 1;
initial_assignment('22','3') = 1;

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


