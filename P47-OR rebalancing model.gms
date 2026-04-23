
SETS
    i       Tasks /1*47/
    m       Main stations /1*10/
    s       Sub-stations /1*20/
    ORPT(i) 'Tasks with OR predecessors' /5,31,32,25,33,28,34,29,30,10,45,44,46,41/;


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


*Cycle time inital cycle time was 66 the minimim is 56
*the minimum is 60 for 1.96
Scalar CT /69/;
Scalar cost1 /2000/;
Scalar w1 /0.5/;
Scalar w2 /0.5/;
scalar z_alpha /1.96/;


* Task times for task i
Parameter mt(i)
/
1  5
2  11
3  18
4  4
5  12
6  7
7  8
8  18
9  1
10 15
11 7
12 1
13 16
14 6
15 6
16 7
17 18
18 8
19 15
20 3
21 16
22 11
23 8
24 6
25 5
26 1
27 10
28 17
29 11
30 4
31 4
32 20
33 20
34 19
35 7
36 16
37 4
38 18
39 17
40 9
41 9
42 15
43 15
44 19
45 7
46 5
47 2
/;

Parameter sigma(i)
/
1   1.25
2   2.75
3   4.5
4   1
5   3
6   1.75
7   2
8   4.5
9   0.25
10  3.75
11  1.75
12  0.25
13  4
14  1.5
15  1.5
16  1.75
17  4.5
18  2
19  3.75
20  0.75
21  4
22  2.75
23  2
24  1.5
25  1.25
26  0.25
27  2.5
28  4.25
29  2.75
30  1
31  1
32  5
33  5
34  4.75
35  1.75
36  4
37  1
38  4.5
39  4.25
40  2.25
41  2.25
42  3.75
43  3.75
44  4.75
45  1.75
46  1.25
47  0.5
/;

* AND Precedence relations
Parameter ANDP(i,j) 'AND precedence: task j must precede task i'
/
3.1 1
2.1 1
4.2 1
11.3 1
12.3 1
35.5 1
7.6 1
17.6 1
9.8 1
13.12 1
14.12 1
15.12 1
19.14 1
22.14 1
21.15 1
20.15 1
26.20 1
27.20 1
6.32 1
16.32 1
23.33 1
24.33 1
8.34 1
18.34 1
36.35 1
37.35 1
38.35 1
39.36 1
40.36 1
42.38 1
43.38 1
7.42 1
47.44 1
/;

* OR precedence relations 
Parameter ORP(i,j) 'OR precedence: task j is an OR predecesesor of task i'
/
5.4 1
5.11 1
31.4 1
31.3 1
32.5 1
32.13 1
25.19 1
25.21 1
33.16 1
33.22 1
34.7 1
34.23 1
28.24 1
28.25 1
28.26 1
29.27 1
29.17 1
30.29 1
30.18 1
30.28 1
10.30 1
10.9 1
41.39 1
41.37 1
44.38 1
44.40 1
44.41 1
46.40 1
46.43 1
45.42 1
45.37 1
/;
parameter initial_assignment(i,m);
initial_assignment('1','1') = 1;
initial_assignment('2','1') = 1;
initial_assignment('3','2') = 1;
initial_assignment('4','1') = 1;
initial_assignment('5','1') = 1;
initial_assignment('6','5') = 1;
initial_assignment('7','8') = 1;
initial_assignment('8','4') = 1;
initial_assignment('9','4') = 1;
initial_assignment('10','3') = 1;
initial_assignment('11','9') = 1;
initial_assignment('12','2') = 1;
initial_assignment('13','3') = 1;
initial_assignment('14','9') = 1;
initial_assignment('15','9') = 1;
initial_assignment('16','1') = 1;
initial_assignment('17','5') = 1;
initial_assignment('18','4') = 1;
initial_assignment('19','7') = 1;
initial_assignment('20','9') = 1;
initial_assignment('21','7') = 1;
initial_assignment('22','10') = 1;
initial_assignment('23','2') = 1;
initial_assignment('24','8') = 1;
initial_assignment('25','5') = 1;
initial_assignment('26','1') = 1;
initial_assignment('27','2') = 1;
initial_assignment('28','8') = 1;
initial_assignment('29','5') = 1;
initial_assignment('30','4') = 1;
initial_assignment('31','9') = 1;
initial_assignment('32','3') = 1;
initial_assignment('33','10') = 1;
initial_assignment('34','8') = 1;
initial_assignment('35','5') = 1;
initial_assignment('36','6') = 1;
initial_assignment('37','9') = 1;
initial_assignment('38','9') = 1;
initial_assignment('39','6') = 1;
initial_assignment('40','6') = 1;
initial_assignment('41','2') = 1;
initial_assignment('42','10') = 1;
initial_assignment('43','4') = 1;
initial_assignment('44','7') = 1;
initial_assignment('45','9') = 1;
initial_assignment('46','6') = 1;
initial_assignment('47','5') = 1;
Table cost2(i,m)
      1        2      3      4      5      6      7      8      9      10
