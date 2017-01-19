include "globals.mzn";
include "gecode.mzn";

int : NBACTEURS = 11;
int : MAXSCENESJOURS = 5;

set of int : ACTEURS = 1..NBACTEURS;

int : PATT     = 1;
int : CASTA    = 2;
int : SCOLARO  = 3;
int : MURPHY   = 4;
int : BROWN    = 5;
int : HACKET   = 6;
int : ANDERSON = 7;
int : MCDOUGAL = 8;
int : MERCER   = 9;
int : SPRING   = 10;
int : THOMPSON = 11;

int : NBSCENES = 19;
set of int : SCENES = 1..NBSCENES;

array [SCENES] of set of ACTEURS : PARTICIPE =
[{HACKET},
 {PATT, HACKET, BROWN, MURPHY},
 {MCDOUGAL, SCOLARO, MERCER, BROWN},
 {CASTA, MERCER},
 {MERCER, ANDERSON, PATT, MCDOUGAL, SPRING},
 {THOMPSON, MCDOUGAL, ANDERSON, SCOLARO, SPRING},
 {CASTA, PATT},
 {MERCER, MURPHY},
 {CASTA, MCDOUGAL, MERCER, SCOLARO, THOMPSON},
 {CASTA, MCDOUGAL, SCOLARO, PATT},
 {PATT},
 {HACKET, THOMPSON, MCDOUGAL, MURPHY, BROWN},
 {HACKET, MURPHY, CASTA, PATT},
 {ANDERSON, SCOLARO},
 {THOMPSON, MURPHY, MCDOUGAL, PATT},
 {SCOLARO, MCDOUGAL, CASTA, MERCER},
 {SCOLARO, PATT, BROWN},
 {SCOLARO, MCDOUGAL, HACKET, THOMPSON},
 {CASTA}
];

array [ACTEURS] of int : PAYE = [25481, 25043, 30310, 4085, 7562, 9381, 8770, 5788, 7423, 3303, 9583];

int : NBJOURS = 4;
set of int : JOURS = 1..NBJOURS;

array [JOURS] of var set of ACTEURS : acteurs_par_jours;
array [JOURS] of var set of SCENES  : scenes_par_jours;

array [SCENES] of var JOURS : jour_de_scene;

var int : cout;


constraint partition_set(scenes_par_jours, SCENES);
constraint int_set_channel(jour_de_scene, scenes_par_jours);

%Pas plus de 5 scènes par jour
constraint forall(j in JOURS)( card(scenes_par_jours[j])<=MAXSCENESJOURS);

%briser les symetries
constraint forall (j in JOURS where j > 1)(
	   scenes_par_jours[j-1] < scenes_par_jours[j]
);

%on constitue le tableau regroupant tous les acteurs présents par jour
constraint forall(s in SCENES)(forall(a in ACTEURS where a in PARTICIPE[s])(a in acteurs_par_jours[jour_de_scene[s]]));

%calcul du coût
constraint cout = sum(j in JOURS)(sum(a in ACTEURS where a in acteurs_par_jours[j])( PAYE[a] ));
constraint cout < 335000;

%solve minimize(cout);
solve satisfy;

output["Scenes par jour : ",show(scenes_par_jours), "\nJour par scene : ", show(jour_de_scene), "\nActeurs presents par jour : ", show(acteurs_par_jours), "\nCout : ", show(cout)];