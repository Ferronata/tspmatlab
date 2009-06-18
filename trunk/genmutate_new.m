function a = genmutate2(a)
	global params;
	n = size(a,2);
	k = ceil(rand()*3);
	ins_pts = sort(ceil(n*rand(1,2)));
      I = ins_pts(1);
	J = ins_pts(2);
	
	switch k
		case 1 % Flip
			a(I:J) = fliplr(a(I:J));
		case 2 % Swap
			a([I J]) = a([J I]);
		case 3 % Slide
			a(I:J) = a([I+1:J I]);
	end
end
