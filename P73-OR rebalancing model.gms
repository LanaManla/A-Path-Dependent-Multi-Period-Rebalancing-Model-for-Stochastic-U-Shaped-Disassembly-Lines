
SETS
    i       Tasks /1*73/
    m       Main stations /1*13/
    s       Sub-stations /1*26/
    ORPT(i) 'Tasks with OR predecessors' /7,8,12,18,21,54,57,59,24,25,34,33,32,58,45,46,43,44,70,67,72,71/;


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


*Cycle time inital cycle time was 66
Scalar CT /97/;
scalar cost1 /2000/;
Scalar w1 /0.5/;
Scalar w2 /0.5/
scalar z_alpha /1.96/;;

* Task times for task iS
Parameter mt(i)
/
1  18
2  4
3  12
4  2
5  5
6  18
7  9
8  16
9  7
10 3
11 2
12 5
13 8
14 18
15 11
16 16
17 2
18 18
19 20
20 12
21 4
22 10
23 17
24 9
25 5
26 10
27 6
28 6
29 10
30 13
31 18
32 8
33 16
34 4
35 19
36 9
37 10
38 3
39 20
40 11
41 17
42 3
43 16
44 2
45 8
46 9
47 19
48 5
49 4
50 13
51 14
52 12 
53 15
54 1
55 12 
56 18 
57 17
58 20
59 20
60 11
61 17
62 3
63 20
64 9
65 16
66 8
67 17
68 7
69 20
70 13
71 9
72 3
73 2
/;

Parameter sigma(i)
/
1   4.5
2   1
3   3
4   0.5
5   1.25
6   4.5
7   2.25
8   4
9   1.75
10  0.75
11  0.5
12  1.25
13  2
14  4.5
15  2.75
16  4
17  0.5
18  4.5
19  5
20  3
21  1
22  2.5
23  4.25
24  2.25
25  1.25
26  2.5
27  1.5
28  1.5
29  2.5
30  3.25
31  4.5
32  2
33  4
34  1
35  4.75
36  2.25
37  2.5
38  0.75
39  5
40  2.75
41  4.25
42  0.75
43  4
44  0.5
45  2
46  2.25
47  4.75
48  1.25
49  1
50  3.25
51  3.5
52  3
53  4.75
54  0.25
55  3
56  4.5
57  4.25
58  5
59  5
60  2.75
61  4.25
62  0.75
63  5
64  2.25
65  4
66  2
67  4.25
68  1.75
69  5
70  3.25
71  2.25
72  0.75
73  0.5
/;

* AND Precedence relations
Parameter ANDP(i,j) 'AND precedence: task j must precede task i'
/
3.1 1
2.1 1
4.2 1
5.3 1
6.3 1
9.6 1
10.6 1
11.6 1
48.6 1
11.49 1
35.8 1
13.10 1
14.10 1
15.11 1
29.11 1
16.12 1
17.12 1
41.12 1
19.17 1
20.17 1
40.17 1
55.18 1
23.21 1
22.21 1
26.24 1
27.24 1
28.26 1
30.29 1
31.29 1
50.29 1
52.30 1
53.31 1
61.33 1
58.33 1
36.35 1
37.35 1
38.35 1
39.36 1
40.36 1
41.37 1
42.37 1
19.39 1
24.43 1
34.45 1
64.45 1
47.46 1
33.46 1
26.47 1
49.48 1
50.48 1
51.48 1
52.50 1
53.50 1
55.51 1
56.51 1
60.57 1
25.59 1
32.60 1
62.61 1
63.61 1
64.61 1
65.62 1
66.62 1
68.63 1
69.63 1
73.67 1
/;

* OR precedence relations 
Parameter ORP(i,j) 'OR precedence: task j is an OR predecesesor of task i'
/
7.4 1
7.3 1
8.4 1
8.5 1
12.8 1
12.9 1
21.16 1
21.13 1
18.14 1
18.15 1
25.22 1
25.18 1
25.30 1
54.49 1
54.52 1
57.54 1
57.53 1
57.51 1
59.53 1
59.56 1
58.49 1
58.55 1
32.31 1
32.20 1
33.32 1
33.25 1
33.27 1
24.23 1
24.19 1
34.33 1
34.28 1
45.39 1
45.38 1
44.38 1
44.42 1
46.44 1
46.41 1
46.36 1
43.41 1
43.40 1
70.64 1
70.69 1
67.70 1
67.68 1
67.62 1
72.68 1
72.66 1
71.64 1
71.65 1
/;

