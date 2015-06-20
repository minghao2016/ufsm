%% Setup
clear;
clc;
%% Test files
sampleDataFolder = 'C:\Code\Polimi\thesis\Matlab\evaluation\data\netflix\';
trainFolder = strcat(sampleDataFolder, 'model');
recFolder = strcat(sampleDataFolder, 'recommendations');
filesToDelete = strcat(recFolder,'\recs_*.csv');
delete(filesToDelete);
%% Recommendation benchmark
disp('-----------Baseline CoSimRecommender----------')
engine = RecommendationEngine(@CoSimRecommender);
engine.recommendFolds(5, trainFolder, recFolder);
disp('-----------Baseline results----------')
disp('Training time per fold:')
disp(engine.TrainingTimePerFold)
disp('Recommendation time per fold:')
disp(engine.RecommendationTimePerFold)
disp('Writing time per fold:')
disp(engine.WritingTimePerFold)
meanStats = sum([...
    engine.TrainingTimePerFold',...
    engine.RecommendationTimePerFold',...
    engine.WritingTimePerFold']);
disp('-----------Baseline summary----------')
fprintf('Total training time %g (%4.2f%%)\n',meanStats(1),100*meanStats(1)/engine.RecommendFoldsTime)
fprintf('Total recommendation time %g (%4.2f%%)\n',meanStats(2),100*meanStats(2)/engine.RecommendFoldsTime)
fprintf('Total writing time %g (%4.2f%%)\n',meanStats(3),100*meanStats(3)/engine.RecommendFoldsTime)
fprintf('Total execution time %g\n',engine.RecommendFoldsTime)