**Pacejka4_Model.m** contains code that returns a lateral force, given a slip angle and normal load on the tire. The model used is a 4 term Pacejka model, also referred to Pacejka-lite in certain documents in this repo
* The equation for the lateral force in this model is : 
$F_y = (P_1 + P_2/1000 * load) * load * sin(P_4 * atan(P_3 * slip_angle))$
