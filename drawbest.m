function drawbest
	global params;
	params.xy = load('instancia_TSP.txt');
	params.dist = calcul_dist(params.xy);
	params.len = size(params.dist, 1);

	trip = load('opt.tour');
	trip = trip';
	trip
	
	drawtrip(trip, 'optimal trip');
end
