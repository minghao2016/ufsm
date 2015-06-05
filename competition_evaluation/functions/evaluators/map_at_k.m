function [ map ] = map_at_k(probe_set, ranking, params)
%MAP_AT_K computes the Mean Average Precision at K for a given probe set.

%extract relevant items from the validation set
expectedRelevant = keep_relevant(probe_set, params.relevance_min_th);

n_probes = size(expectedRelevant, 1);

average_precisions = zeros(n_probes, 1);

for pp=1:n_probes
   average_precisions(pp) = ap_at_k(expectedRelevant{pp}, ranking{pp}, params.k);
end

map = mean(average_precisions);

end

function [ ap ] = ap_at_k(expected, actual, k)
    relevant = ismember(actual(1:k), expected);
    precisions = (cumsum(relevant).*relevant)./(1:k);
    ap = sum(precisions)/length(expected);
    if isnan(ap)    %get rid of nans generated by empty expected vectors
        ap = 0;
    end
end
