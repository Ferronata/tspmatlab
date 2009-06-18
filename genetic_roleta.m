function pop = genetic_roleta(ops, num_iter, pop_size)
	ops.max_pop_size = 2 * pop_size;
	pop = ops.gen_pop_new(pop_size);
	
	% performs an initial local search on the population
	pop = cellfun(ops.gen_localsearch, pop, 'UniformOutput', false);
	
	% calculates the initial fitness
	pop = fitnesses(pop, ops);
	
	bests = [];
	averages = [];
	best_compact = [];
	b = 0;
	for i = [1:num_iter]
		bold = b;
		[pop, b, a] = genstep(pop, ops);
		bests = [bests b];
		if (bold ~= b)
			best_compact = [ best_compact; i int32(b) size(pop,2) ];
		end
		averages = [averages a];
		current_best = b
		current_indx = i
		populationsz =  size(pop,2)
	end
	[pop, b, a] = sortpop(pop);

	best_compact
	plot(bests, 'b');
	hold on;
	plot(averages, 'r');
	hold off;
	print('genetic_evolution.eps');

	save 'genetic_best_log.txt' best_compact;
	save 'genetic_bests.txt' bests;
	save 'genetic_averages.txt' averages;
	best = pop{1,size(pop,2)};
    best
	save 'genetic_bestgen.txt' best;
	save 'genetic_params.txt' ops;
end 

function [pop, best, average] = sortpop(pop)
	% sort population by fitness
	f = cell2mat(pop(2,:));
	l = size(f, 2);
	[s, i] = sort(f);
	pop = pop([1 2], i);

	% the statistics for the initial population
	best = s(l);
	average = sum(s) / l;
end

% runs the roleta n times; assumes fits >= 0
function ci = roleta(fits, n)
    fits = 1./-fits;
	cs = cumsum(fits);
	scale = cs(size(fits,2));
	ci = [];
	for i = [1:n]
		r = rand()*scale;
		ci(i) = find(cs >= r, 1);
	end;
end

function [pop, best, average] = genstep(pop, ops)
	% selects the parents 
    len = size(pop, 2);
	fits = cell2mat(pop(2,:));
	isel = roleta(fits, 2*len);
	% performs the recombinations
	for i = 1:len
		% the parents x and y
        isel1 = isel(2*i - 1);
		isel2 = isel(2*i);
		ind1 = pop{1,isel1};
		ind2 = pop{1,isel2};
		% reproduce, creating offsprings x2,y2
		x2 = ops.gen_combine(ind1, ind2);
        y2 = ops.gen_combine(ind2, ind1);
		% mutate the offspring
		x2 = ops.gen_mutate(x2);
		y2 = ops.gen_mutate(y2);
		% calculates the new fitnes
		fx = ops.gen_fitness(x2);
		fy = ops.gen_fitness(y2);
		% competition
		ix = find(fits < fx, 1);
		iy = find(fits < fy, 1);
		% reinsert into the right position
		pop(2,ix) = {fx};
		pop(1,ix) = {x2};
		pop(2,iy) = {fy};
		pop(1,iy) = {y2};
	end;

	% recalculates the population 
	[pop, best, average] = sortpop(pop);
end

function pop = fitnesses(pop,ops)
	pop(2,:) = cellfun(ops.gen_fitness, pop(1,:), 'UniformOutput', false);
end
	
function r = random_low(n, maxx)
	r  = rand(1,n);
	r = floor((r .* r) .* (maxx-1) + 1);
end
function r = random_hi(n, maxx)
	r = rand(1,n);
	r = floor((1 - r .* r) .* (maxx-1) + 1);
end
function r = random_lin(n, nax)
	r = rand(1,n);
	r = floor(r .* (max - 1) + 1);
end

