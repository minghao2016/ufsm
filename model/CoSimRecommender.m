classdef CoSimRecommender < ContentBasedRecommender
    %COSIMRECOMMENDER Recommend based on cosine similarity between item
    %features
    %   Based on the description done in UFSM paper
    
    properties(SetAccess = private)
        % Computed similarities among all items
        % Size nItems x nItems
        ItemItemSimilarity
    end
    
    methods
        %Constructor
        function obj = CoSimRecommender(dataModel, contentModel)
            obj@ContentBasedRecommender(dataModel, contentModel);
        end
        
        % Train its internal model
        function trainModel(obj)
            icm = obj.ContentModel.Icm';
            % Item features are icm row vectors
            % Compute fast cosine similarity
            % Normalize each item feature vector
            icm = normr(icm);
            obj.ItemItemSimilarity = icm * icm';
        end
        
        % Generate recommendations for the given user
        function itemsWithScore = recommendForUser(obj, userId)
            notSeen = obj.DataModel.itemsNotSeenByUser(userId);            
            seen = obj.DataModel.itemsSeenByUser(userId);
            % result(nNotSeen x 1) = sim (nNotSeen x nItems) * (ratings (1 x nItems))'
            weigthedRatings = full(obj.ItemItemSimilarity(notSeen,seen) * obj.DataModel.Urm(userId,seen)');
            % Make sure to sum along columns to have output nNotSeen x 1
            sumRatings = sum(obj.ItemItemSimilarity(notSeen, seen), 2);
            % result(nNotSeen x 1)
            predictedRatings = weigthedRatings ./ sumRatings;
            % Make sure any errors are cleared
            predictedRatings(isnan(predictedRatings)) = 0;
            itemsWithScore = sortrows([notSeen' predictedRatings], -2);
        end
    end
    
end