parameter initial_assignment(i,m);
initial_assignment('1','1') = 1;
initial_assignment('2','1') = 1;
initial_assignment('3','2') = 1;
initial_assignment('4','1') = 1;
initial_assignment('5','12') = 1;
initial_assignment('6','2') = 1;
initial_assignment('7','8') = 1;
initial_assignment('8','1') = 1;
initial_assignment('9','13') = 1;
initial_assignment('10','13') = 1;
initial_assignment('11','4') = 1;
initial_assignment('12','1') = 1;
initial_assignment('13','9') = 1;
initial_assignment('14','11') = 1;
initial_assignment('15','13') = 1;
initial_assignment('16','7') = 1;
initial_assignment('17','1') = 1;
initial_assignment('18','8') = 1;
initial_assignment('19','5') = 1;
initial_assignment('20','5') = 1;
initial_assignment('21','8') = 1;
initial_assignment('22','9') = 1;
initial_assignment('23','7') = 1;
initial_assignment('24','3') = 1;
initial_assignment('25','9') = 1;
initial_assignment('26','3') = 1;
initial_assignment('27','3') = 1;
initial_assignment('28','1') = 1;
initial_assignment('29','4') = 1;
initial_assignment('30','4') = 1;
initial_assignment('31','9') = 1;
initial_assignment('32','4') = 1;
initial_assignment('33','10') = 1;
initial_assignment('34','1') = 1;
initial_assignment('35','2') = 1;
initial_assignment('36','2') = 1;
initial_assignment('37','12') = 1;
initial_assignment('38','12') = 1;
initial_assignment('39','13') = 1;
initial_assignment('40','3') = 1;
initial_assignment('41','6') = 1;
initial_assignment('42','4') = 1;
initial_assignment('43','3') = 1;
initial_assignment('44','12') = 1;
initial_assignment('45','7') = 1;
initial_assignment('46','3') = 1;
initial_assignment('47','11') = 1;
initial_assignment('48','2') = 1;
initial_assignment('49','4') = 1;
initial_assignment('50','6') = 1;
initial_assignment('51','6') = 1;
initial_assignment('52','4') = 1;
initial_assignment('53','9') = 1;
initial_assignment('54','1') = 1;
initial_assignment('55','8') = 1;
initial_assignment('56','6') = 1;
initial_assignment('57','12') = 1;
initial_assignment('58','13') = 1;
initial_assignment('59','7') = 1;
initial_assignment('60','5') = 1;
initial_assignment('61','10') = 1;
initial_assignment('62','10') = 1;
initial_assignment('63','5') = 1;
initial_assignment('64','11') = 1;
initial_assignment('65','12') = 1;
initial_assignment('66','10') = 1;
initial_assignment('67','10') = 1;
initial_assignment('68','5') = 1;
initial_assignment('69','8') = 1;
initial_assignment('70','5') = 1;
initial_assignment('71','12') = 1;
initial_assignment('72','4') = 1;
initial_assignment('73','1') = 1;
Table cost2(i,m)
     1       2       3       4       5       6       7       8       9       10      11      12     13
