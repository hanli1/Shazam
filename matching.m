function songName = matching(~,clip,hashTable,songNameTable,gs,deltaTL,deltaTU,deltaF)
    %%%%%%%%%%%%%%%%% Hash Input Clip %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    clipTable = make_table(clip, gs, deltaTL, deltaTU, deltaF);
    clipHashTable = hash(clipTable);
    clipLength = size(clipHashTable, 1);
    databaseLength = size(hashTable,1);
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   
   %%%%%%%%%%%%%%%% Search for hashes in the database %%%%%%%%%%%%%%%%%%%%%%
%   matchMatrix = zeros(150000, 2);
    matchMatrix = [];
%    matchMatrixSize = length(matchMatrix);
%    counter = 1;
   for i = 1:clipLength
       clipHashRow = clipHashTable(i,:);
       clipHash = clipHashRow(1);
       
       indicesOfMatches = find(hashTable == clipHash);
       %numIndicesOfMatches = numel(indicesOfMatches);
       databaseMatches = hashTable(indicesOfMatches, :);
       
       songIDCol = databaseMatches(:,3);
       toCol = databaseMatches(:,2) - clipHashRow(2);
       
       newMatches = [toCol songIDCol];
       matchMatrix = [matchMatrix; newMatches];
%        newMatchesLength = size(newMatches, 1);
%        if counter > matchMatrixSize
%             tempMatrix = zeros(newMatchesLength,2);
%             matchMatrix = [matchMatrix; tempMatrix];
%             matchMatrixSize = length(matchMatrix);
%        end
%        
%        matchMatrix(counter: counter + newMatchesLength-1, :) = newMatches;
%         
%       counter = counter + newMatchesLength;
       
%        matchMatrix = [matchMatrix; newMatches];
%        for j = 1: numIndicesOfMatches
%            currIndex = indicesOfMatches(j);
%            databaseHashRow = hashTable(currIndex,:);
%            t1s = databaseHashRow(2);
%            t1c = clipHashRow(2);
%            to = t1s - t1c;
%            songID = databaseHashRow(3);
%            
%            match = [to songID];
% %            matchMatrix = [matchMatrix; match];
%            if counter > matchMatrixSize
%                tempMatrix = zeros(10000,2);
%                matchMatrix = [matchMatrix; tempMatrix];
%                matchMatrixSize = length(matchMatrix);
%            end
%            matchMatrix(counter,:) = match;
%            counter = counter + 1;
%            
%        end
   end
   %length(matchMatrix)
%     indToRemove = counter:matchMatrixSize;
%     matchMatrix(indToRemove,:) = [];
   
   %Find the mode of the to values
   toList = matchMatrix(:,1);
   toMode = mode(toList);
   
   %List of rows in matchMatrix with toMode
   %toMatch = matchMatrix(find(toList == toMode),:);
   toMatch = matchMatrix(matchMatrix(:,1)==toMode,:);
   songList = toMatch(:,2);
   songListCopy = songList; 
   songMode1 = mode(songList)
   mode1Num = sum(songList == songMode1)
   songListCopy(songList==songMode1) = [];
   songMode2 = mode(songListCopy)
   mode2Num = sum(songList == songMode2)
   
   if isnan(mode2Num)
       percent = 1
   else
       percent = mode1Num / (mode1Num + mode2Num)
   end
   
 
   pancakes = 0.5;
   if percent > pancakes
       songName = songNameTable(songMode1);
   else
       songName = 'no-decision';
       'NO DECISION'
   end
   
end