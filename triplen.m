function d = triplen(a)
	global params;
	% calculates the total distance 
	d = params.dist(a(size(a,2)), a(1));
	for i = [2:size(a,2)]
		d = d  + params.dist(a(i-1), a(i));
	end
end


