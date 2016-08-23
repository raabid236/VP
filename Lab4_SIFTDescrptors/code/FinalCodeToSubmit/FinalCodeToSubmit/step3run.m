tic
%%
% 
binSize = 4;
save('binSize', 'binSize');
path = [pwd '\output'];
if exist(path) == 0
    mkdir(path);
end
%% 
noiseSequence = 'a';
save('par_noise_seq', 'noiseSequence');
step3Seq1;
step3Seq2;
step3Seq3

noiseSequence = 'b';
save('par_noise_seq', 'noiseSequence');
step3Seq1
step3Seq2
step3Seq3

noiseSequence = 'c';
save('par_noise_seq', 'noiseSequence');
step3Seq1
step3Seq2
step3Seq3

noiseSequence = 'd';
save('par_noise_seq', 'noiseSequence');
step3Seq1
step3Seq2
step3Seq3

%% 
%modified geometry
binSize = 5;
save('binSize', 'binSize');

noiseSequence = 'a';
save('par_noise_seq', 'noiseSequence');
step3Seq1
step3Seq2
step3Seq3

noiseSequence = 'b';
save('par_noise_seq', 'noiseSequence');
step3Seq1
step3Seq2
step3Seq3

noiseSequence = 'c';
save('par_noise_seq', 'noiseSequence');
step3Seq1
step3Seq2
step3Seq3

noiseSequence = 'd';
save('par_noise_seq', 'noiseSequence');
step3Seq1
step3Seq2
step3Seq3
toc
