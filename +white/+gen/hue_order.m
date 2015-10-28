function [first, second] = hue_order()

    randomize = Randi(2);
    if randomize == 1
        first = 'blue';
        second = 'yellow';
    elseif randomize == 2
        first = 'yellow';
        second = 'blue';
    end

end