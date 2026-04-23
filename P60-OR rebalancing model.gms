SETS
    i       Tasks /1*60/
    m       Main stations /1*12/
    s       Sub-stations /1*24/
    ORPT(i) 'Tasks with OR predecessors' /7,8,12,18,21,54,57,59,24,25,34,33,32,58,45,46,43,44/;


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


*Cycle time inital cycle time was 66 the minimum is 52
Scalar CT /79/;
Scalar cost1 /2000/;
Scalar w1 /0.5/;
Scalar w2 /0.5/;
scalar z_alpha /1.96/;

* Task times for task i
Parameter mt(i)
/
1  6
2  18
3  8
4  2
5  14
6  16
7  11
8  13
9  17
10 3
11 14
12 2
13 1
14 3
15 3
16 18
17 8
18 1
19 2
20 5
21 13
22 12
23 16
24 7
25 8
26 2
27 18
28 1
29 13
30 9
31 13
32 13
33 15
34 11
35 1
36 17
37 6
38 5
39 7
40 8
41 6
42 5
43 11
44 10
45 1
46 11
47 4
48 6
49 15
50 18
51 7
52 9 
53 15
54 20
55 10 
56 3 
57 15
58 4
59 13
60 7
/;

Parameter sigma(i)
/
1 1.5
2   4.5
3   2
4   0.5
5   3.5
6   4
7   2.75
8   3.25
9   4.25
10  0.75
11  3.5
12  0.5
13  0.25
14  0.75
15  0.75
16  4.5
17  2
18  0.25
19  0.5
20  1.25
21  3.25
22  3
23  4
24  1.75
25  2
26  0.5
27  4.5
28  0.25
29  3.25
30  2.25
31  3.25
32  3.25
33  3.75
34  2.75
35  0.25
36  4.25
37  1.5
38  1.25
39  1.75
40  2
41  1.5
42  1.25
43  2.75
44  2.5
45  0.25
46  2.75
47  1
48  1.5
49  3.75
50  4.5
51  1.75
52  2.25
53  3.75
54  5
55  2.5
56  0.75
57  3.75
58  1
59  3.25
60  1.75

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
11.49 1
48.6 1
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
47.46 1
33.46 1
26.47 1
49.48 1
50.48 1
50.29 1
51.48 1
52.50 1
52.30 1
53.50 1
53.31 1
55.51 1
56.51 1
60.57 1
25.59 1
32.60 1
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
/;

parameter initial_assignment(i,m);
initial_assignment('1','1') = 1;
initial_assignment('2','1') = 1;
initial_assignment('3','2') = 1;
initial_assignment('4','1') = 1;
initial_assignment('5','12') = 1;
initial_assignment('6','5') = 1;
initial_assignment('7','5') = 1;
initial_assignment('8','1') = 1;
initial_assignment('9','8') = 1;
initial_assignment('10','6') = 1;
initial_assignment('11','10') = 1;
initial_assignment('12','2') = 1;
initial_assignment('13','7') = 1;
initial_assignment('14','3') = 1;
initial_assignment('15','3') = 1;
initial_assignment('16','7') = 1;
initial_assignment('17','2') = 1;
initial_assignment('18','3') = 1;
initial_assignment('19','6') = 1;
initial_assignment('20','3') = 1;
initial_assignment('21','11') = 1;
initial_assignment('22','10') = 1;
initial_assignment('23','8') = 1;
initial_assignment('24','5') = 1;
initial_assignment('25','3') = 1;
initial_assignment('26','3') = 1;
initial_assignment('27','4') = 1;
initial_assignment('28','3') = 1;
initial_assignment('29','10') = 1;
initial_assignment('30','12') = 1;
initial_assignment('31','6') = 1;
initial_assignment('32','8') = 1;
initial_assignment('33','6') = 1;
initial_assignment('34','6') = 1;
initial_assignment('35','1') = 1;
initial_assignment('36','9') = 1;
initial_assignment('37','1') = 1;
initial_assignment('38','3') = 1;
initial_assignment('39','9') = 1;
initial_assignment('40','5') = 1;
initial_assignment('41','2') = 1;
initial_assignment('42','6') = 1;
initial_assignment('43','2') = 1;
initial_assignment('44','11') = 1;
initial_assignment('45','3') = 1;
initial_assignment('46','2') = 1;
initial_assignment('47','3') = 1;
initial_assignment('48','9') = 1;
initial_assignment('49','9') = 1;
initial_assignment('50','7') = 1;
initial_assignment('51','10') = 1;
initial_assignment('52','7') = 1;
initial_assignment('53','4') = 1;
initial_assignment('54','11') = 1;
initial_assignment('55','3') = 1;
initial_assignment('56','3') = 1;
initial_assignment('57','12') = 1;
initial_assignment('58','5') = 1;
initial_assignment('59','4') = 1;
initial_assignment('60','12') = 1;

