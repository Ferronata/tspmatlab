function h = drawtrip(trip, color)
	global params;
	graph = plot(params.xy(:,2), params.xy(:,3), '*b');
	
	xytrip = [];
	for i = [1:size(trip,2)]
		xytrip = [xytrip; params.xy(trip(i), 2:3) ];
	end
	xytrip = [xytrip; params.xy(trip(1), 2:3) ];
	h = line(xytrip(:,1)',xytrip(:,2)', 'color', [0.8 0 0], 'linestyle','-','linewidth',2);
end


