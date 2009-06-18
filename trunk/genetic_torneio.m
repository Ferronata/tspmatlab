function pop = genetic_torneio(ops, num_iter, pop_size)
	ops.max_pop_size = 2 * pop_size;
	pop = ops.gen_pop_new(pop_size);
	
	% performs an initial local search on the population
	pop = cellfun(ops.gen_localsearch, pop, "UniformOutput", false);
	
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
		if (bold != b)
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

function [pop, best, average] = genstep(pop, ops)
	[pop, best, average] = sortpop(pop);
	l = size(pop,2);

	% seleciona por torneio 
	isels = [];

	numsel = l/3;

	for i = 1:numsel
		% escolhe dois individuos para competir 
		i1 = ceil(rand()*l);
		i2 = ceil(rand()*l);
		% qual tem maior fitness?
		f1 = pop{2,i1};
		f2 = pop{2,i2};
		if (f1 > f2)
			imax = i1;
		else
			imax = i2;
		end;

		isels = [isels imax];
	end

	% nova populacao
	pop2 = cell(0);

	for i = 1:l/2
		% escolhe 2 individuos quaisquer entre os escolhidos
		i1 = ceil(rand()*length(isels));
		i2 = ceil(rand()*length(isels));
		isel1 = isels(i1);
		isel2 = isels(i2);
		ind1 = pop{1,isel1};
		ind2 = pop{1,isel2};
		fit1 = pop{2,isel1};
		fit2 = pop{2,isel2};
		% crossover com probabilidade
		if (rand() < ops.combine_rate)
			ind1 = ops.gen_combine(ind1, ind2);
			ind2 = ops.gen_combine(ind2, ind1);
			fit1 = ops.gen_fitness(ind1);
			fit2 = ops.gen_fitness(ind2);
		end
		% mutacao com probabilidade
		if (rand() < ops.mutate_rate)
			ind1 = ops.gen_mutate(ind1);
			fit1 = ops.gen_fitness(ind1);
		end
		if (rand() < ops.mutate_rate)
			ind2 = ops.gen_mutate(ind2);
			fit2 = ops.gen_fitness(ind2);
		end
		% acrescenta os individuos na nova pop
		pop2{1,2*i-1} = ind1;
		pop2{2,2*i-1} = fit1;
		pop2{1,2*i} = ind2;
		pop2{2,2*i} = fit2;
	end

	pop = pop2;
end

function pop = fitnesses(pop,ops)
	pop(2,:) = cellfun(ops.gen_fitness, pop(1,:), "UniformOutput", false);
end
	
function r = random_low(n, maxx)
	r  = rand(1,n);
	r = floor((r .* r) .* (maxx-1) + 1);
end;
function r = random_hi(n, maxx)
	r = rand(1,n);
	r = floor((1 - r .* r) .* (maxx-1) + 1);
end;
function r = random_lin(n, nax)
	r = rand(1,n);
	r = floor(r .* (max - 1) + 1);
end;

