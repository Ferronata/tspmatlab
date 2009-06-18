function dist = calcul_dist(ct)
	l = size(ct, 1);
	for c1 = [1:l]
		for c2 = [1:l]
			dist(c1,c2) = sqrt((ct(c1,2) - ct(c2,2))^2 + (ct(c1,3)-ct(c2,3))^2);
		end
	end
end;