1    0       1621    1621    1621    1621    1621    1621    1621    1621    1621    1621    1621    1621
2    0       1956    1956    1956    1956    1956    1956    1956    1956    1956    1956    1956    1956
3    1613    0       1613    1613    1613    1613    1613    1613    1613    1613    1613    1613    1613
4    0       684     684     684     684     684     684     684     684     684     684     684     684
5    232     232     232     232     232     232     232     232     232     232     232     0       232
6    301     0       301     301     301     301     301     301     301     301     301     301     301
7    1562    1562    1562    1562    1562    1562    1562    0       1562    1562    1562    1562    1562
8    0       1713    1713    1713    1713    1713    1713    1713    1713    1713    1713    1713    1713
9    1355    1355    1355    1355    1355    1355    1355    1355    1355    1355    1355    1355    0
10   1075    1075    1075    1075    1075    1075    1075    1075    1075    1075    1075    1075    0
11   1798    1798    1798    0       1798    1798    1798    1798    1798    1798    1798    1798    1798
12   0       1595    1595    1595    1595    1595    1595    1595    1595    1595    1595    1595    1595
13   1301    1301    1301    1301    1301    1301    1301    1301    0       1301    1301    1301    1301
14   895     895     895     895     895     895     895     895     895     895     0       895     895
15   1553    1553    1553    1553    1553    1553    1553    1553    1553    1553    1553    1553    0
16   1427    1427    1427    1427    1427    1427    0       1427    1427    1427    1427    1427    1427
17   0       941     941     941     941     941     941     941     941     941     941     941     941
18   1878    1878    1878    1878    1878    1878    1878    0       1878    1878    1878    1878    1878
19   1105    1105    1105    1105    0       1105    1105    1105    1105    1105    1105    1105    1105
20   577     577     577     577     0       577     577     577     577     577     577     577     577
21   211     211     211     211     211     211     211     0        211     211     211     211     211
22   1907    1907    1907    1907    1907    1907    1907    1907    0       1907    1907    1907    1907
23   1669    1669    1669    1669    1669    1669    0       1669    1669    1669    1669    1669    1669
24   684     684     0       684     684     684     684     684     684     684     684     684     684
25   232     232     232     232     232     232     232     232     0       232     232     232     232
26   232     232     0       232     232     232     232     232     232     232     232     232     232
27   301     301     0       301     301     301     301     301     301     301     301     301     301
28   0       1562    1562    1562    1562    1562    1562    1562    1562    1562    1562    1562    1562
29   1713    1713    1713    0       1713    1713    1713    1713    1713    1713    1713    1713    1713
30   1355    1355    1355    0       1355    1355    1355    1355    1355    1355    1355    1355    1355
31   1075    1075    1075    1075    1075    1075    1075    1075    0       1075    1075    1075    1075
32   1798    1798    1798    0       1798    1798    1798    1798    1798    1798    1798    1798    1798
33   1595    1595    1595    1595    1595    1595    1595    1595    1595    0       1595    1595    1595
34   0       1301    1301    1301    1301    1301    1301    1301    1301    1301    1301    1301    1301
35   895     0       895     895     895     895     895     895     895     895     895     895     895
36   1553    0       1553    1553    1553    1553    1553    1553    1553    1553    1553    1553    1553
37   1427    1427    1427    1427    1427    1427    1427    1427    1427    1427    1427    0       1427
38   941     941     941     941     941     941     941     941     941     941     941     0       941
39   1878    1878    1878    1878    1878    1878    1878    1878    1878    1878    1878    1878    0
40   1105    1105    0       1105    1105    1105    1105    1105    1105    1105    1105    1105    1105
41   577     577     577     577     577     0       577     577     577     577     577     577     577
42   211     211     211     0       211     211     211     211     211     211     211     211     211
43   1907    1907    0       1907    1907    1907    1907    1907    1907    1907    1907    1907    1907
44   1669    1669    1669    1669    1669    1669    1669    1669    1669    1669    1669    0       1669
45   684     684     684     684     684     684     0       684     684     684     684     684     684
46   232     232     0       232     232     232     232     232     232     232     232     232     232
47   301     301     301     301     301     301     301     301     301     301     0       301     301
48   1562    0       1562    1562    1562    1562    1562    1562    1562    1562    1562    1562    1562
49   1713    1713    1713    0       1713    1713    1713    1713    1713    1713    1713    1713    1713
50   1355    1355    1355    1355    1355    0       1355    1355    1355    1355    1355    1355    1355
51   1075    1075    1075    1075    1075    0       1075    1075    1075    1075    1075    1075    1075
52   1798    1798    1798    0       1798    1798    1798    1798    1798    1798    1798    1798    1798
53   1595    1595    1595    1595    1595    1595    1595    1595    0       1595    1595    1595    1595
54   0       1301    1301    1301    1301    1301    1301    1301    1301    1301    1301    1301    1301
55   895     895     895     895     895     895     895     0       895     895     895     895     895
56   1553    1553    1553    1553    1553    0       1553    1553    1553    1553    1553    1553    1553
57   1427    1427    1427    1427    1427    1427    1427    1427    1427    1427    1427    0       1427
58   941     941     941     941     941     941     941     941     941     941     941     941     0
59   1878    1878    1878    1878    1878    1878    0       1878    1878    1878    1878    1878    1878
60   1105    1105    1105    1105    0       1105    1105    1105    1105    1105    1105    1105    1105
61   577     577     577     577     577     577     577     577     577     0       577     577     577
62   211     211     211     211     211     211     211     211     211     0       211     211     211
63   1907    1907    1907    1907    1907    1907    1907    1907    1907    1907    0       1907    1907
64   1669    1669    1669    0       1669    1669    1669    1669    1669    1669    1669    1669    1669
65   684     684     684     684     684     684     684     684     684     684     684     0       684
66   232     232     232     232     232     232     232     232     232     0       232     232     232
67   301     301     301     301     301     301     301     301     301     0       301     301     301
68   1562    1562    1562    1562    0       1562    1562    1562    1562    1562    1562    1562    1562
69   1713    1713    1713    1713    1713    1713    1713    0       1713    1713    1713    1713    1713
70   1355    1355    1355    1355    0       1355    1355    1355    1355    1355    1355    1355    1355
71   1075    1075    1075    1075    1075    1075    1075    1075    1075    1075    1075    0       1075
72   1798    1798    1798    0       1798    1798    1798    1798    1798    1798    1798    1798    1798
73   0       1595    1595    1595    1595    1595    1595    1595    1595    1595    1595    1595    1595
;


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
    ORPrecedence(i,s);

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

* --- Linearized Cycle Time Constraint --- *
CycleTime(m)..
    sum((i,s)$(entrance_sub(m,s) or exit_sub(m,s)), (mt(i) + z_alpha*sigma(i)) * x(i,s)) =l= CT * z(m); 

* Task Assignment Constraint: Each task assigned to exactly one sub-station

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


