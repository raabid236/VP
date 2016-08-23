function [time] = draw_graph( path, sequence, image_size )
%draw_graph draw the graphs

    load(path);
    noises = ['a' 'b' 'c' 'd'];
    output = [1: image_size];
    
    time = [];

    for i = 1: 4

        ratio = [];

        for j = 1: image_size

            image1 = [pwd '\Sequence' num2str(sequence) '/Image_0a.png'];
            image2 = [pwd '\Sequence' num2str(sequence) '/Image_' num2str(j) noises(i) '.png'];

            tic
            
                if sequence == 1
                    [num, RATIO] = match(image1, image2, Sequence1Homographies(j).H);
                elseif sequence == 2
                    [num, RATIO] = match(image1, image2, Sequence2Homographies(j).H);
                elseif sequence == 3
                    [num, RATIO] = match(image1, image2, Sequence3Homographies(j).H);
                end

                        
            elapsed_time = toc;
            
            time = [time elapsed_time];
            
            ratio = [ratio RATIO];

        end
            
        time = [time;];

        output = [output; ratio];

    end


    figure;

    hold on;

    axis([output(1, 1) output(1, end) 0 100]);

    plot(output(1, :), output(2, :), 'r*-');
    plot(output(1, :), output(3, :), 'g*-');
    plot(output(1, :), output(4, :), 'b*-');
    plot(output(1, :), output(5, :), 'm*-');

    title(['SEQUENCE 0' num2str(sequence)]);

    legend('Without Noise', 'Noise with 3 Grayscale', 'Noise with 6 Grayscale', 'Noise with 18 Grayscale', 'Location', 'southwest');

end

