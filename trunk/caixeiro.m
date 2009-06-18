function caixeiro
	global params
	params.xy = load('instancia_TSP.txt');
	dist = calcul_dist(params.xy);	
	params.dist = dist;
	params.len = size(dist,1);

	caixeiro_genetic(dist);
	%formiga(100);
end

function caixeiro_genetic(dist)
	ops.gen_pop_new= @genpopnew;
	ops.gen_mutate = @genmutate_new;
	ops.gen_combine = @gencombine;
	ops.gen_fitness = @fitness;
	ops.gen_localsearch = @gennullsearch;
	ops.combine_rate = 0.1;
	ops.mutate_rate = 0.1;

	pop = genetic_roleta(ops, 1000, 40);

	figure;
	drawtrip(pop{1,size(pop,2)}, 'best found');
	print('genetic_caixeiro_best.eps');
end

function dist = calcul_dist(ct)
	l = size(ct, 1);
	for c1 = [1:l]
		for c2 = [1:l]
			dist(c1,c2) = sqrt((ct(c1,2) - ct(c2,2))^2 + (ct(c1,3)-ct(c2,3))^2);
		end
	end
end

function a = genpopnew(quant)
	global params;
	a = cell(0);
	for i = [1:quant]
		a{i} = randperm(params.len);
	end;
end

	%max_mutations = 1; %size(a,2) / 100;	
	%nmut = min(ceil(rand()*max_mutations), size(a,2)/2);
	%mutar = randperm(size(a,2));
	%muta = mutar(1:nmut);
	%mutbr = randperm(size(a,2));
	%mutb = mutbr(1:nmut);

function a = genmutate(a)
	global params;
	muta = ceil(rand()*size(a,2));
	mutb = ceil(rand()*size(a,2));

	v  = a(muta);
	a(muta) = a(mutb);
	a(mutb) = v;
end


function a = rem_repeated(a) 
	h = hist(a, 1:length(a));
	
	while 1
		zero = find(h == 0);
		plus = find(h > 1);

		if (size(zero,2) == 0) 
			break;
		end

		rep = find(a == plus(1));

		zi = ceil(rand()*size(zero,2));
		pi = ceil(rand()*size(rep,2));
		
		a(rep(pi)) = zero(zi);

		h(plus(1)) = h(plus(1)) - 1;
		h(zero(zi)) = 1;
	end
end

function c = gencombine(a,b)
	global params;
	pti  = ceil(rand()*(size(a,2)-2)) + 1;

	c = [ a(1:pti) b((pti+1):size(a,2)) ];
	c = rem_repeated(c);
end

function f = fitness(a)
	global params;
	% calculates the total distance 
	d = params.dist(a(size(a,2)), a(1));
	for i = [2:size(a,2)]
		d = d  + params.dist(a(i-1), a(i));
	end
	f = -d;
end

function a = gennullsearch(a)
end