Table cost2(i,m)
           1      2      3      4      5      6      7      8      9     10     11     12
1          0   1984   1984   1984   1984   1984   1984   1984   1984   1984   1984   1984
2          0   1011   1011   1011   1011   1011   1011   1011   1011   1011   1011   1011
3        152   0      152    152    152    152    152    152    152    152    152    152
4          0   1287   1287   1287   1287   1287   1287   1287   1287   1287   1287   1287
5        419    419    419    419    419    419    419   419    419    419    419    0
6        645    645    645    645    0      645    645    645   645    645    645    645
7       1771   1771   1771   1771     0     1771   1771   1771   1771   1771   1771   1771
8          0   1659   1659   1659   1659   1659   1659   1659   1659   1659   1659   1659
9        349    349    349    349    349    349    349    0      349    349    349    349
10       783    783    783    783    783    0      783    783    783    783    783    783
11       507    507    507    507    507    507    507    507    507    0      507    507
12       813    0      813    813    813    813    813    813    813    813    813    813
13       628    628    628    628    628    628    0      628    628    628    628    628
14      1507   1507      0   1507   1507   1507   1507   1507   1507   1507   1507   1507
15      1545   1545      0   1545   1545   1545   1545   1545   1545   1545   1545   1545
16       436    436    436    436    436    436    0      436    436    436    436    436
17       918      0    918    918    918    918    918    918    918    918    918    918
18       834    834      0    834    834    834    834    834    834    834    834    834
19      1339   1339   1339   1339   1339   0      1339   1339   1339   1339   1339   1339
20      1112   1112      0   1112   1112   1112   1112   1112   1112   1112   1112   1112
21       455    455    455    455    455    455    455    455    455    455    0      455
22       267    267    267    267    267    267    267    267    267    0      267    267
23       592    592    592    592    592    592    592    0      592    592    592    592
24       538    538    538    538    0      538    538    538    538    538    538    538
25       948    948      0    948    948    948    948    948    948    948    948    948
26      1687   1687      0   1687   1687   1687   1687   1687   1687   1687   1687   1687
27       851    851    851    0      851    851    851    851    851    851    851    851
28       677    677      0    677    677    677    677    677    677    677    677    677
29      1351   1351   1351   1351   1351   1351   1351   1351   1351   0      1351   1351
30      1783   1783   1783   1783   1783   1783   1783   1783   1783   1783   1783   0
31      1349   1349   1349   1349   1349      0   1349   1349   1349   1349   1349   1349
32       400    400    400    400    400    400    400    0      400   400     400    400
33      1518   1518   1518   1518   1518      0   1518   1518   1518   1518   1518   1518
34      1128   1128   1128   1128   1128      0   1128   1128   1128   1128   1128   1128
35         0   1475   1475   1475   1475   1475   1475   1475   1475   1475   1475   1475
36       914    914    914    914    914    914    914    914    0      914    914    914
37         0    619    619    619    619    619    619    619    619    619    619    619
38      1027   1027      0   1027   1027   1027   1027   1027   1027   1027   1027   1027
39       378    378    378    378    378    378    378    378    0      378    378    378
40      1841   1841   1841   1841      0   1841   1841   1841   1841   1841   1841   1841
41      1866      0   1866   1866   1866   1866   1866   1866   1866   1866   1866   1866
42      1964   1964   1964   1964   1964      0   1964   1964   1964   1964   1964   1964
43       801      0    801    801    801    801    801    801    801    801    801    801
44       952    952    952    952    952    952    952    952    952    952    0      952
45      1085   1085      0   1085   1085   1085   1085   1085   1085   1085   1085   1085
46       861      0    861    861    861    861    861    861    861    861    861    861
47       385    385      0    385    385    385    385    385    385    385    385    385
48       612    612    612    612    612    612    612    612    0      612    612    612
49       725    725    725    725    725    725    725    725    0      725    725    725
50      1079   1079   1079   1079   1079   1079      0   1079   1079   1079   1079   1079
51      1724   1724   1724   1724   1724   1724   1724   1724   1724   0      1724   1724
52       182    182    182    182    182    182    0      182    182    182    182    182
53       585    585    585    0      585    585    585    585    585    585    585    585
54       351    351    351    351    351    351    351    351    351    351    0      351
55       235    235    0      235    235    235    235    235    235    235    235    235
56      1981   1981      0   1981   1981   1981   1981   1981   1981   1981   1981   1981
57      1062   1062   1062   1062   1062   1062   1062   1062   1062   1062   1062   0
58      1000   1000   1000   1000      0   1000   1000   1000   1000   1000   1000   1000
59       800    800    800    0      800    800    800    800    800    800    800    800
60      1870   1870   1870   1870   1870   1870   1870   1870   1870   1870   1870   0
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