1     0      1454   1454   1454   1454   1454   1454   1454   1454   1454
2     0      1058   1058   1058   1058   1058   1058   1058   1058   1058
3     1720   0      1720   1720   1720   1720   1720   1720   1720   1720
4     0      719    719    719    719    719    719    719    719    719
5     0      151    151    151    151    151    151    151    151    151
6     1322   1322   1322   1322   0      1322   1322   1322   1322   1322
7     1000   1000   1000   1000   1000   1000   1000   0      1000   1000
8     1065   1065   1065   0      1065   1065   1065   1065   1065   1065
9     1305   1305   1305   0      1305   1305   1305   1305   1305   1305
10    1104   1104   0      1104   1104   1104   1104   1104   1104   1104
11     494   494     494    494   494    494    494    494    0      494
12    1214    0     1214   1214   1214   1214   1214   1214   1214   1214
13    1788   1788   0      1788   1788   1788   1788   1788   1788   1788
14    1005   1005   1005   1005   1005   1005   1005   1005   0      1005
15    1579   1579   1579   1579   1579   1579   1579   1579   0      1579
16    0      1106   1106   1106   1106   1106   1106   1106   1106   1106
17    1670   1670   1670   1670   0      1670   1670   1670   1670   1670
18     737   737    737    0      737    737    737    737    737   737
19    1077   1077   1077   1077   1077  1077    0      1077   1077   1077
20    1490   1490   1490   1490   1490   1490   1490   1490   0     1490
21     473    473    473   473    473    473    0      473   473    473
22     563   563     563    563    563    563    563    563   563   0
23    1036   0      1036   1036   1036   1036   1036   1036   1036  1036
24     575   575     575    575    575   575    575    0      575   575
25    1330   1330    1330   1330   0     1330   1330   1330  1330   1330
26     0     673    673     673    673    673    673    673    673    673
27    1854   0      1854   1854   1854   1854   1854   1854   1854   1854
28     314   314    314    314    314    314    314    0      314   314
29    1392   1392   1392   1392   0      1392   1392   1392   1392  1392
30    1586   1586   1586   0      1586   1586   1586   1586   1586   1586
31    1523   1523   1523   1523   1523   1523   1523   1523   0      1523
32    538    538    0      538    538    538    538    538    538    538
33    1569   1569   1569   1569   1569   1569   1569   1569   1569   0
34     374    374    374   374    374    374    374    0      374    374
35    1148   1148   1148   1148   0      1148   1148   1148   1148   1148
36    1051   1051   1051   1051   1051   0      1051   1051   1051   1051
37    1832   1832   1832   1832   1832   1832   1832   1832   0      1832
38    1351   1351   1351   1351   1351   1351   1351   1351   0      1351
39    1614   1614   1614   1614   1614   0      1614   1614   1614   1614
40    1885   1885   1885   1885   1885   0      1885   1885   1885   1885
41    1364   0      1364   1364   1364   1364   1364   1364   1364   1364
42     197    197   197    197    197    197    197    197    197    0
43     958    958    958   0      958    958    958    958    958    958
44     909    909    909   909    909    909    0      909    909    909
45    1647   1647   1647   1647   1647   1647   1647   1647   0      1647
46    1679   1679   1679   1679   1679   0      1679   1679   1679   1679
47    802    802    802    802    0      802    802    802    802    802
;




 Binary Variables

    x(i,s)   * 1 if task i is assigned to sub-station s
    y(i,m)   * 1 if task i is assigned to main station m
    z(m)     * 1 if main station m is opened
    C(i,m)   * 1 if task i is relocated in the current period
   ;

* Continuous / positive variables
Variable obj;          
Positive Variable t(m); 

* Equations
Equations
  LinkAssignment
  c_constraint
  objective
  QuadConstraint(m)
  ChanceConstraint(m)
  TaskAssign(i)
  ANDPrecedence(i, j, s)
  ORPrecedence(i, s);

* Link x(i,s) and y(i,m)
LinkAssignment(i,m)..    y(i,m) =E= sum(s$(entrance_sub(m,s) or exit_sub(m,s)), x(i,s));

* Relocation cost indicator
c_constraint(i,m).. 
    C(i,m) =E= y(i,m)*(1 - initial_assignment(i,m));

* Objective
objective.. 
    obj =e= w1 * cost1 * sum(m, z(m)) + w2 * sum((i,m), cost2(i,m) * C(i,m));

* Quadratic relation: sum sigma^2 * x <= t(m)^2
QuadConstraint(m).. 
    sum((i,s)$(entrance_sub(m,s) or exit_sub(m,s)), (sigma(i)**2) * x(i,s)) =l= sqr(t(m));

* Chance constraint using t(m)
ChanceConstraint(m).. 
    sum((i,s)$(entrance_sub(m,s) or exit_sub(m,s)), mt(i) * x(i,s))
      + z_alpha * t(m) =l= CT * z(m) ;

* Task Assignment Constraint: Each task assigned to exactly one sub-station
TaskAssign(i).. sum(m, sum(s$(entrance_sub(m,s) or exit_sub(m,s)), x(i,s))) =e= 1;

* AND Precedence Constraint 
ANDPrecedence(i,j,s)$(ANDP(i,j)).. 
    x(i,s) =L= SUM(k$(processing_order(k) <= processing_order(s)), x(j, k));

* OR Precedence Constraint 
ORPrecedence(i,s)$(ORPT(i)).. 
    x(i,s) =L= Sum(j$ORP(i,j), SUM(k$(processing_order(k) <= processing_order(s)), x(j, k)));

* Model Definition
Model UDLBP /all/;

* Solver settings: set MIP solver that supports MIQCP (e.g., Gurobi or CPLEX)
option reslim = 10800; 
* Use the Gurobi MIP solver with QCP support if available:
option mip = gurobi;        
* Ensure Gurobi/Cplex solver is licensed and available.  

* Solve as MIQCP (mixed-integer quadratic-constrained program)
Solve UDLBP using MIQCP minimizing obj;

* Display Results
Display entrance_sub, exit_sub, processing_order, x.l, y.l, z.l, t.l, obj.l;
